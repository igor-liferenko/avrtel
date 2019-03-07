@ This is program for atmega328p to test TL431 - PD2 can be enabled only once
(to test for bouncing), PD1 can be enabled unlimited number of times.
Put 10K resistor between +5V and control pin. Another resistor is pullup.

$$\hbox to4.72cm{\vbox to5.32694444444444cm{\vfil\special{psfile=TL431.eps
  clip llx=0 lly=0 urx=134 ury=151 rwi=1340}}\hfil}$$

@d F_CPU 16000000UL

@c
#include <avr/io.h>
#include <util/delay.h>
void main (void)
{
  DDRB |= 1 << PB5; /* set pin B5 to be used for output */
  PORTD |= 1 << PD1; _delay_ms(100);
  PORTD |= 1 << PD2; _delay_ms(100);
  int first = 1;
  int READS_LOW = 0;
  while (1) {
    if (!(PIND & 1 << PD1))
      PORTB |= 1 << PB5;
    else
      PORTB &= ~(1 << PB5);
    if (!(PIND & 1 << PD2)) { /* wire */
      READS_LOW = 1;
      if (first) PORTB |= 1 << PB5;
    }
    else { /* no wire */
      if (READS_LOW == 1) first = 0; /* transition */
      PORTB &= ~(1 << PB5);
    }
  }
}
