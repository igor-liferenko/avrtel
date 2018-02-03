HINT: if things will not work properly, for debugging
try to put led on some digital output and turn it on where base_station_was_powered_on
is checked to be 1 during transition to on-line and turn it off when base_station_was_powered_on
is checeked to be 0 during transition to off-line

@x
#include <avr/interrupt.h>
@y
#include <avr/interrupt.h>

@ The matter is that\footnote*{For some base station models.} on poweron, the phone turns its
led on and keeps it on for about a second,
then turns it off,
which makes parasitic `\.{\%}'/`\.{@@}' pair to be sent to PC. So detect if DTR went low
(i.e., base station was powered on) and ignore first two |PD0| transitions.

You know that this problem is present if you see the following lines appear
when you start \.{tel} in foreground:

INF: connected terminal
BUT: @
ACT: go to beginning
BUT: %
ACT: disable timeout

@c
volatile int base_station_was_powered_on = 0;

ISR(INT0_vect)
{
  base_station_was_powered_on = 1;
}
@z

@x
void main(void)
{
@y
void main(void)
{
  int on_line = 0; /* we cannot use PORTB state of the led in order to avoid false indications,
    due to reasons described in previous section */

@z

@x
  EICRA |= 1 << ISC11 | 1 << ISC10; /* set INT1 to trigger on rising edge */
  EIMSK |= 1 << INT1; /* turn on INT1 */
@y
  EICRA |= 1 << ISC01; /* set INT0 to trigger on falling edge */
  EIMSK |= 1 << INT0; /* turn on INT0 */
  EICRA |= 1 << ISC11 | 1 << ISC10; /* set INT1 to trigger on rising edge */
  EIMSK |= 1 << INT1; /* turn on INT1 */
@z

@x
  if (PORTB & 1 << PB5) {
    while (!(UCSR0A & 1 << UDRE0)) ; /* loop while the transmit buffer is not ready to receive
                                        new data */
    UDR0 = '%';
  }
  PORTB &= (unsigned char) ~ (unsigned char) (1 << PB5);
}
else { /* on-line */
  if (!(PORTB & 1 << PB5)) {
    while (!(UCSR0A & 1 << UDRE0)) ; /* loop while the transmit buffer is not ready to receive
                                        new data */
    UDR0 = '@@';
  }
  PORTB |= 1 << PB5;
}
@y
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
@z
