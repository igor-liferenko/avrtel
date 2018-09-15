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
  DDRD |= 1 << PD5; /* on-line/off-line indicator
                       (also |PORTD & 1 << PD5| is used to get current
                       state to determine if transition happened ---~to save extra variable) */
@y
  DDRD |= 1 << PD5; /* on-line/off-line indicator
                    */
  int led = 0; /* used to get current state to determine if on-line/off-line transition
    happened (because PD5 is not activated when the led on base station is enabled after
    poweron) */
  int base_station_was_powered_on = 0;
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
  if (PORTD & 1 << PD5) { /* transition happened */
    if (line_status.DTR) { /* off-line was not caused by un-powering base station */
      while (!(UEINTX & 1 << TXINI)) ;
      UEINTX &= ~(1 << TXINI);
      UEDATX = '%';
      UEINTX &= ~(1 << FIFOCON);
    }
  }
  PORTD &= ~(1 << PD5);
}
else { /* on-line */
  if (!(PORTD & 1 << PD5)) { /* transition happened */
    while (!(UEINTX & 1 << TXINI)) ;
    UEINTX &= ~(1 << TXINI);
    UEDATX = '@@';
    UEINTX &= ~(1 << FIFOCON);
  }
  PORTD |= 1 << PD5;
@y
  if (led) { /* transition happened */
    if (base_station_was_powered_on) base_station_was_powered_on = 0;
    else {
      if (line_status.DTR) { /* off-line was not caused by un-powering base station */
        while (!(UEINTX & 1 << TXINI)) ;
        UEINTX &= ~(1 << TXINI);
        UEDATX = '%';
        UEINTX &= ~(1 << FIFOCON);
      }
      PORTD &= ~(1 << PD5);
    }
  }
  led = 0;
}
else { /* on-line */
  if (!led) { /* transition happened */
    if (base_station_was_powered_on) ; else {
      while (!(UEINTX & 1 << TXINI)) ;
      UEINTX &= ~(1 << TXINI);
      UEDATX = '@@';
      UEINTX &= ~(1 << FIFOCON);
      PORTD |= 1 << PD5;
    }
  }
  led = 1;
@z
