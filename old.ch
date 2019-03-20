@x
$$\hbox to12.27cm{\vbox to9.87777777777778cm{\vfil\special{psfile=avrtel.1
  clip llx=-91 lly=-67 urx=209 ury=134 rwi=3478}}\hfil}$$
@y
%$$\hbox to12.27cm{\vbox to9.87777777777778cm{\vfil\special{psfile=old.1
%  clip llx=-100 lly=-67 urx=200 ury=134 rwi=3478}}\hfil}$$
$$\hbox to12.27cm{\kern-0.4pt\vrule\vbox to9.87777777777778cm{%
\kern-0.4pt\hrule width12.27cm\vfil\special{psfile=old.1
  llx=-100 lly=-67 urx=200 ury=134 rwi=3478}\hrule\kern-0.4pt}\hfil\vrule\kern-0.4pt}$$
@z

To use landscape image:
1. use imgsize with required width and/or height as it must be in landscape mode
2. exchange hbox and vbox dimensions
3. in \special add "angle=90 hoffset=<ury-lly>"

@x
  UENUM = EP1;
@y
  @<Set |PD2| to pullup mode@>@;
  UENUM = EP1;
@z

@x
if (PIND & 1 << PD2) { /* on-line */
@y
if (!(PIND & 1 << PD2)) { /* on-line */
@z

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
