commit 50296ae36d88e957abe7eb1c47dd5e9f22bf727b
Author: Igor Liferenko <igor.liferenko@gmail.com>
Date:   Thu Sep 13 08:52:26 2018 +0700

    edit

diff --git a/avrtel-buzzer.ch b/avrtel-buzzer.ch
index ff1d0fd..d3233b1 100644
--- a/avrtel-buzzer.ch
+++ b/avrtel-buzzer.ch
@@ -36,7 +36,12 @@ void main(void)
 @y
 @i ../usb/OUT-endpoint-management.w
 
-@ @<Buzz if requested@>=
+@ TODO: never change DTR automatically in cdc-acm driver and in tel.w disable it manually before
+exit or fix cdc-acm driver to set DTR only when opened as non-write, or use special program
+instead of echo and use some flag to open() and process it in cdc-acm driver - otherwise we never
+know which process set the DTR
+
+@<Buzz if requested@>=
 UENUM = EP2;
 if (UEINTX & 1 << RXOUTI) {
   UEINTX &= ~(1 << RXOUTI);
