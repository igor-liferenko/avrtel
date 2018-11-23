MCU=atmega32u4

avrtel:
	@avr-gcc -mmcu=atmega32u4 -g -Os -o fw.elf $@.c
	@avr-objcopy -O ihex fw.elf fw.hex

dump:
	@avr-objdump -d fw.elf

flash:
	@avrdude -qq -c usbasp -p $(MCU) -U flash:w:fw.hex

clean:
	@git clean -X -d -f

imgs:
	@mpost avrtel
	@perl -ne 'if (/^(.*\.eps): (.*)/) { $$x = $$1; $$y = $$2; if ($$y=~/\.svg$$/) { system "inkscape $$y -E $$x 2>/dev/null" } else { system "convert $$y $$x" } }' Makefile

test:
	avr-gcc -mmcu=$(MCU) -g -Os -c test-PC817C.c
	avr-gcc -mmcu=$(MCU) -g -o test.elf test-PC817C.o
	avr-objcopy -O ihex test.elf test.hex
	avrdude -c usbasp -p $(MCU) -U flash:w:test.hex -qq

.PHONY: $(wildcard *.eps)

scheme.eps: scheme.svg
	@inkscape $< -E $@ 2>/dev/null
	@imgsize $@

PC817C.eps: PC817C.png
	@convert $< $@
	@imgsize $@ 9 -

tlp1.eps: tlp1.jpg
	@convert $< $@
	@imgsize $@

tlp2.eps: tlp2.jpg
	@convert $< $@
	@imgsize $@ 12 -
