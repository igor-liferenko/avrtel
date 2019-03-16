send @ % and digits to LCD instead of USB

@x
@* Program.
@y
@i LCD.w

@* Program.
@z

@x
  char digit;
@y
  char digit;
  LCD_Init();
  int full = 0;
@z

@x
      while (!(UEINTX & 1 << TXINI)) ;
      UEINTX &= ~(1 << TXINI);
      UEDATX = digit;
      UEINTX &= ~(1 << FIFOCON);
@y
      if (full == 16) { LCD_Command(0x01); full = 0; }
      LCD_Char(digit=='0'?'O':digit);
      full++;
@z

@x
      while (!(UEINTX & 1 << TXINI)) ;
      UEINTX &= ~(1 << TXINI);
      UEDATX = '%';
      UEINTX &= ~(1 << FIFOCON);
@y
      if (full == 16) { LCD_Command(0x01); full = 0; }
      LCD_Char('%');
      full++;
@z

@x
    while (!(UEINTX & 1 << TXINI)) ;
    UEINTX &= ~(1 << TXINI);
    UEDATX = '@@';
    UEINTX &= ~(1 << FIFOCON);
@y
      if (full == 16) { LCD_Command(0x01); full = 0; }
      LCD_Char('a');
      full++;
@z
