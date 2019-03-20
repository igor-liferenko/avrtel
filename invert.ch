PB0 and PD5 are inverted on pro micro because TXEN0/RXEN0 macro in
arduino IDE turns it on on normal arduino, and TXEN1/RXEN1 turns it
off, so to make 0 and 1 correspond to off and on they double-inverted
leds on board. But we do not use arduino IDE and for us the problem
persists, so do the inversion in change-file to avoid headache.

@x
  DDRD |= 1 << PD5; /* to show on-line/off-line state and to determine when transition happens */
@y
  PORTD |= 1 << PD5;
  DDRD |= 1 << PD5; /* to show on-line/off-line state and to determine when transition happens */
@z

@x
  PORTB |= 1 << PB0; /* on when DTR/RTS is off */
@y
@z

@x
      PORTB &= ~(1 << PB0); /* DTR/RTS is on */      
@y
      PORTB |= 1 << PB0; /* DTR/RTS is on */
@z

@x
      if (!(PORTB & 1 << PB0)) { /* transition happened */
@y
      if (PORTB & 1 << PB0) { /* transition happened */
@z

@x
      PORTB |= 1 << PB0; /* DTR/RTS is off */
@y
      PORTB &= ~(1 << PB0); /* DTR/RTs is off */
@z

@x
  if (!(PORTD & 1 << PD5)) { /* transition happened */
@y
  if (PORTD & 1 << PD5) { /* transition happened */
@z

@x
  PORTD |= 1 << PD5;
@y
  PORTD &= ~(1 << PD5);
@z

@x
  if (PORTD & 1 << PD5) { /* transition happened */
@y
  if (!(PORTD & 1 << PD5)) { /* transition happened */
@z

@x
  PORTD &= ~(1 << PD5);
@y
  PORTD |= 1 << PD5;
@z
