PB0 and PD5 are inverted on pro micro because TXEN0/RXEN0 macro in
arduino IDE turns it on on normal arduino, and TXEN1/RXEN1 turns it
off, so to make 0 and 1 correspond to off and on they double-inverted
leds on board. But we do not use arduino IDE and for us the problem
persists, so do the inversion in change-file to avoid headache.

Apply it after other change-file was applied via
"wmerge avrtel other >merged.w" like
"ctangle merged invert"
"make merged"

@x
  DDRD |= 1 << PD5; /* |PD5| is used to show on-line/off-line state
@y
  PORTD |= 1 << PD5; /* led off */
  DDRD |= 1 << PD5; /* |PD5| is used to show on-line/off-line state
@z

@x
  PORTB |= 1 << PB0; /* led on */
@y
@z

@x
    PORTB |= 1 << PB0;
    PORTD |= 1 << PD5;
@y
    PORTB &= ~(1 << PB0);
    PORTD &= ~(1 << PD5);
@z

@x
      PORTB &= ~(1 << PB0); /* led off */
@y
      PORTB |= 1 << PB0; /* led off */
@z

@x
      if (!(PORTB & 1 << PB0)) { /* transition happened */
@y
      if (PORTB & 1 << PB0) { /* transition happened */
@z

@x
      PORTB |= 1 << PB0; /* led on */
@y
      PORTB &= ~(1 << PB0); /* led on */
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
