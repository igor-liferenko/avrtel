This prevents @%@ at off-hook and %@% at on-hook which sometimes appear,
and also @% which sometimes appear by itself.

This is the algorithm: if we detect @, delay and check it once again;
if we detect %, delay and check it once again.

@x
@c
@y
@d F_CPU 16000000UL
@c
#include <util/delay.h>
@z

@x
if (PIND & 1 << PD2) { /* on-line */
  if (!(PORTD & 1 << PD5)) { /* transition happened */
@y
int first = 1;
again:
if (PIND & 1 << PD2) { /* on-line */
  if (!(PORTD & 1 << PD5)) { /* transition happened */
    if (first) {
      first = 0;
      _delay_ms(20); // adjust empirically
      goto again;
    }
@z

@x
  if (PORTD & 1 << PD5) { /* transition happened */
@y
  if (PORTD & 1 << PD5) { /* transition happened */
    if (first) {
      first = 0;
      _delay_ms(20); // adjust empirically
      goto again;
    }
@z

@x
}
@y
}
first = 1;
@z
