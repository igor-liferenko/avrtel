@x
      UEDATX = '%';
      UEINTX &= ~(1 << FIFOCON);
@y
      UEDATX = '%';
      UEINTX &= ~(1 << FIFOCON);
      _delay_ms(15); // empirical
@z

@x
    UEDATX = '@@';
    UEINTX &= ~(1 << FIFOCON);
@y
    UEDATX = '@@';
    UEINTX &= ~(1 << FIFOCON);
    _delay_ms(5); // empirical
@z
