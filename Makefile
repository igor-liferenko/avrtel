MCU=atmega32u4
avrtel:
	avr-gcc -mmcu=atmega32u4 -g -Os -o $@.elf $@.c
	avr-objcopy -O ihex $@.elf fw.hex

flash:
	avrdude -c usbasp -p $(MCU) -U flash:w:fw.hex -qq

test:
	avr-gcc -mmcu=$(MCU) -g -Os -c test-PC817C.c
	avr-gcc -mmcu=$(MCU) -g -o test.elf test-PC817C.o
	avr-objcopy -O ihex test.elf test.hex
	avrdude -c usbasp -p $(MCU) -U flash:w:test.hex -qq
