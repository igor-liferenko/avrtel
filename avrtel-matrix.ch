TODO: draw flowchart on graph paper and draw it in metapost
and add it to TeX-part of section
|@<Handle matrix@>| and add thorough explanation of its C-part there

@x
@* Program.
DTR is used by \.{tel} to switch the phone off (on timeout and for
special commands) by switching off/on
base station for one second (the phone looses connection to base
station and automatically powers itself off).

\.{tel} uses DTR to switch on base station when it starts;
and when TTY is closed, DTR switches off base station.

The main requirement to the phone is that base station
must have led indicator\footnote*{For
some phone models when base station is powered on, the indicator is turned
on for a short time. In such case use \.{avrtel-poweron.ch}.}
for on-hook / off-hook on base station (to be able
to reset to initial state in state machine in \.{tel}; note, that
measuring voltage drop in phone line to determine hook state does not work
reliably, because it
falsely triggers when dtmf signal is produced ---~the dtmf signal is alternating
below the trigger level and multiple on-hook/off-hook events occur in high
succession).

Note, that relay switches off output from base station's power supply, not input
because transition processes from 220v could damage power supply because it
is switched on/off multiple times.

Also note that when device is not plugged in,
base station must be powered off, and it must be powered on by \.{tel} (this
is why non-inverted relay must be used (and from such kind of relay the
only suitable I know of is mechanical relay; and such relay gives an advantage
that power supply with AC and DC output may be used; however, see {\tt
TLP281.tex} how to fix TLP281 to make it behave like
normally-open-mechanical-relay)).
If base station
is powered when device is not plugged in, this breaks program logic badly.

%Note, that we can not use simple cordless phone---a DECT phone is needed, because
%resetting base station to put the phone on-hook will not work
%(FIXME: check if it is really so).

$$\hbox to12.27cm{\vbox to9.87777777777778cm{\vfil\special{psfile=avrtel.3
  clip llx=-91 lly=-67 urx=209 ury=134 rwi=3478}}\hfil}$$
@y
%\let\maybe=\iffalse

@* Program.
Use separate arduino with matrix keypad and separate router with \.{tel}.
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
  EIMSK |= 1 << INT1; /* turn on INT1; if it happens while USB RESET interrupt
    is processed, it does not change anything, as the device is going to be reset;
    if USB RESET happens whiled this interrupt is processed, it also does not change
    anything, as USB RESET is repeated several times by USB host, so it is safe
    that USB RESET interrupt is enabled (we cannot disable it because USB host
    may be rebooted) */
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
    @<Check |PD2| and indicate it via |PD5| and if it changed write to USB `\.@@' or `\.\%'
      (the latter only if DTR)@>@;
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

@ Add led between ground and PB6 (via 330 ohm resistor).

Button press indication LED is used without interrupts and timers, because
we block the program anyway inside the debounce interval, so use that to turn
the LED off.

Take to consideration that:

\item{1.} \\{ioctl} call blocks in application until it is
read in this program
\item{2.} data is read by USB host as soon as it is sent, even if \\{read}
call has not been done in application yet (i.e., it is buffered)

`\.B' and `\.C' are compensation for DTMF features absent in matrix:
We set debounce delay and thus cannot increase volume quickly, whereas
in DTMF pulse duration is permitted to be short.

TODO: increase debounce on A? This is useful when we switch off (when done with a router) and
then immediately switch on to go to another router - for this maybe use separate
button to go off-line instead of pressing A second time (for this
do not use saying time in ru and in fr - and use button B to go
off-line, and use C and D for volume (as B
and C now) and switch off all routers manually)

NOTE: if necessary, you may set 16-bit timers here as if interrupts are not
enabled at all (if USB RESET interrupt happens, device is going to be reset anyway,
so it is safe that it is enabled (we cannot disable it because USB host may be
rebooted)
NOTE: if you decide to do keypress indication via timer, keep in mind that keypress
indication timeout
must not increase debounce delay (so that when next key is pressed, the timer is guaranteed
to expire - before it is set again)

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
      // indicator led on PB6 - it has its own - PD5
      if (DDRD & 1 << PD1)
        DDRD &= ~(1 << PD1);
      else
        DDRD |= 1 << PD1; /* ground (on-line) */
      _delay_ms(1); /* eliminate capacitance\footnote\dag{This corresponds to ``2)'' in
        |@<Eliminate capacitance@>|.} */
    }
    @<Check |PD2| and indicate it via |PD5| and if it changed write to USB `\.@@' or `\.\%'
      (the latter only if DTR)@>@;
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

      /* HINT: see debounce handling in usb/kbd.ch and usb/cdc.ch */
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
#if 0 /* this is how it was done in cdc.ch */
  while (1) {
    @<Get |line_status|@>@;
    if (line_status.DTR) {
      @<Get button@>@;
      if (btn != 0) {
        /* Send button */
        U8 prev_button = btn;
        int timeout = 2000;
        while (--timeout) {
          @<Get button@>@;
          if (btn != prev_button) break;
          _delay_ms(1);
        }
        while (1) {
          @<Get button@>@;
          if (btn != prev_button) break;
          /* Send button */
          _delay_ms(50);
        }
      }
    }
  }
#endif
@z

@x
@ We check if handset is in use by using a switch. The switch is
optocoupler.

TODO create avrtel.4 which merges PC817C.png and PC817C-pinout.png,
except pullup part, and put section "enable pullup" before this section
and "git rm PC817C.png PC817C-pinout.png"

For on-line indication we send `\.@@' character to \.{tel}---to put
it to initial state.
For off-line indication we send `\.\%' character to \.{tel}---to disable
power reset on base station after timeout.

$$\hbox to9cm{\vbox to5.93cm{\vfil\special{psfile=avrtel.4
  clip llx=0 lly=0 urx=663 ury=437 rwi=2551}}\hfil}$$
@y
@ We check if handset is in use by using a switch. The switch (PD2) is
controlled by the program itself by connecting it to another pin (PD1).
This is to minimalize the amount of changes in this change-file.
FIXME: if you re-do matrix without change-file, do not use PD1 and
PD2 --- use just a variable

For on-line indication we send `\.@@' character to \.{tel}---to put
it to initial state.
For off-line indication we send `\.\%' character to \.{tel}---to disable
power reset on base station after timeout.
@z

@x
@* Headers.
@y
@* Matrix.

$$\hbox to6cm{\vbox to6.59cm{\vfil\special{psfile=../usb/keymap.eps
  clip llx=0 lly=0 urx=321 ury=353 rwi=1700}}\hfil}$$

This is the working principle:
$$\hbox to7cm{\vbox to4.2cm{\vfil\special{psfile=../usb/keypad.eps
  clip llx=0 lly=0 urx=240 ury=144 rwi=1984}}\hfil}$$

A is input and  C1 ... Cn are outputs.
We "turn on" one of C1, C2, ... Cn at a time by connecting it to ground inside the chip
(i.e., setting it to logic zero).
Other pins of C1, C2, ... Cn are not connected anywhere at that time.
The current will always flow into the pin which is connected to ground.
The current has to flow into your transmitter for the receiver to be able to tell it's a zero.
Now when the switch connected to this output pin is pressed, the input A
is pulled to ground through the switch, and its state becomes zero.
Pressing other switches doesn't change anything, since their other pins
are not connected to ground. When we want to read another switch, we
change the output pin which is connected to ground, so that always
just one of them is set like that.

To set output pin, do this:
|DDRx.y = 1|.
To unset output pin, do this;
|DDRx.y = 0|.

@ This is how keypad is connected:

\chardef\ttv='174 % vertical line
$$\vbox{\halign{\tt#\cr
+-----------+ \cr
{\ttv} 1 {\ttv} 2 {\ttv} 3 {\ttv} \cr
{\ttv} 4 {\ttv} 5 {\ttv} 6 {\ttv} \cr
{\ttv} 7 {\ttv} 8 {\ttv} 9 {\ttv} \cr
{\ttv} * {\ttv} 0 {\ttv} \char`#\ {\ttv} \cr
+-----------+ \cr
\ \ \ \ \ {\ttv} {\ttv} \cr
\ \ \ \ \ {\ttv} {\ttv} \cr
\ \ +-------+ \cr
\ \ {\ttv}1234567{\ttv} \cr
\ \ +-------+ \cr
}}$$

Where 1,2,3,4 are |PB4|,|PB5|,|PE6|,|PD7| and 5,6,7 are |PF4|,|PF5|,|PF6|.

@ @<Pullup input pins@>=
PORTB |= 1 << PB4 | 1 << PB5;
PORTE |= 1 << PE6;
PORTD |= 1 << PD7;

@ @<Global variables@>=
U8 btn = 0;

@
% NOTE: use index into an array of Pxn if pins in "for" are not consequtive:
% int a[3] = { PF3, PD4, PB5 }; ... for (int i = 0, ... DDRF |= 1 << a[i]; ... switch (a[i]) ...

% NOTE: use array of indexes to separate bits if pin numbers in "switch" collide:
% int b[256] = {0};
% if (~PINB & 1 << PB4) b[0xB4] = 1 << 0; ... if ... b[0xB5] = 1 << 1; ... b[0xE6] = 1 << 2; ...
% switch (b[0xB4] | ...) ... case b[0xB4]: ...
% (here # in woven output will represent P)

@<Get button@>=
    for (int i = PF4, done = 0; i <= PF7 && !done; i++) {
      DDRF |= 1 << i;
      @<Eliminate capacitance@>@;
      switch (~PINB & (1 << PB4 | 1 << PB5) | ~PINE & 1 << PE6 | ~PIND & 1 << PD7) {
      case 1 << PB4:
        switch (i) {
        case PF4: btn = '1'; @+ break;
        case PF5: btn = '2'; @+ break;
        case PF6: btn = '3'; @+ break;
        case PF7: btn = 'A'; @+ break;
        }
        done = 1;
        break;
      case 1 << PB5:
        switch (i) {
        case PF4: btn = '4'; @+ break;
        case PF5: btn = '5'; @+ break;
        case PF6: btn = '6'; @+ break;
        case PF7: btn = 'B'; @+ break;
        }
        done = 1;
        break;
      case 1 << PE6:
        switch (i) {
        case PF4: btn = '7'; @+ break;
        case PF5: btn = '8'; @+ break;
        case PF6: btn = '9'; @+ break;
        case PF7: btn = 'C'; @+ break;
        }
        done = 1;
        break;
      case 1 << PD7:
        switch (i) {
        case PF4: btn = '*'; @+ break;
        case PF5: btn = '0'; @+ break;
        case PF6: btn = '#'; @+ break;
        case PF7: btn = 'D'; @+ break;
        }
        done = 1;
        break;
      default: @/
        btn = 0;
      }
      DDRF &= ~(1 << i);
    }

@ Delay to eliminate capacitance on the wire which may be open-ended on
the side of input pin (i.e., when button is not pressed), and capacitance
on the longer wire (i.e., when button is pressed).

To adjust the number of no-ops, remove all no-ops from here,
then do this: 1)\footnote*{In contrast with usual \\{\_delay\_us(1)}, here we need
to use minimum possible delay because it is done repeatedly.}
If symbol(s) will appear by themselves (FIXME: under which conditions?),
add one no-op. Repeat until this does not happen. 2) If
symbol does not appear after pressing a key, add one no-op.
Repeat until this does not happen.

FIXME: maybe do |_delay_us(1);| in |@<Pullup input pins@>| and use only 2) here?
(and then change references to this section from everywhere)

one more way to test: use |@<Get button@>| in a `|while (1) ... _delay_us(1);|' loop
and when you detect a certain button, after a debounce delay (via |i++; ... if (i<delay) ...|),
check if btn==0 in the cycle and if yes, turn on led - while you are holding the button,
led must not turn on - if it does, add nop's

NOTE: in above methods add some more nops after testing to depass border state

FIXME: maybe just use |_delay_us(1);| instead of adjustments with nop's

@d nop() __asm__ __volatile__ ("nop")

@<Eliminate capacitance@>=
nop();
nop();
nop();
nop();
nop();
nop();
nop();
nop();

@* Headers.
@z

@x
#include <util/delay.h> /* |_delay_us| */
@y
#include <util/delay.h> /* |_delay_us|, |_delay_ms| */
@z
