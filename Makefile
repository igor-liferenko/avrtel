MCU=atmega32u4
avrtel:
	avr-gcc -mmcu=$(MCU) -g -Os -c $@.c
	avr-gcc -mmcu=$(MCU) -g -o $@.elf $@.o
	avr-objcopy -O ihex $@.elf $@.hex
	avrdude -c usbasp -p $(MCU) -U flash:w:$@.hex -qq

test:
	avr-gcc -mmcu=$(MCU) -g -Os -c test-PC817C.c
	avr-gcc -mmcu=$(MCU) -g -o test.elf test-PC817C.o
	avr-objcopy -O ihex test.elf test.hex
	avrdude -c usbasp -p $(MCU) -U flash:w:test.hex -qq
