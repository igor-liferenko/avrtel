The matter is that (for KX-TG7331; TODO: check for KX-TCD245) on poweron, the phone turns its
led on for a short time,
then turns it off. So in this change-file we detect if DTR went low
(i.e., base station was powered on) and ignore first two PD0 state changes.

You know that this problem is present if you see the following lines appear
just after you start "tel" in foreground:

BUT: @
ACT: go to beginning
BUT: %
ACT: disable timeout

@x
  DDRD |= 1 << PD5; /* on-line/off-line indicator; also used to get current state to determine
                       if transition happened */
@y
  DDRD |= 1 << PD5; /* on-line/off-line indicator */
  int on_line = 0; /* used to get current state to determine if on-line/off-line transition
    happened */
  int base_station_was_powered_on = 0;
@z

@x
    if (line_status.DTR) {
      PORTE &= ~(1 << PE6); /* |DTR| pin low (TLP281 inverts the signal) */
      PORTB |= 1 << PB0; /* led off */
    }
@y
    if (line_status.DTR) {
      if (!(PORTB & 1 << PB0)) { /* transition happened */
        PORTE &= ~(1 << PE6); /* |DTR| pin low (TLP281 inverts the signal) */
        base_station_was_powered_on = 1;
      }
      PORTB |= 1 << PB0; /* led off */
    }
@z

@x
  if (!(PORTD & 1 << PD5)) {
    while (!(UEINTX & 1 << TXINI)) ;
    UEINTX &= ~(1 << TXINI);
    UEDATX = '%';
    UEINTX &= ~(1 << FIFOCON);
  }
  PORTD |= 1 << PD5;
}
else { /* on-line */
  if (PORTD & 1 << PD5) {
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
