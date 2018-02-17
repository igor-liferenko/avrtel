@ It is good that TLP281 inverts the signal, because it combines well with {\sl DTR\/}
signal.
Except resetting base station to put the phone on-hook, ``{\sl DTR\/} feature'' is used in
order that base station is powered off before \.{tel}
is started (more exactly, before \.{tel} opens serial device causing DTR to go low,
and thus power on base station).
Base station is guaranteed to be powered off when serial device is opened,
because serial device can be opened only
{\sl after\/} usb2ttl was inserted into PC (at which time DTR goes high and base
station is powered off). Also, the fact that base station is not powered when
microcontroller is started (when usb2ttl is inserted into PC, microcontroller is started),
ensures that microcontroller firmware
always starts to work from ``off'' state.

Note, that base station is powered when usb2ttl is not connected to
PC.

The following phone models are used: Panasonic KX-TCD245, Panasonic KX-TG7331.
The main requirement is that power supply for base station must be DC, and it
must have led indicator for on-hook / off-hook on base station.

Note, that we can not use simple cordless phone---a DECT phone is needed, because
resetting base station to put the phone on-hook will not work
(FIXME: check if it is really so).

@d F_CPU 16000000UL

@c
#include <avr/io.h>
#include <avr/interrupt.h>

@ @c
volatile int keydetect = 0;

ISR(INT1_vect)
{
  keydetect = 1;
}

void main(void)
{
  DDRB |= 1 << PB5; /* on-line/off-line indicator; also used to get current state to determine
                       if transition happened */

  @<Set |PD0| to pullup mode@>@;

  @<Initialize UART@>@;

  EICRA |= 1 << ISC11 | 1 << ISC10; /* set INT1 to trigger on rising edge */
  EIMSK |= 1 << INT1; /* turn on INT1 */

  sei(); /* turn on interrupts */

  unsigned char digit;
  while(1) {
    @<Indicate...@>@;
    if (keydetect) {
      keydetect = 0;
      switch (PIND & 0xF0) {
      case (0x10):
        digit = '1';
        break;
      case (0x20):
        digit = '2';
        break;
      case (0x30):
        digit = '3';
        break;
      case (0x40):
        digit = '4';
        break;
      case (0x50):
        digit = '5';
        break;
      case (0x60):
        digit = '6';
        break;
      case (0x70):
        digit = '7';
        break;
      case (0x80):
        digit = '8';
        break;
      case (0x90):
        digit = '9';
        break;
      case (0xA0):
        digit = '0';
        break;
      case (0xB0):
        digit = '*';
        break;
      case (0xC0):
        digit = '#';
        break;
      default:
        digit = '?';
        break;
      }
      while (!(UCSR0A & 1 << UDRE0)) ; /* loop while the transmit buffer is not ready to receive
                                          new data */
      UDR0 = digit;
    }
  }
}

@ @d BAUD 57600

@<Initialize UART@>=
#include <util/setbaud.h>
UBRR0H = UBRRH_VALUE;
UBRR0L = UBRRL_VALUE;
#if USE_2X
  UCSR0A |= (1<<U2X0);
#endif
UCSR0B = (1<<TXEN0);
UCSR0C = (1<<UCSZ01) | (1<<UCSZ00);

@ For on-line indication we send `\.{@@}' character to PC---to put
program on PC to initial state.
For off-line indication we send `\.{\%}' character to PC---to disable
power reset on base station after timeout.

TODO: insert PC817C.png

@<Indicate line state change to the PC@>=
if (PIND & 1 << PD0) { /* off-line or base station is not powered
                          (automatically causes off-line) */
  if (PORTB & 1 << PB5) {
    while (!(UCSR0A & 1 << UDRE0)) ; /* loop while the transmit buffer is not ready to receive
                                        new data */
    UDR0 = '%';
  }
  PORTB &= (unsigned char) ~ (unsigned char) (1 << PB5);
}
else { /* on-line */
  if (!(PORTB & 1 << PB5)) {
    while (!(UCSR0A & 1 << UDRE0)) ; /* loop while the transmit buffer is not ready to receive
                                        new data */
    UDR0 = '@@';
  }
  PORTB |= 1 << PB5;
}

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

TODO: insert pullup.svg

@<Set |PD0| to pullup mode@>=
PORTD |= 1 << PD0;
