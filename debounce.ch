This change-file is used to keep avrtel.w the same as it was on old scheme, because it is used.

17:16:24 BUT: %
17:16:24 ACT: hang up
17:16:24 BUT: @
17:16:24 ACT: go to main menu
17:16:24 BUT: %
17:16:24 ACT: hang up

@x
      UEDATX = '%';
      UEINTX &= ~(1 << FIFOCON);
@y
      UEDATX = '%';
      UEINTX &= ~(1 << FIFOCON);
      _delay_ms(15); // empirical
@z

17:15:03 BUT: @
17:15:03 ACT: go to main menu
17:15:03 BUT: %
17:15:03 ACT: hang up
17:15:03 BUT: @
17:15:03 ACT: go to beginning

@x
    UEDATX = '@@';
    UEINTX &= ~(1 << FIFOCON);
@y
    UEDATX = '@@';
    UEINTX &= ~(1 << FIFOCON);
    _delay_ms(10); // empirical
@z
