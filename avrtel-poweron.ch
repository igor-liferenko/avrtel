You know that this change-file is necessary if you see the following lines appear
just after you start "tel" in foreground:

BUT: @
ACT: go to beginning
BUT: %
ACT: disable timeout

@x
The following phone models are used: Panasonic KX-TCD245 and Voxtel.
@y
The following phone model is used: Panasonic KX-TG7331\footnote*{For
this phone model when base station is powered on, the indicator is turned
on for a short time. To work around this harmful effect, we detect if DTR
changed to `1' (i.e., when base station was powered on)
and ignore first two led state changes in such case.}.
@z

@x
  DDRD |= 1 << PD5; /* show on-line/off-line state
@y
  int base_station_was_powered_on = 0;
  DDRD |= 1 << PD5; /* show on-line/off-line state
@z

@x
    if (line_status.DTR) {
      PORTE |= 1 << PE6; /* base station on */
      PORTB &= ~(1 << PB0); /* led off */
    }
@y
    if (line_status.DTR) {
      if (PORTB & 1 << PB0) { /* transition happened */
        PORTE |= 1 << PE6; /* base station on */
        base_station_was_powered_on = 1;
      }
      PORTB &= ~(1 << PB0); /* led off */
    }
@z

@x
if (PIND & 1 << PD2) { /* off-line */
@y
if (PIND & 1 << PD2) { /* off-line */
  if (base_station_was_powered_on == 2)
    base_station_was_powered_on = 0;
  else if (base_station_was_powered_on)
    goto next;
@z

@x
else { /* on-line */
@y
  if (base_station_was_powered_on == 1) {
    base_station_was_powered_on = 2;
    goto next;
  }
@z

@x
  PORTD |= 1 << PD5;
}
@y
  PORTD |= 1 << PD5;
}
next:
@z
