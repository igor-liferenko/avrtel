You know that this change-file is necessary if you see the following lines appear
just after you start "tel" in foreground:

BUT: @
ACT: go to beginning
BUT: %
ACT: disable timeout

@x
The following phone model is used: Panasonic KX-TCD245.
The main requirement is that power supply for base station must be DC, and it
must have led indicator for on-hook / off-hook on base station.
@y
The following phone model is used: Panasonic KX-TG7331.
The main requirement is that power supply for base station must be DC, and it
must have led indicator for on-hook / off-hook on base station.
For this phone model when base station is powered on, the indicator is turned
on for a short time. To work around this harmful effect, we detect if DTR
changed to `1' (i.e., when base station was powered on)
and ignore first two led state changes in such case.
@z

@x
  DDRD |= 1 << PD5; /* on-line/off-line indicator; also |PORTD & 1 << PD5| is used to get current
                       state to determine if transition happened (to save extra variable) */
@y
  DDRD |= 1 << PD5; /* on-line/off-line indicator */
  int on_line = 0; /* used to get current state to determine if on-line/off-line transition
    happened */
  int base_station_was_powered_on = 0;
@z

@x
    if (line_status.DTR) {
      PORTE &= ~(1 << PE6); /* base station on */
      PORTB |= 1 << PB0; /* led off */
    }
@y
    if (line_status.DTR) {
      if (!(PORTB & 1 << PB0)) { /* transition happened */
        PORTE &= ~(1 << PE6); /* base station on */
        base_station_was_powered_on = 1;
      }
      PORTB |= 1 << PB0; /* led off */
    }
@z

@x
  if (!(PORTD & 1 << PD5)) { /* transition happened */
    while (!(UEINTX & 1 << TXINI)) ;
    UEINTX &= ~(1 << TXINI);
    UEDATX = '%';
    UEINTX &= ~(1 << FIFOCON);
  }
  PORTD |= 1 << PD5;
}
else { /* on-line */
  if (PORTD & 1 << PD5) { /* transition happened */
    while (!(UEINTX & 1 << TXINI)) ;
    UEINTX &= ~(1 << TXINI);
    UEDATX = '@@';
    UEINTX &= ~(1 << FIFOCON);
  }
  PORTD &= ~(1 << PD5);
@y
  if (on_line) { /* transition happened */
    if (base_station_was_powered_on) base_station_was_powered_on = 0;
    else {
      while (!(UEINTX & 1 << TXINI)) ;
      UEINTX &= ~(1 << TXINI);
      UEDATX = '%';
      UEINTX &= ~(1 << FIFOCON);
      PORTD |= 1 << PD5;
    }
  }
  on_line = 0;
}
else { /* on-line */
  if (!on_line) { /* transition happened */
    if (base_station_was_powered_on) ; else {
      while (!(UEINTX & 1 << TXINI)) ;
      UEINTX &= ~(1 << TXINI);
      UEDATX = '@@';
      UEINTX &= ~(1 << FIFOCON);
      PORTD &= ~(1 << PD5);
    }
  }
  on_line = 1;
@z
