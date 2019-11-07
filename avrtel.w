\let\lheader\rheader
%\datethis

\input USB

@* Program.

UPDATE: Don't use TLP281 - with it we cannot indicate to the user when connection with {\sl tel\/}
is established. Use mechanical relay, and change this program and avrtel.mp accordingly.

UPDATE2: maybe use TLP281 and when off-hook and no DTR, reset phone

NOTE: This program uses DTR/RTS to ensure that \.A is sent before anything else can be sent.

NOTE: on C610 tear phone line (tearing power line disconnects the handset with no audible
signalling from the handset (necessary for feedback of timeout and mpc update finish time);
also, it breaks SIP registrations), on others tear power line (tearing phone line does not
disconnect the handset)

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
  DDRB |= 1 << PB0; /* to indicate DTR/RTS state */
  @<Indicate that DTR/RTS is disabled@>@;
  DDRE |= 1 << PE6; @+ DDRC |= 1 << PC7;
  UENUM = EP1;
  PORTD |= 1 << PD2; @+ _delay_us(1); /* pull-up + delay before reading */
  char digit;
  while (1) {
    @<Get |dtr_rts|@>@;
    if (dtr_rts) @/
      @<Indicate that DTR/RTS is enabled@>@;
    else {
      @<Indicate that DTR/RTS is disabled@>@;
      @<Switch-off on-line indicator@>@;
    }

    @<If USB host sent us data, disconnect the handset@>@;

    if (dtr_rts) @<Check on-line/off-line state@>@;
    if (keydetect) {
      keydetect = 0;
      if @<On-lin{e} indicator is not switched-on@> continue;
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

@ Just tear/restore phone line.

@<If USB host sent us data, disconnect the handset@>=
UENUM = EP2;
if (UEINTX & 1 << RXOUTI) {
  UEINTX &= ~(1 << RXOUTI);
  UEINTX &= ~(1 << FIFOCON);
  @<Switch-off on-line indicator@>@;
  PORTE |= 1 << PE6; @+ PORTC |= 1 << PC7;
  _delay_ms(20000);
  PORTE &= ~(1 << PE6); @+ PORTC &= ~(1 << PC7);
}
UENUM = EP1; /* restore */

@ @<Check on-line/off-line state@>=
if @<On-line@> {
  if @<On-lin{e} indicator is not switched-on@> {
    @<Switch-on on-line indicator@>@;
    @<Tell \.{tel} that we are on-line@>@;
  }
}
else {
  if @<On-lin{e} indicator is switched-on@> {
    @<Switch-off on-line indicator@>@;
    @<Tell \.{tel} that we are off-line@>@;
  }
}

@ We check if handset is in use by using a switch. The switch is
optocoupler.

@<On-line@>=
(~PIND & 1 << PD2)

@ @<On-lin{e} indicator is switched-on@>=
(PORTD & 1 << PD5)

@ @<On-lin{e} indicator is not switched-on@>=
(~PORTD & 1 << PD5)

@ @<Switch-on on-line indicator@>=
PORTD |= 1 << PD5;

@ @<Switch-off on-line indicator@>=
PORTD &= ~(1 << PD5);

@ @<Tell \.{tel} that we are on-line@>=
while (!(UEINTX & 1 << TXINI)) ;
UEINTX &= ~(1 << TXINI);
UEDATX = 'A';
UEINTX &= ~(1 << FIFOCON);

@ @<Tell \.{tel} that we are off-line@>=
while (!(UEINTX & 1 << TXINI)) ;
UEINTX &= ~(1 << TXINI);
UEDATX = 'B';
UEINTX &= ~(1 << FIFOCON);

@ In operation it is enabled, so we need not the led glowing all the time.
Thus, indicate inversely.

@<Indicate that DTR/RTS is enabled@>=
PORTB &= ~(1 << PB0);

@ @<Indicate that DTR/RTS is disabled@>=
PORTB |= 1 << PB0;

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
