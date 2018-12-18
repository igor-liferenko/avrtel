You know that this change-file is necessary if you see the following lines appear
just after you start "tel" in foreground:

BUT: @
ACT: go to beginning
BUT: %
ACT: disable timeout

To work around the led turning on on poweron for a short time, we detect if DTR
changed to `1' (i.e., when base station was powered on)
and ignore first two led state changes in such case.

@x
  char digit;
@y
  int base_station_was_powered_on = 0;
  char digit;
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
    @<Check phone line state@>@;
@y
    @<Check phone line state@>@;
  next:
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
else { /* on-line */
  if (base_station_was_powered_on == 1) {
    base_station_was_powered_on = 2;
    goto next;
  }
  else if (base_station_was_powered_on)
    goto next;
@z
