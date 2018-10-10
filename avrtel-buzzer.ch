It's impossible to open the same TTY device more than once, otherwise we never
know which process set the DTR. And DTR is essential for this application, so
it must not be intervened to. So, use another means - for example HID.

TODO: after you add HID interface to avrtel-matrix.ch, on router use "hid-write"
based on hid-example.c

@x
void main(void)
@y
/* TODO: use active buzzer instead when I receive it */
void PLAYNOTE(float duration, int frequency)
{
  long int i,cycles;
  float half_period;
  float wavelength;

  wavelength = 1 / (float) frequency * 1000;
  cycles = duration / wavelength;
  half_period = wavelength / 2;

  DDRD |= 1 << PD4;

  for (i = 0; i < cycles; i++) {
    @<Delay half period@>@;
    PORTD |= 1 << PD4;
    @<Delay half period@>@;
    PORTD &= ~(1 << PD4);
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
/*UENUM = EP4;*/ /* TODO: add HID interface to avrtel-matrix.ch for 'B', 'C' and 'D' (to send) and
then use HID interface here (to receive); and maybe use timer from avr/C.c to stop buzzer not
to block the main cycle (it is allowed because interrupt is not used for matrix, in contrast
with dtmf decoder) */
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
