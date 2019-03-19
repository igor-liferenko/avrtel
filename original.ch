This change-file is used to keep avrtel.w the same as it was on old scheme, because it is used.

@x
  @<Set |PD2| to pullup mode@>@;
@y
@z

@x
if (PIND & 1 << PD2) { /* off-line */
@y
if (!(PIND & 1 << PD2)) { /* off-line */
@z
