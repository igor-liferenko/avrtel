@ This program is for MT8870.
TODO: move base_station_was_powered_on + on_line stuff to change-file

@d F_CPU 16000000UL

@c
#include <avr/io.h>
#include <avr/interrupt.h>

@ The matter is that\footnote*{For some base station models.} on poweron, the phone turns its
led on and keeps it on for about a second,
then turns it off,
which makes parasitic `\.{\%}'/`\.{@@}' pair to be sent to PC. So detect if DTR went low
(i.e., base station was powered on) and ignore first two |PD0| transitions.

@c
volatile int base_station_was_powered_on = 0;

ISR(INT0_vect)
{
  base_station_was_powered_on = 1;
}

@ @c
volatile int keydetect = 0;

ISR(INT1_vect)
{
  keydetect = 1;
}

void main(void)
{
  int on_line = 0; /* we cannot use PORTB state of the led in order to avoid false indications,
    due to reasons described in previous section */

  PORTD |= 1 << PD0; /* set PD0 to pullup mode */

  DDRB |= 1 << PB5;

  @<Initialize UART@>@;

  EICRA |= 1 << ISC01; /* set INT0 to trigger on falling edge */
  EIMSK |= 1 << INT0; /* turn on INT0 */
  EICRA |= 1 << ISC11 | 1 << ISC10; /* set INT1 to trigger on rising edge */
  EIMSK |= 1 << INT1; /* turn on INT1 */

  sei(); /* turn on interrupts */

  unsigned char digit;
  while(1) {
    @<Indicate...@>@;
    if (keydetect) {
      keydetect = 0;
      switch (PIND & 0xF0) {
      case (0x10):
        digit = '1';
        break;
      case (0x20):
        digit = '2';
        break;
      case (0x30):
        digit = '3';
        break;
      case (0x40):
        digit = '4';
        break;
      case (0x50):
        digit = '5';
        break;
      case (0x60):
        digit = '6';
        break;
      case (0x70):
        digit = '7';
        break;
      case (0x80):
        digit = '8';
        break;
      case (0x90):
        digit = '9';
        break;
      case (0xA0):
        digit = '0';
        break;
      case (0xB0):
        digit = '*';
        break;
      case (0xC0):
        digit = '#';
        break;
      default:
        digit = '?';
        break;
      }
      while (!(UCSR0A & 1 << UDRE0)) ; /* loop while the transmit buffer is not ready to receive
                                          new data */
      UDR0 = digit;
    }
  }
}

@ @d BAUD 57600

@<Initialize UART@>=
#include <util/setbaud.h>
UBRR0H = UBRRH_VALUE;
UBRR0L = UBRRL_VALUE;
#if USE_2X
  UCSR0A |= (1<<U2X0);
#endif
UCSR0B = (1<<TXEN0);
UCSR0C = (1<<UCSZ01) | (1<<UCSZ00);

@ For on-line indication we send `\.{@@}' character to PC---to put
program on PC to initial state.
For off-line indication we send `\.{\%}' character to PC---to disable
power reset on base station after timeout.

See \.{test-AOT127A.w} to recall how it was tested.

@<Indicate line state change to the PC@>=
if (PIND & 1 << PD0) { /* off-line or base station is not powered
                          (automatically causes off-line) */
  if (on_line) { /* transition happened */
    if (base_station_was_powered_on) base_station_was_powered_on = 0;
    else {
      while (!(UCSR0A & 1 << UDRE0)) ; /* loop while the transmit buffer is not ready to receive
                                          new data */
      UDR0 = '%';
      PORTB &= (unsigned char) ~ (unsigned char) (1 << PB5);
    }
  }
  on_line = 0;
}
else { /* on-line */
  if (!on_line) { /* transition happened */
    if (base_station_was_powered_on) ; else {
      while (!(UCSR0A & 1 << UDRE0)) ; /* loop while the transmit buffer is not ready to receive
                                          new data */
      UDR0 = '@@';
      PORTB |= 1 << PB5;
    }
  }
  on_line = 1;
}
