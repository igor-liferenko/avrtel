@x
@i ../usb/IN-endpoint-management.w
@y
@ @<Set |PD2| to pullup mode@>=
PORTD |= 1 << PD2;
_delay_us(1); /* after enabling pullup, wait for the pin to settle before reading it */

@i ../usb/IN-endpoint-management.w
@z

@x
@<Header files@>=
@y
@<Header files@>=
#define F_CPU 16000000UL
#include <util/delay.h> /* |_delay_us| */
@z
