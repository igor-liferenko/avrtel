Use separate device with matrix keypad and separate router with tel.
Connect PD1 to PD2 to minimalize the amount of changes.

NOTE: when you finish testing and bring it to gorod, add here that
'2' will be sent together with '@' (to automatically get to kitchen menu)

TODO: make that button 'B' will stop all (only when off-line)

TODO: on LCD print digits when on-line and print current time when off-line

TODO: play sound from USB via PWM and use relay to swith powen on/off on
      speaker (use TX debug pin for relay)

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
        DDRD &= ~(1 << PD1); /* off-line (forced by DTR) */
      }
      PORTB |= 1 << PB0; /* led on */
    }
    if (btn == 'A') { /* toggle hook state */
      if (DDRD & 1 << PD1) DDRD &= ~(1 << PD1);
      else DDRD |= 1 << PD1;
      _delay_ms(1); /* eliminate capacitance */
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
    }
@y
    if (btn != 0) {
      if (btn != 'A' && DDRD & 1 << PD1) { /* on-line */
        while (!(UEINTX & 1 << TXINI)) ;
        UEINTX &= ~(1 << TXINI);
        if (btn == 'C')
          UEDATX = '9';
        else if (btn == 'D')
          UEDATX = '7';
        else
          UEDATX = btn;
        UEINTX &= ~(1 << FIFOCON);
      }
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
