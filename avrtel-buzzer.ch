@x
    @<Get |line_status|@>@;
@y
    @<Buzz if requested@>@;
    @<Get |line_status|@>@;
@z

@x
@* Headers.
@y
@ @d SPEAKER_PORT PORTC
@d SPEAKER_DDR DDRC
@d SPEAKER_PIN 6

@c
void PLAYNOTE(float duration, float frequency)
{
  long int i,cycles;
  float half_period;
  float wavelength;

  wavelength = 1 / frequency * 1000;
  cycles = duration / wavelength;
  half_period = wavelength / 2;

  SPEAKER_DDR |= 1 << SPEAKER_PIN;

  for (i=0;i<cycles;i++) {
    _delay_ms(half_period);
    SPEAKER_PORT |= 1 << SPEAKER_PIN;
    _delay_ms(half_period);
    SPEAKER_PORT &= ~(1 << SPEAKER_PIN);
  }
}

@i ../usb/OUT-endpoint-management.w

@ @<Buzz if requested@>=
UENUM = EP2;
if (UEINTX & 1 << RXOUTI) {
  UEINTX &= ~(1 << RXOUTI);
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
  UEINTX &= ~(1 << FIFOCON);
}
UENUM = EP1; /* restore */

@* Headers.
@z
