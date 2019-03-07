MCU=atmega32u4

avrtel:
	@avr-gcc -mmcu=$(MCU) -g -Os -o fw.elf $@.c
	@avr-objcopy -O ihex fw.elf fw.hex

dump:
	@avr-objdump -d fw.elf

flash:
	@avrdude -qq -c usbasp -p $(MCU) -U flash:w:fw.hex

clean:
	@git clean -X -d -f

imgs:
	@mp avrtel
	@mp TLP281
	@perl -ne 'if (/^(.*\.eps): (.*)/) { system "convert $$2 $$1" }' Makefile

# FIXME: why to avr-gcc commands are used here?
test:
	avr-gcc -mmcu=$(MCU) -g -Os -c test-PC817C.c
	avr-gcc -mmcu=$(MCU) -g -o test.elf test-PC817C.o
	avr-objcopy -O ihex test.elf test.hex
	avrdude -c usbasp -p $(MCU) -U flash:w:test.hex -qq

TL431:
	avr-gcc -mmcu=atmega328p -g -Os -o TL431.elf $@.c
	avr-objcopy -O ihex TL431.elf TL431.hex
	avrdude -c usbasp -p atmega328p -U flash:w:TL431.hex -qq

.PHONY: $(wildcard *.eps)

tlp1.eps: tlp1.jpg
	@convert $< $@
	@imgsize $@

tlp2.eps: tlp2.jpg
	@convert $< $@
	@imgsize $@ 12 -

TL431.eps: TL431.png
	@convert $< $@
	@imgsize $@
