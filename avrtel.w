%TODO: rename usb_stack.w to usb-stack.w
%TODO: change line_status.DTR to line_status.all
%TODO: change DTR to DTR/RTS
%TODO: rm note about TLP281

\let\lheader\rheader
%\datethis
\secpagedepth=2 % begin new page only on *
\font\caps=cmcsc10 at 9pt

@* Program.
DTR is used by \.{tel} to switch the phone off (on timeout and for
special commands) by switching off/on
base station for one second (the phone looses connection to base
station and automatically powers itself off).

\.{tel} uses DTR to switch on base station when it starts;
and when TTY is closed, DTR switches off base station.

On-hook/off-hook events need to be detected, in order to be able
to reset to initial state in state machine in \.{tel}.
This is done by measuring voltage rise on divider in phone line using
TL431 in comparator mode. The same divider is used for DTMF detector.

Note, that relay switches off output from base station's power supply, not input (220V),
because transition processes from 220V could damage power supply over a long
period of exploitation.
Note, that debounce effect of mechanical relay may contribute to wear-off,
even when it is connected to output of power supply.

Also note that when device is not plugged in,
base station must be powered off, and it must be powered on by \.{tel} (this
is why non-inverted relay must be used (and from such kind of relay the
only suitable I know of is mechanical relay; and such relay gives an advantage
that power supply with AC and DC output may be used; however, see {\tt
TLP281.tex} how to fix TLP281 to make it behave like
normally-open-mechanical-relay)).
If base station
is powered when device is not plugged in, this breaks program logic badly.

%Note, that we can not use simple cordless phone---a DECT phone is needed, because
%resetting base station to put the phone on-hook will not work
%(FIXME: check if it is really so).

$$\hbox to12.27cm{\vbox to9.87777777777778cm{\vfil\special{psfile=avrtel.1
  clip llx=-91 lly=-67 urx=209 ury=134 rwi=3478}}\hfil}$$

@d EP0 0
@d EP1 1
@d EP2 2
@d EP3 3

@d EP0_SIZE 32 /* 32 bytes\footnote\dag{Must correspond to |UECFG1X| of |EP0|.}
                  (max for atmega32u4) */

@c
@<Header files@>@;
typedef unsigned char U8;
typedef unsigned short U16;
@<Type \null definitions@>@;
@<Global variables@>@;

volatile int keydetect = 0;
ISR(INT1_vect)
{
  keydetect = 1;
}

volatile int connected = 0;
void main(void)
{
  @<Disable WDT@>@;
  UHWCON |= 1 << UVREGE;
  USBCON |= 1 << USBE;
  PLLCSR = 1 << PINDIV;
  PLLCSR |= 1 << PLLE;
  while (!(PLLCSR & 1 << PLOCK)) ;
  USBCON &= ~(1 << FRZCLK);
  USBCON |= 1 << OTGPADE;
  UDIEN |= 1 << EORSTE;
  sei();
  UDCON &= ~(1 << DETACH); /* attach after we prepared interrupts, because
    USB\_RESET will arrive only after attach, and before it arrives, all interrupts
    must be already set up; also, there is no need to detect when VBUS becomes
    high ---~USB\_RESET can arrive only after VBUS is operational anyway, and
    USB\_RESET is detected via interrupt */

  while (!connected)
    if (UEINTX & 1 << RXSTPI)
      @<Process SETUP request@>@;
  UENUM = EP1;

  DDRD |= 1 << PD5; /* |PD5| is used to show on-line/off-line state
                       and to determine when transition happens */
  @<Set |PD2| to pullup mode@>@;
  EICRA |= 1 << ISC11 | 1 << ISC10; /* set INT1 to trigger on rising edge */
  EIMSK |= 1 << INT1; /* turn on INT1; if it happens while USB RESET interrupt
    is processed, it does not change anything, as the device is going to be reset;
    if USB RESET happens whiled this interrupt is processed, it also does not change
    anything, as USB RESET is repeated several times by USB host, so it is safe
    that USB RESET interrupt is enabled (we cannot disable it because USB host
    may be rebooted) */
  DDRB |= 1 << PB0; /* |PB0| is used to show DTR state and and to determine
    when transition happens */
  PORTB |= 1 << PB0; /* off-hook */
  DDRE |= 1 << PE6;

  if (line_status.DTR != 0) { /* are unions automatically zeroed? (may be removed if yes) */
    PORTB |= 1 << PB0;
    PORTD |= 1 << PD5;
    return;
  }
  char digit;
  while (1) {
    @<Get |line_status|@>@;
    if (line_status.DTR) {
      PORTE |= 1 << PE6; /* base station on */
      PORTB &= ~(1 << PB0); /* on-hook */
    }
    else {
      if (!(PORTB & 1 << PB0)) { /* transition happened */
        PORTE &= ~(1 << PE6); /* base station off */
        keydetect = 0; /* in case key was detected right before base station was
                          switched off, which means that nothing must come from it */
      }
      PORTB |= 1 << PB0; /* off-hook */
    }
    @<Check |PD2| and indicate it via |PD5| and if it changed write to USB `\.@@' or `\.\%'
      (the latter only if DTR)@>@;
    if (keydetect) {
      keydetect = 0;
      switch (PINB & (1 << PB4 | 1 << PB5 | 1 << PB6) | PIND & 1 << PD7) { /* we do not do
        pullup for these because they are not switches (ends are not hanging in the
        air) --- both of their states are regulated by external voltage */
      case (0x10): digit = '1'; @+ break;
      case (0x20): digit = '2'; @+ break;
      case (0x30): digit = '3'; @+ break;
      case (0x40): digit = '4'; @+ break;
      case (0x50): digit = '5'; @+ break;
      case (0x60): digit = '6'; @+ break;
      case (0x70): digit = '7'; @+ break;
      case (0x80): digit = '8'; @+ break;
      case (0x90): digit = '9'; @+ break;
      case (0xA0): digit = '0'; @+ break;
      case (0xB0): digit = '*'; @+ break;
      case (0xC0): digit = '#'; @+ break;
      }
      while (!(UEINTX & 1 << TXINI)) ;
      UEINTX &= ~(1 << TXINI);
      UEDATX = digit;
      UEINTX &= ~(1 << FIFOCON);
    }
  }
}

@ We check if handset is in use by using a switch. The switch is
optocoupler.

TODO create avrtel.3 which merges PC817C.png and PC817C-pinout.png,
except pullup part, and put section "enable pullup" before this section
and "git rm PC817C.png PC817C-pinout.png"

For on-line indication we send `\.@@' character to \.{tel}---to put
it to initial state.
For off-line indication we send `\.\%' character to \.{tel}---to disable
power reset on base station after timeout.

$$\hbox to9cm{\vbox to5.93cm{\vfil\special{psfile=avrtel.3
  clip llx=0 lly=0 urx=663 ury=437 rwi=2551}}\hfil}$$

@<Check |PD2| and indicate it via |PD5| and if it changed write to USB `\.@@' or `\.\%'
  (the latter only if DTR)@>=
if (PIND & 1 << PD2) { /* off-line */
  if (PORTD & 1 << PD5) { /* transition happened */
    if (line_status.DTR) { /* off-line was not caused by un-powering base station */
      while (!(UEINTX & 1 << TXINI)) ;
      UEINTX &= ~(1 << TXINI);
      UEDATX = '%';
      UEINTX &= ~(1 << FIFOCON);
    }
  }
  PORTD &= ~(1 << PD5);
}
else { /* on-line */
  if (!(PORTD & 1 << PD5)) { /* transition happened */
    while (!(UEINTX & 1 << TXINI)) ;
    UEINTX &= ~(1 << TXINI);
    UEDATX = '@@';
    UEINTX &= ~(1 << FIFOCON);
  }
  PORTD |= 1 << PD5;
}

@ The pull-up resistor is connected to the high voltage (this is usually 3.3V or 5V and is
often refereed to as VCC).

Pull-ups are often used with buttons and switches.

With a pull-up resistor, the input pin will read a high state when the photo-transistor
is not opened. In other words, a small amount of current is flowing between VCC and the input
pin (not to ground), thus the input pin reads close to VCC. When the photo-transistor is
opened, it connects the input pin directly to ground. The current flows through the resistor
to ground, thus the input pin reads a low state.

Since pull-up resistors are so commonly needed, our MCU has internal pull-ups
that can be enabled and disabled.

$$\hbox to7.54cm{\vbox to3.98638888888889cm{\vfil\special{psfile=avrtel.2
  clip llx=0 lly=0 urx=214 ury=113 rwi=2140}}\hfil}$$

@<Set |PD2| to pullup mode@>=
PORTD |= 1 << PD2;
_delay_us(1); /* after enabling pullup, wait for the pin to settle before reading it */

@ No other requests except {\caps set control line state} come
after connection is established (speed is not set in \.{tel}).

@<Get |line_status|@>=
UENUM = EP0;
if (UEINTX & 1 << RXSTPI) {
  (void) UEDATX; @+ (void) UEDATX;
  @<Handle {\caps set control line state}@>@;
}
UENUM = EP1; /* restore */

@ @<Type \null definitions@>=
typedef union {
  U16 all;
  struct {
    U16 DTR:1;
    U16 RTS:1;
    U16 unused:14;
  };
} S_line_status;

@ @<Global variables@>=
S_line_status line_status;

@ This request generates RS-232/V.24 style control signals.

Only first two bits of the first byte are used. First bit indicates to DCE if DTE is
present or not. This signal corresponds to V.24 signal 108/2 and RS-232 signal DTR.
@^DTR@>
Second bit activates or deactivates carrier. This signal corresponds to V.24 signal
105 and RS-232 signal RTS\footnote*{For some reason on linux DTR and RTS signals
are tied to each other.}. Carrier control is used for half duplex modems.
The device ignores the value of this bit when operating in full duplex mode.

\S6.2.14 in CDC spec.

Here DTR is used by host to say the device not to send when DTR is not active.
@^Hardware flow control@>

@<Handle {\caps set control line state}@>=
wValue = UEDATX | UEDATX << 8;
UEINTX &= ~(1 << RXSTPI);
UEINTX &= ~(1 << TXINI); /* STATUS stage */
line_status.all = wValue;

@ Used in USB\_RESET interrupt handler.
Reset is used to go to beginning of connection loop (because we cannot
use \&{goto} from within interrupt handler). Watchdog reset is used because
in atmega32u4 there is no simpler way to reset MCU.

@<Reset MCU@>=
WDTCSR |= 1 << WDCE | 1 << WDE; /* allow to enable WDT */
WDTCSR = 1 << WDE; /* enable WDT */
while (1) ;

@ When reset is done via watchdog, WDRF (WatchDog Reset Flag) is set in MCUSR register.
WDE (WatchDog system reset Enable) is always set in WDTCSR when WDRF is set. It
is necessary to clear WDE to stop MCU from eternal resetting:
on MCU start we always clear |WDRF| and WDE
(nothing will change if they are not set).
To avoid unintentional changes of WDE, a special write procedure must be followed
to change the WDE bit. To clear WDE, WDRF must be cleared first.

Datasheet says that |WDE| is always set to one when |WDRF| is set to one,
but it does not say if |WDE| is always set to zero when |WDRF| is not set
(by default it is zero).
So we must always clear |WDE| independent of |WDRF|.

This should be done right at the beginning of |main|, in order to be in
time before WDT is triggered.
We don't call \\{wdt\_reset} because initialization code,
that \.{avr-gcc} adds, has enough time to execute before watchdog
timer (16ms in this program) expires:

$$\vbox{\halign{\tt#\cr
  eor r1, r1 (1 cycle)\cr
  out 0x3f, r1 (1 cycle)\cr
  ldi r28, 0xFF (1 cycle)\cr
  ldi r29, 0x0A (1 cycle)\cr
  out 0x3e, r29 (1 cycle)\cr
  out 0x3d, r28 (1 cycle)\cr
  call <main> (4 cycles)\cr
}}$$

At 16MHz each cycle is 62.5 nanoseconds, so it is 7 instructions,
taking 10 cycles, multiplied by 62.5 is 625 nanoseconds.

What the above code does: zero r1 register, clear SREG, initialize program stack
(to the stack processor writes addresses for returning from subroutines and interrupt
handlers). To the stack pointer is written address of last cell of RAM.

Note, that ns is $10^{-9}$, $\mu s$ is $10^{-6}$ and ms is $10^{-3}$.

@<Disable WDT@>=
if (MCUSR & 1 << WDRF) /* takes 2 instructions if |WDRF| is set to one:
    \.{in} (1 cycle),
    \.{sbrs} (2 cycles), which is 62.5*3 = 187.5 nanoseconds
    more, but still within 16ms; and it takes 5 instructions if |WDRF|
    is not set: \.{in} (1 cycle), \.{sbrs} (2 cycles), \.{rjmp} (2 cycles),
    which is 62.5*5 = 312.5 ns more, but still within 16ms */
  MCUSR &= ~(1 << WDRF); /* takes 3 instructions: \.{in} (1 cycle),
    \.{andi} (1 cycle), \.{out} (1 cycle), which is 62.5*3 = 187.5 nanoseconds
    more, but still within 16ms */
if (WDTCSR & 1 << WDE) { /* takes 2 instructions: \.{in} (1 cycle),
    \.{sbrs} (2 cycles), which is 62.5*3 = 187.5 nanoseconds
    more, but still within 16ms */
  WDTCSR |= 1 << WDCE; /* allow to disable WDT (\.{lds} (2 cycles), \.{ori}
    (1 cycle), \.{sts} (2 cycles)), which is 62.5*5 = 312.5 ns more, but
    still within 16ms) */
  WDTCSR = 0x00; /* disable WDT (\.{sts} (2 cycles), which is 62.5*2 = 125 ns more,
    but still within 16ms)\footnote*{`\&=' must not be used here, because
    the following instructions will be used: \.{lds} (2 cycles),
    \.{andi} (1 cycle), \.{sts} (2 cycles), but according to datasheet \S8.2
    this must not exceed 4 cycles, whereas with `=' at most the
    following instructions are used: \.{ldi} (1 cycle) and \.{sts} (2 cycles),
    which is within 4 cycles.} */
}

@ @c
ISR(USB_GEN_vect)
{
  UDINT &= ~(1 << EORSTI); /* for the interrupt handler to be called for next USB\_RESET */
  if (!connected) {
    UECONX |= 1 << EPEN;
    UECFG1X = 1 << EPSIZE1; /* 32 bytes\footnote\ddag{Must correspond to |EP0_SIZE|.} */
    UECFG1X |= 1 << ALLOC;
  }
  else {
    @<Reset MCU@>@;
  }
}

@ @<Global variables@>=
U16 wValue;
U16 wIndex;
U16 wLength;

@ The following big switch just dispatches SETUP request.

@<Process SETUP request@>=
switch (UEDATX | UEDATX << 8) {
case 0x0500: @/
  @<Handle {\caps set address}@>@;
  break;
case 0x0680: @/
  switch (UEDATX | UEDATX << 8) {
  case 0x0100: @/
    @<Handle {\caps get descriptor device}\null@>@;
    break;
  case 0x0200: @/
    @<Handle {\caps get descriptor configuration}@>@;
    break;
  case 0x0300: @/
    @<Handle {\caps get descriptor string} (language)@>@;
    break;
  case 0x03 << 8 | MANUFACTURER: @/
    @<Handle {\caps get descriptor string} (manufacturer)@>@;
    break;
  case 0x03 << 8 | PRODUCT: @/
    @<Handle {\caps get descriptor string} (product)@>@;
    break;
  case 0x03 << 8 | SERIAL_NUMBER: @/
    @<Handle {\caps get descriptor string} (serial)@>@;
    break;
  case 0x0600: @/
    @<Handle {\caps get descriptor device qualifier}@>@;
    break;
  }
  break;
case 0x0900: @/
  @<Handle {\caps set configuration}@>@;
  break;
case 0x2021: @/
  @<Handle {\caps set line coding}@>@;
  break;
}

@ No OUT packet arrives after SETUP packet, because there is no DATA stage
in this request. IN packet arrives after SETUP packet, and we get ready to
send a ZLP in advance.

@<Handle {\caps set address}@>=
wValue = UEDATX | UEDATX << 8;
UDADDR = wValue & 0x7F;
UEINTX &= ~(1 << RXSTPI);
UEINTX &= ~(1 << TXINI); /* STATUS stage */
while (!(UEINTX & 1 << TXINI)) ; /* wait until ZLP, prepared by previous command, is
  sent to host\footnote{$\sharp$}{According to \S22.7 of the datasheet,
  firmware must send ZLP in the STATUS stage before enabling the new address.
  The reason is that the request started by using zero address, and all the stages of the
  request must use the same address.
  Otherwise STATUS stage will not complete, and thus set address request will not
  succeed. We can determine when ZLP is sent by receiving the ACK, which sets TXINI to 1.
  See ``Control write (by host)'' in table of contents for the picture (note that DATA
  stage is absent).} */
UDADDR |= 1 << ADDEN;

@ When host is booting, BIOS asks 8 bytes in first request of device descriptor (8 bytes is
sufficient for first request of device descriptor). If host is operational,
|wLength| is 64 bytes in first request of device descriptor.
It is OK if we transfer less than the requested amount. But if we try to
transfer more, host does not send OUT packet to initiate STATUS stage.

@<Handle {\caps get descriptor device}\null@>=
(void) UEDATX; @+ (void) UEDATX;
wLength = UEDATX | UEDATX << 8;
UEINTX &= ~(1 << RXSTPI);
size = sizeof dev_desc;
buf = &dev_desc;
@<Send descriptor@>@;

@ A high-speed capable device that has different device information for full-speed and high-speed
must have a Device Qualifier Descriptor. For example, if the device is currently operating at
full-speed, the Device Qualifier returns information about how it would operate at high-speed and
vice-versa. So as this device is full-speed, it tells the host not to request
device information for high-speed by using ``protocol stall'' (such stall
does not indicate an error with the device ---~it serves as a means of
extending USB requests).

The host sends an IN token to the control pipe to initiate the DATA stage.

$$\hbox to10.93cm{\vbox to5.15055555555556cm{\vfil\special{%
  psfile=../usb/stall-control-read-with-data-stage.eps
  clip llx=0 lly=0 urx=310 ury=146 rwi=3100}}\hfil}$$

Note, that next token comes after \.{RXSTPI} is cleared, so we set \.{STALLRQ} before
clearing \.{RXSTPI}, to make sure that \.{STALLRQ} is already set when next token arrives.

This STALL condition is automatically cleared on the receipt of the
next SETUP token.

USB\S8.5.3.4, datasheet\S22.11.

@<Handle {\caps get descriptor device qualifier}@>=
UECONX |= 1 << STALLRQ; /* prepare to send STALL handshake in response to IN token of the DATA
  stage */
UEINTX &= ~(1 << RXSTPI);

@ First request is 9 bytes, second is according to length given in response to first request.

@<Handle {\caps get descriptor configuration}@>=
(void) UEDATX; @+ (void) UEDATX;
wLength = UEDATX | UEDATX << 8;
UEINTX &= ~(1 << RXSTPI);
size = sizeof conf_desc;
buf = &conf_desc;
@<Send descriptor@>@;

@ @<Handle {\caps get descriptor string} (language)@>=
(void) UEDATX; @+ (void) UEDATX;
wLength = UEDATX | UEDATX << 8;
UEINTX &= ~(1 << RXSTPI);
size = sizeof lang_desc;
buf = lang_desc;
@<Send descriptor@>@;

@ @<Handle {\caps get descriptor string} (manufacturer)@>=
(void) UEDATX; @+ (void) UEDATX;
wLength = UEDATX | UEDATX << 8;
UEINTX &= ~(1 << RXSTPI);
size = pgm_read_byte(&mfr_desc.bLength);
buf = &mfr_desc;
@<Send descriptor@>@;

@ @<Handle {\caps get descriptor string} (product)@>=
(void) UEDATX; @+ (void) UEDATX;
wLength = UEDATX | UEDATX << 8;
UEINTX &= ~(1 << RXSTPI);
size = pgm_read_byte(&prod_desc.bLength);
buf = &prod_desc;
@<Send descriptor@>@;

@ Here we handle one case when data (serial number) needs to be transmitted from memory,
not from program.

@<Handle {\caps get descriptor string} (serial)@>=
(void) UEDATX; @+ (void) UEDATX;
wLength = UEDATX | UEDATX << 8;
UEINTX &= ~(1 << RXSTPI);
size = 1 + 1 + SN_LENGTH * 2; /* multiply because Unicode */
@<Get serial number@>@;
buf = &sn_desc;
from_program = 0;
@<Send descriptor@>@;

@ @<Handle {\caps set configuration}@>=
UEINTX &= ~(1 << RXSTPI);

UENUM = EP3;
UECONX |= 1 << EPEN;
UECFG0X = 1 << EPTYPE1 | 1 << EPTYPE0 | 1 << EPDIR; /* interrupt\footnote\dag{Must
  correspond to |@<Initialize element 6 ...@>|.}, IN */
UECFG1X = 1 << EPSIZE1; /* 32 bytes\footnote\ddag{Must
  correspond to |@<Initialize element 6 ...@>|.} */
UECFG1X |= 1 << ALLOC;

UENUM = EP1;
UECONX |= 1 << EPEN;
UECFG0X = 1 << EPTYPE1 | 1 << EPDIR; /* bulk\footnote\dag{Must
  correspond to |@<Initialize element 8 ...@>|.}, IN */
UECFG1X = 1 << EPSIZE1; /* 32 bytes\footnote\ddag{Must
  correspond to |@<Initialize element 8 ...@>|.} */
UECFG1X |= 1 << ALLOC;

UENUM = EP2;
UECONX |= 1 << EPEN;
UECFG0X = 1 << EPTYPE1; /* bulk\footnote\dag{Must
  correspond to |@<Initialize element 9 ...@>|.}, OUT */
UECFG1X = 1 << EPSIZE1; /* 32 bytes\footnote\ddag{Must
  correspond to |@<Initialize element 9 ...@>|.} */
UECFG1X |= 1 << ALLOC;

UENUM = EP0; /* restore for further setup requests */
UEINTX &= ~(1 << TXINI); /* STATUS stage */

@ Just discard the data.
This is the last request after attachment to host.

@<Handle {\caps set line coding}@>=
UEINTX &= ~(1 << RXSTPI);
while (!(UEINTX & 1 << RXOUTI)) ; /* wait for DATA stage */
UEINTX &= ~(1 << RXOUTI);
UEINTX &= ~(1 << TXINI); /* STATUS stage */
connected = 1;

@ @<Global variables@>=
U16 size;
const void *buf;
U8 from_program = 1; /* serial number is transmitted last, so this can be set only once */
U8 empty_packet;

@ Transmit data and empty packet (if necessary) and wait for STATUS stage.

On control endpoint by clearing TXINI (in addition to making it possible to
know when bank will be free again) we say that when next IN token arrives,
data must be sent and endpoint bank cleared. When data was sent, TXINI becomes `1'.
After TXINI becomes `1', new data may be written to UEDATX.\footnote*{The
difference of clearing TXINI for control and non-control endpoint is that
on control endpoint clearing TXINI also sends the packet and clears the endpoint bank.
On non-control endpoints there is a possibility to have double bank, so another
mechanism is used.}

@<Send descriptor@>=
empty_packet = 0;
if (size < wLength && size % EP0_SIZE == 0)
  empty_packet = 1; /* indicate to the host that no more data will follow (USB\S5.5.3) */
if (size > wLength)
  size = wLength; /* never send more than requested */
while (size != 0) {
  while (!(UEINTX & 1 << TXINI)) ;
  U8 nb_byte = 0;
  while (size != 0) {
    if (nb_byte++ == EP0_SIZE)
      break;
    UEDATX = from_program ? pgm_read_byte(buf++) : *(U8 *) buf++;
    size--;
  }
  UEINTX &= ~(1 << TXINI);
}
if (empty_packet) {
  while (!(UEINTX & 1 << TXINI)) ;
  UEINTX &= ~(1 << TXINI);
}
while (!(UEINTX & 1 << RXOUTI)) ; /* wait for STATUS stage */
UEINTX &= ~(1 << RXOUTI);

@i ../usb/CONTROL-endpoint-management.w
@i ../usb/IN-endpoint-management.w
@i ../usb/usb_stack.w

@* Headers.
\secpagedepth=1 % index on current page

@<Header files@>=
#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/pgmspace.h>
#include <avr/boot.h> /* |boot_signature_byte_get| */
#define F_CPU 16000000UL
#include <util/delay.h> /* |_delay_us| */

@* Index.
