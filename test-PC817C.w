@ @d F_CPU 16000000UL

@c
#include <avr/io.h>
int main(void)
{
  DDRB |= 1 << PB5; /* set pin B5 to be used for output */
  PORTD |= 1 << PD3; /* enable pullup */
  while (1)
    if (PIND & 1 << PD3)
      PORTB &= (uint8_t) ~ (uint8_t) (1<<PB5);
    else
      PORTB |= 1<<PB5;
}
