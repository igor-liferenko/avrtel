use separate device with matrix keypad and separate router with tel

@x
volatile int keydetect = 0;
ISR(INT1_vect)
{
  keydetect = 1;
}
@y
@z

Connect PD1 to PD2.
@x
  @<Set |PD2| to pullup mode@>@;
  EICRA |= 1 << ISC11 | 1 << ISC10; /* set INT1 to trigger on rising edge */
  EIMSK |= 1 << INT1; /* turn on INT1 */
@y
  DDRD |= 1 << PD1;
  PORTB |= 1 << PD1;
@z

@x
  DDRE |= 1 << PE6;
@y
@z

@x
  char digit;
@y
  @<Pullup input pins@>@;
@z

@x
    if (line_status.DTR) {
      PORTE |= 1 << PE6; /* base station on */
      PORTB |= 1 << PB0; /* led off */
    }
    else {
      if (PORTB & 1 << PB0) { /* transition happened */
        PORTE &= ~(1 << PE6); /* base station off */
        keydetect = 0; /* in case key was detected right before base station was
                          switched off, which means that nothing must come from it */
      }
      PORTB &= ~(1 << PB0); /* led on */
    }
@y
    if (line_status.DTR) {
      PORTB &= ~(1 << PB0); /* led off */
      @<Get button@>@;
    }
    else {
      if (!(PORTB & 1 << PB0)) { /* transition happened */
        PORTD |= 1 << PD1; /* off-line */
        btn = 0; /* in case key was detected right before base station was
                          switched off, which means that nothing must come from it */
      }
      PORTB |= 1 << PB0; /* led on */
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
      default: digit = '?';
      }
      while (!(UEINTX & 1 << TXINI)) ;
      UEINTX &= ~(1 << TXINI);
      UEDATX = digit;
      UEINTX &= ~(1 << FIFOCON);
@y
    if (btn != 0 && on_line) {
      while (!(UEINTX & 1 << TXINI)) ;
      UEINTX &= ~(1 << TXINI);
      if (btn == 'C')
        UEDATX = '9';
      else if (btn == 'D')
        UEDATX = '7';
      else
        UEDATX = btn;
      UEINTX &= ~(1 << FIFOCON);
      U8 prev_button = btn;
      int timeout;
      if (btn == 'C' || btn == 'D')
        timeout = 300;
      else timeout = 2000;
      while (--timeout) {
        @<Get button@>@;
        if (btn != prev_button) break;
        _delay_ms(1);
      }
    }
@z

@x
@ The pull-up resistor is connected to the high voltage (this is usually 3.3V or 5V and is
often refereed to as VCC).

Pull-ups are often used with buttons and switches.

With a pull-up resistor, the input pin will read a high state when the photo-transistor
is not opened. In other words, a small amount of current is flowing between VCC and the input
pin (not to ground), thus the input pin reads close to VCC. When the photo-transistor is
opened, it connects the input pin directly to ground. The current flows through the resistor
to ground, thus the input pin reads a low state.

Since pull-up resistors are so commonly needed, many MCUs, like the ATmega328 microcontroller
on the Arduino platform, have internal pull-ups that can be enabled and disabled.

$$\hbox to7.54cm{\vbox to3.98638888888889cm{\vfil\special{psfile=pullup.eps
  clip llx=0 lly=0 urx=214 ury=113 rwi=2140}}\hfil}$$

@<Set |PD2| to pullup mode@>=
PORTD |= 1 << PD2;

@y
@z

@x
@* Headers.
@y
@i ../usb/matrix.w

@ TODO: remove this section and do toggle via A
@<Get button@>=
if (btn == 'A') btn = 0, on_line = 1;
if (btn == 'B') btn = 0, on_line = 0;

@* Headers.
@z

@x
@<Header files@>=
@y
@<Header files@>=
#define F_CPU 16000000UL
#include <util/delay.h>
@z
