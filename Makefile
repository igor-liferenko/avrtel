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
	@mp old
	@perl -ne 'if (/^(.*\.eps): (.*)/) { system "convert $$2 $$1" }' Makefile
