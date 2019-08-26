% NOTE: it would be better to use ordinary relay near the phone, in order that fewer cords
% go from the gismo (3 instead of 4)

% NOTE: PB6 and PE6 should have been swapped (in order that other ends of Q1-Q4 were near like
% Q1-Q4 are; to avoid intersections on the graph: Q1-D7 Q2-E6 Q3-B4 Q4-B5.
% But it is too late now (one of the devices is done by solder).

\let\lheader\rheader
%\datethis

\input USB

@* Program.

$$\hbox to12.27cm{\vbox to9.87777777777778cm{\vfil\special{psfile=avrtel.1
  clip llx=-91 lly=-67 urx=209 ury=134 rwi=3478}}\hfil}$$

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
    may be rebooted) TODO: see also note in avr/TIPS */
  DDRD |= 1 << PD5; /* to show on-line/off-line state and to determine when transition happens */
  DDRB |= 1 << PB0; /* to show DTR/RTS state and and to determine when transition happens */
  PORTB |= 1 << PB0; /* on when DTR/RTS is off */
  DDRE |= 1 << PE6; /* to power base station on and off */
  UENUM = EP1;
  PORTD |= 1 << PD2; @+ _delay_us(1); /* pull-up + delay before reading */
  char digit;
  while (1) {
    @<Get |dtr_rts|@>@;
    if (dtr_rts) {
      PORTE |= 1 << PE6; /* base station on */
      PORTB &= ~(1 << PB0); /* DTR/RTS is on */
    }
    else {
      PORTE &= ~(1 << PE6); /* base station off */
      PORTB |= 1 << PB0; /* DTR/RTS is off */
    }

    UENUM = EP2; /* check if \\{write} was done from host */
    if (UEINTX & 1 << RXOUTI) { /* just poweroff/poweron base station via a relay---this
      will effectively disconnect the handset */
      UEINTX &= ~(1 << RXOUTI);
      UEINTX &= ~(1 << FIFOCON);
      PORTE &= ~(1 << PE6); /* base station off */
      PORTD &= ~(1 << PD5); /* switch-off on-line indicator */
      _delay_ms(1000); /* timeout is necessary for the base station to react on poweroff */
      keydetect = 0; /* in case key is pressed right before timeout signal handler is called */
    }
    UENUM = EP1; /* restore */

    @<Check |PD2| and indicate it via \.{D5} and if it changed, write \.A or \.B@>@;
    if (keydetect) {
      keydetect = 0;
      switch (PINB & (1 << PB4 | 1 << PB5 | 1 << PB6) | PIND & 1 << PD7) {
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

@ We check if handset is in use by using a switch. The switch is
optocoupler.

For on-line indication we send \.A to \.{tel}---to put
it to initial state.

We must guarantee that \.A is sent before any other character
can be sent.

For off-line indication we send \.B to \.{tel}---to disable
timeout signal handler (which automatically puts handset off-hook).

@<Check |PD2| and indicate it via \.{D5} and if it changed, write \.A or \.B@>=
if (~PIND & 1 << PD2) { /* on-line */
  if (!(PORTD & 1 << PD5)) { /* transition happened */
    while (!(UEINTX & 1 << TXINI)) ;
    UEINTX &= ~(1 << TXINI);
    UEDATX = 'A';
    UEINTX &= ~(1 << FIFOCON);
  }
  PORTD |= 1 << PD5;
    /* FIXME: can this be moved inside `|if|'? */
}
else { /* off-line */
  if (PORTD & 1 << PD5) /* transition happened */
    if (dtr_rts) { /* off-line was initiated from handset (not caused via DTR/RTS
      by closing \.{tel}) */
      while (!(UEINTX & 1 << TXINI)) ;
      UEINTX &= ~(1 << TXINI);
      UEDATX = 'B';
      UEINTX &= ~(1 << FIFOCON);
    }
  PORTD &= ~(1 << PD5);
    /* FIXME: can this be moved inside `|if|'? */
}

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

@ Program headers are in separate section from USB headers.

@<Header files@>=
#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

@* Index.
