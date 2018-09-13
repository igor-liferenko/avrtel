@x
void main(void)
@y
void PLAYNOTE(float duration, int frequency)
{
  long int i,cycles;
  float half_period;
  float wavelength;

  wavelength = 1 / (float) frequency * 1000;
  cycles = duration / wavelength;
  half_period = wavelength / 2;

  DDRC |= 1 << PC6;

  for (i = 0; i < cycles; i++) {
    @<Delay half period@>@;
    PORTC |= 1 << PC6;
    @<Delay half period@>@;
    PORTC &= ~(1 << PC6);
  }
}

void main(void)
@z

@x
    @<Get |line_status|@>@;
@y
    @<Buzz if requested@>@;
    @<Get |line_status|@>@;
@z

@x
@* Headers.
@y
@i ../usb/OUT-endpoint-management.w

@ TODO: never change DTR automatically in cdc-acm driver and in tel.w disable it manually before
exit or fix cdc-acm driver to set DTR only when opened as non-write, or use special program
instead of echo and use some flag to open() and process it in cdc-acm driver - otherwise we never
know which process set the DTR

@<Buzz if requested@>=
UENUM = EP2;
if (UEINTX & 1 << RXOUTI) {
  UEINTX &= ~(1 << RXOUTI);
  UEINTX &= ~(1 << FIFOCON);
  PLAYNOTE(400,880);
/*  PLAYNOTE(400,932);
  PLAYNOTE(400,988);
  PLAYNOTE(400,1047);
  PLAYNOTE(400,1109);
  PLAYNOTE(400,1175);
  PLAYNOTE(400,1244);
  PLAYNOTE(400,1319);
  PLAYNOTE(400,1397);
  PLAYNOTE(400,1480);
  PLAYNOTE(400,1568);
  PLAYNOTE(400,1660);*/
}
UENUM = EP1; /* restore */

@ @<Delay half period@>=
    switch (frequency) {
    case 880: _delay_ms(1); break;
    case 932: _delay_ms(1); break;
    case 988: _delay_ms(1); break;
    case 1047: _delay_ms(1); break;
    case 1109: _delay_ms(1); break;
    case 1175: _delay_ms(1); break;
    case 1244: _delay_ms(1); break;
    case 1319: _delay_ms(1); break;
    case 1397: _delay_ms(1); break;
    case 1480: _delay_ms(1); break;
    case 1568: _delay_ms(1); break;
    case 1660: _delay_ms(1); break;
    }

@* Headers.
@z
