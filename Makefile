MCU=atmega328p
avrtel:
	avr-gcc -mmcu=$(MCU) -g -Os -c $@.c
	avr-gcc -mmcu=$(MCU) -g -o $@.elf $@.o
	avr-objcopy -O ihex $@.elf $@.hex
	avrdude -c usbasp -p $(MCU) -U flash:w:$@.hex -qq
