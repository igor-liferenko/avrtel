@x
void main(void)
@y
void PLAYNOTE(float duration, float frequency)
{
  long int i,cycles;
  float half_period;
  float wavelength;

  switch (frequency) {
  case 880: 
  case 932:
  case 988:
  case 1047:
  case 1109:
  case 1175:
  case 1244:
  case 1319:
  case 1397:
  case 1480:
  case 1568:
  case 1660:

  wavelength = 1 / frequency * 1000;
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

@ @<Buzz if requested@>=
UENUM = EP2;
if (UEINTX & 1 << RXOUTI) {
  UEINTX &= ~(1 << RXOUTI);
  UEINTX &= ~(1 << FIFOCON);
  PLAYNOTE(400,880);
  PLAYNOTE(400,932);
  PLAYNOTE(400,988);
  PLAYNOTE(400,1047);
  PLAYNOTE(400,1109);
  PLAYNOTE(400,1175);
  PLAYNOTE(400,1244);
  PLAYNOTE(400,1319);
  PLAYNOTE(400,1397);
  PLAYNOTE(400,1480);
  PLAYNOTE(400,1568);
  PLAYNOTE(400,1660);
}
UENUM = EP1; /* restore */

@ @<Delay half period@>=
    switch (frequency) {
    case 880: _delay_ms(1 / 880 * 500); break;
    case 932: _delay_ms(1 / 932 * 500); break;
    case 988: _delay_ms(1 / 988 * 500); break;
    case 1047: _delay_ms(1 / 1047 * 500); break;
    case 1109: _delay_ms(1 / 1109 * 500); break;
    case 1175: _delay_ms(1 / 1175 * 500); break;
    case 1244: _delay_ms(1 / 1244 * 500); break;
    case 1319: _delay_ms(1 / 1319 * 500); break;
    case 1397: _delay_ms(1 / 1397 * 500); break;
    case 1480: _delay_ms(1 / 1480 * 500); break;
    case 1568: _delay_ms(1 / 1568 * 500); break;
    case 1660: _delay_ms(1 / 1660 * 500); break;
    }

@* Headers.
@z
