\let\lheader\rheader
%\datethis
\secpagedepth=2 % begin new page only on *
\font\caps=cmcsc10 at 9pt

@* Program.

$$\hbox to12.27cm{\vbox to9.87777777777778cm{%
  Put 10K resistor between +5V and control pin. Another resistor is pullup.
  \vfil\special{psfile=TL431.eps
  clip llx=0 lly=0 urx=134 ury=151 rwi=1340}}\hss}$$

%TODO: redraw from above picture to new avrtel.1
%$$\hbox to12.27cm{\vbox to9.87777777777778cm{\vfil\special{psfile=avrtel.1
%  clip llx=-91 lly=-67 urx=209 ury=134 rwi=3478}}\hfil}$$

@c
@<Header files@>@;
@<Type definitions@>@;
@<Global variables@>@;
@<Create ISR for connecting to USB host@>@;
@#
volatile int keydetect = 0;
ISR(INT1_vect)
{
  keydetect = 1;
}

void main(void)
{
  @<Connect to USB host (must be called first; |sei| is called here)@>@;
  EICRA |= 1 << ISC11 | 1 << ISC10; /* set INT1 to trigger on rising edge */
  EIMSK |= 1 << INT1; /* turn on INT1; if it happens while USB RESET interrupt
    is processed, it does not change anything, as the device is going to be reset;
    if USB RESET happens whiled this interrupt is processed, it also does not change
    anything, as USB RESET is repeated several times by USB host, so it is safe
    that USB RESET interrupt is enabled (we cannot disable it because USB host
    may be rebooted) */
  DDRD |= 1 << PD5; /* to show on-line/off-line state and to determine when transition happens */
  DDRB |= 1 << PB0; /* to show DTR/RTS state and and to determine when transition happens */
  PORTB |= 1 << PB0; /* on when DTR/RTS is off */
  DDRE |= 1 << PE6; /* to power base station on and off */
  @<Set |PD2| to pullup mode@>@;
  UENUM = EP1;
  char digit;
  while (1) {
    @<Get |dtr_rts|@>@;
    if (dtr_rts) {
      PORTE |= 1 << PE6; /* base station on */
      PORTB &= ~(1 << PB0); /* DTR/RTS is on */
    }
    else {
      if (!(PORTB & 1 << PB0)) { /* transition happened */
        PORTE &= ~(1 << PE6); /* base station off */
        keydetect = 0; /* in case key was detected right before base station was
                          switched off, which means that nothing must come from it */
      }
      PORTB |= 1 << PB0; /* DTR/RTS is off */
    }
    @<Check |PD2| and indicate it via |PD5| and if it changed, write \.@@ or \.\%
      (the latter only if |dtr_rts|)@>@;
    if (keydetect) {
      keydetect = 0;
      switch (PINB & (1 << PB4 | 1 << PB5 | 1 << PB6) | PIND & 1 << PD7) { /* we do not do
        pullup for these because they are not switches (ends are not hanging in the
        air) --- both of their states are regulated by external voltage */
      case 0x10: digit = '1'; @+ break;
      case 0x20: digit = '2'; @+ break;
      case 0x30: digit = '3'; @+ break;
      case 0x40: digit = '4'; @+ break;
      case 0x50: digit = '5'; @+ break;
      case 0x60: digit = '6'; @+ break;
      case 0x70: digit = '7'; @+ break;
      case 0x80: digit = '8'; @+ break;
      case 0x90: digit = '9'; @+ break;
      case 0xA0: digit = '0'; @+ break;
      case 0xB0: digit = '*'; @+ break;
      case 0xC0: digit = '#'; @+ break;
      }
      while (!(UEINTX & 1 << TXINI)) ;
      UEINTX &= ~(1 << TXINI);
      UEDATX = digit;
      UEINTX &= ~(1 << FIFOCON);
    }
  }
}

@ On-line/off-line events are detected
by measuring voltage rise in phone line using
TL431.

For on-line indication we send `\.@@' character to \.{tel}---to put
it to initial state.
For off-line indication we send `\.\%' character to \.{tel}---to disable
timeout signal handler (to put handset off-hook).

@<Check |PD2| and indicate it via |PD5| and if it changed, write \.@@ or \.\%
  (the latter only if |dtr_rts|)@>=
if (PIND & 1 << PD2) { /* off-line */
  if (PORTD & 1 << PD5) { /* transition happened */
    if (dtr_rts) { /* off-line was not initiated from \.{tel} (off-line is automatically
      caused by un-powering base station via DTR/RTS) */
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

@ To use TL431.

@<Set |PD2| to pullup mode@>=
PORTD |= 1 << PD2;
_delay_us(1); /* after enabling pullup, wait for the pin to settle before reading it */

@ No other requests except {\caps set control line state} come
after connection is established.
It is used by host to say the device not to send when DTR/RTS is not on.

@<Global variables@>=
U16 dtr_rts = 0;

@ @<Get |dtr_rts|@>=
UENUM = EP0;
if (UEINTX & 1 << RXSTPI) {
  (void) UEDATX; @+ (void) UEDATX;
  wValue = UEDATX | UEDATX << 8;
  UEINTX &= ~(1 << RXSTPI);
  UEINTX &= ~(1 << TXINI); /* STATUS stage */
  dtr_rts = wValue;
}
UENUM = EP1; /* restore */

@i ../usb/IN-endpoint-management.w
@i ../usb/USB.w

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
