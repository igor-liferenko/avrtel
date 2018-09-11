@x
    @<Get |line_status|@>@;
@y
    @<Buzz if requested@>@;
    @<Get |line_status|@>@;
@z

@x
@* Headers.
@y
@ @<Buzz if requested@>=
UENUM = EP2;
if (UEINTX & 1 << RXOUTI) {
  UEINTX &= ~(1 << RXOUTI);
  // buzz here
  UEINTX &= ~(1 << FIFOCON);
}
UENUM = EP1; /* restore */

@* Headers.
@z
