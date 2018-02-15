ATTENTION: do not forget to connect DTR (which governs base station's power) to PD2 (aka INT0)
when you use this change-file

The matter is that (for KX-TG7331; TODO: check for KX-TCD245) on poweron, the phone turns its
led on for a short time,
then turns it off. So in this change-file we detect if DTR went low
(i.e., base station was powered on) and ignore first two PD0 transitions.

You know that this problem is present if you see the following lines appear
just after you start "tel" in foreground:

BUT: @
ACT: go to beginning
BUT: %
ACT: disable timeout

@x
#include <avr/interrupt.h>
@y
#include <avr/interrupt.h>

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
  int on_line = 0; /* use it instead of |PORTB| to determine transition */
  EICRA |= 1 << ISC01; /* set INT0 to trigger on falling edge */
  EIMSK |= 1 << INT0; /* turn on INT0 */
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
@z
