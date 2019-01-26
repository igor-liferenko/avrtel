Use separate device with matrix keypad and separate router with \.{tel}.
Connect PD1 to PD2 to minimalize the amount of changes.
Via PD1 we control led. Via PD2 we read led.

TODO: add here HID interface and send B C and D (if line_status.DTR) via HID
interface to USB-host's program "hid-read" based on hid-example.c
(It's impossible to open the same TTY device more than once, otherwise we never
know which process set the DTR. And DTR is essential for this application, so
it must not be intervened to. So, use another means - for example HID.)
HINT: compare wireshark trace of autologin device and kbd device + avrtel device

@x
volatile int keydetect = 0;
ISR(INT1_vect)
{
  keydetect = 1;
}
@y
@z

@x
  EICRA |= 1 << ISC11 | 1 << ISC10; /* set INT1 to trigger on rising edge */
  EIMSK |= 1 << INT1; /* turn on INT1 */
@y
@z

@x
  DDRE |= 1 << PE6;
@y
  DDRB |= 1 << PB6;
@z

@x
  char digit;
@y
  @<Pullup input pins@>@;
@z

@x
    if (line_status.DTR) {
      PORTE |= 1 << PE6; /* base station on */
      PORTB &= ~(1 << PB0); /* led off */
    }
    else {
      if (!(PORTB & 1 << PB0)) { /* transition happened */
        PORTE &= ~(1 << PE6); /* base station off */
        keydetect = 0; /* in case key was detected right before base station was
                          switched off, which means that nothing must come from it */
      }
      PORTB |= 1 << PB0; /* led on */
    }
@y
    if (line_status.DTR) {
      PORTB &= ~(1 << PB0); /* led off */
      @<Get button@>@;
    }
    else {
      if (!(PORTB & 1 << PB0)) { /* transition happened */
        DDRD &= ~(1 << PD1); /* off-line (do the same as on base station,
          where off-line automatically happens when base station is un-powered) */
      }
      PORTB |= 1 << PB0; /* led on */
    }
    if (btn == 'A') {
      if (DDRD & 1 << PD1)
        DDRD &= ~(1 << PD1);
      else
        DDRD |= 1 << PD1;
      _delay_ms(1); /* eliminate capacitance\footnote\dag{This corresponds to ``2)'' in
        |@<Eliminate capacitance@>|.} */
    }
@z

@x
    if (keydetect) {
      keydetect = 0;
      switch (PINB & (1 << PB4 | 1 << PB5 | 1 << PB6) | PIND & 1 << PD7) {
      case (0x10): digit = '1'; @+ break;
      case (0x20): digit = '2'; @+ break;
      case (0x30): digit = '3'; @+ break;
      case (0x40): digit = '4'; @+ break;
      case (0x50): digit = '5'; @+ break;
      case (0x60): digit = '6'; @+ break;
      case (0x70): digit = '7'; @+ break;
      case (0x80): digit = '8'; @+ break;
      case (0x90): digit = '9'; @+ break;
      case (0xA0): digit = '0'; @+ break;
      case (0xB0): digit = '*'; @+ break;
      case (0xC0): digit = '#'; @+ break;
      }
      while (!(UEINTX & 1 << TXINI)) ;
      UEINTX &= ~(1 << TXINI);
      UEDATX = digit;
      UEINTX &= ~(1 << FIFOCON);
    }
@y
    if (btn != 0) {
      if (btn != 'A' && !(PIND & 1 << PD2)) {
        PORTB |= 1 << PB6;
        while (!(UEINTX & 1 << TXINI)) ;
        UEINTX &= ~(1 << TXINI);
        UEDATX = btn;
        UEINTX &= ~(1 << FIFOCON);
      }
      U8 prev_button = btn;
      int timeout;
      if (btn == 'B' || btn == 'C')
        timeout = 300; /* values smaller that this do not give mpc call
          enough time to finish before another mpc request arrives; it
          is manifested by the fact that when button is released, the volume
          continues to increase (decrease) */
      else timeout = 2000;
      while (--timeout) {
        if (!(prev_button == 'B' || prev_button == 'C')) {
          @<Get button@>@;
          if (btn != prev_button && timeout < 1500) break;
        }
        _delay_ms(1);
        if (prev_button == 'B' || prev_button == 'C') {
          if (timeout < 200) PORTB &= ~(1 << PB6);
        }
        else {
          if (timeout < 1900) PORTB &= ~(1 << PB6);
        }
      }
      btn = 0;
    }
@z

@x
@* Headers.
@y
@i ../usb/matrix.w

@* Headers.
@z

@x
@<Header files@>=
@y
@<Header files@>=
#define F_CPU 16000000UL
#include <util/delay.h>
@z
