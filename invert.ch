PB0 and PD5 are inverted on pro micro because TXEN0/RXEN0 macro in
arduino IDE turns it on on normal arduino, and TXEN1/RXEN1 turns it
off, so to make 0 and 1 correspond to off and on they double-inverted
leds on board. But we do not use arduino IDE and for us the problem
persists, so do the inversion in change-file to avoid headache.

Apply it after other change-file was applied via
"wmerge avrtel other >merged.w" like
"ctangle merged invert"
"make merged"

TODO: un-invert in avrtel.w
