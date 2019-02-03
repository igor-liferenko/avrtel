Use separate device with matrix keypad and separate router with \.{tel}.
Connect PD1 to PD2 to minimalize the amount of changes.
Via PD1 we control led. Via PD2 we read led.
Add led between ground and PB6 (via 330 ohm resistor).

TODO: draw block-scheme in metapost and add to TeX-part of section
|@<Handle matrix@>| and add thorough explanation of its C-part there,
and improve theory in usb/matrix.w (maybe google "matrix keypad theory")

@x
@* Program.
@y
%\let\maybe=\iffalse

@* Program.
@z

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
  while (1) {
    @<Get |line_status|@>@;
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
    @<Check phone line state@>@;
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
  }
}
@y
  @<Handle matrix@>@;
}

@ Button press indication LED is used without interrupts and timers, because
we block the program anyway inside the debounce interval, so use that to turn
the LED off.

Take to consideration that:

\item{1.} \\{ioctl} call blocks in application until it is
read in this program
\item{2.} data is read by USB host as soon as it is sent, even if \\{read}
call has not been done in application yet (i.e., it is buffered)

TODO: increase debounce on A? This is useful when we switch off (when done with a router) and
then immediately switch on to go to another router - for this maybe use separate
button to go off-line instead of pressing A second time (for this
do not use saying time in ru and in fr - and use button B to go
off-line, and use C and D for volume (as B
and C now) and switch off all routers manually)

NOTE: if necessary, you may set 16-bit timers here as if interrupts are not
enabled at all (but do not call cli() and do not remove USB RESET interrupt - it
happens only when usb host is rebooted, and if it happens, the device is not operational
anyway); the situation is the same in avrtel.w - there dtmf keypress interrupt happens
only when the device is operational - USB RESET interrupt is not removed (i.e.,
the condition, that an interrupt happens while other interrupt is being processed,
is fulfilled)

@<Handle matrix@>=
  DDRB |= 1 << PB6; /* to indicate keypresses */
  @<Pullup input pins@>@;
  while (1) {
    @<Get |line_status|@>@;
    if (line_status.DTR) {
      PORTB &= ~(1 << PB0); /* led off */
    }
    else {
      if (!(PORTB & 1 << PB0)) { /* transition happened */
        DDRD &= ~(1 << PD1); /* off-line (do the same as on base station,
          where off-line automatically happens when base station is un-powered) */
      }
      PORTB |= 1 << PB0; /* led on */
    }
    @<Get button@>@;
    if (line_status.DTR && btn == 'A') { // 'A' is special button, which does not use
      // indicator led on PB6 - it has its own
      if (DDRD & 1 << PD1)
        DDRD &= ~(1 << PD1);
      else
        DDRD |= 1 << PD1;
      _delay_ms(1); /* eliminate capacitance\footnote\dag{This corresponds to ``2)'' in
        |@<Eliminate capacitance@>|.} */
    }
    @<Check phone line state@>@;
    if (line_status.DTR && btn) {
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
      // do not allow one button to be pressed more frequently than
      // debounce (i.e., if I mean to hold it, but it bounces,
      // and the interval between bounces exceeds "eliminate capacitance" delay,
      // which is very small); also, the debounce interval must be a little greater
      // than the blink time of the button press indicator led
      while (--timeout) {
        // FIXME: call |@<Get |line_status|@>| and check |line_status.DTR| here?
        if (!(prev_button == 'B' || prev_button == 'C')) {
          @<Get button@>@;
          if (btn == 0 && timeout < 1500) break; /* timeout - debounce, you can't
            make it react more frequently than debounce interval;
            |timeout| time is allowed to release the button until it repeats;
            for `\.B' and `\.C' |timeout| is equal to |debounce|, i.e., repeat
            right away */
        }
        _delay_ms(1);
        if (prev_button == 'B' || prev_button == 'C') {
          if (timeout < 200) PORTB &= ~(1 << PB6); /* timeout - indicator duration (should be less
            than debounce) */
        }
        else {
          if (timeout < 1900) PORTB &= ~(1 << PB6); /* timeout - indicator duration (should be less
            than debounce) */
        }
      }
    }
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
