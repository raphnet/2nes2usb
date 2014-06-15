CC=avr-gcc
LD=$(CC)
CFLAGS=-Wall -Os -Iusbdrv -I. -mmcu=atmega8 -DF_CPU=12000000L
LDFLAGS=-mmcu=atmega8
UISP= uisp -dprog=stk500 -dpart=atmega8 -dserial=/dev/avr
COMMON_OBJS = usbdrv/usbdrv.o usbdrv/usbdrvasm.o usbdrv/oddebug.o main.o
OBJECTS = usbdrv/usbdrv.o usbdrv/usbdrvasm.o usbdrv/oddebug.o main.o 2nsnes.o devdesc.o
HEXFILE=main.hex

# symbolic targets:
all:	$(HEXFILE)

.c.o:
	$(CC) $(CFLAGS) -c $< -o $@

.S.o:
	$(CC) $(CFLAGS) -x assembler-with-cpp -c $< -o $@
# "-x assembler-with-cpp" should not be necessary since this is the default
# file type for the .S (with capital S) extension. However, upper case
# characters are not always preserved on Windows. To ensure WinAVR
# compatibility define the file type manually.

.c.s:
	$(CC) $(CFLAGS) -S $< -o $@

main.o: main.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(HEXFILE) main.lst main.obj main.cof main.list main.map main.eep.hex main.bin *.o usbdrv/*.o main.s usbdrv/oddebug.s usbdrv/usbdrv.s

# file targets:
main.bin:	$(COMMON_OBJS) 2nsnes.o devdesc.o
	$(LD) $(LDFLAGS) -o main.bin $(OBJECTS) -Wl,-Map=main.map


$(HEXFILE):	main.bin
	rm -f $(HEXFILE) main.eep.hex
	avr-objcopy -j .text -j .data -O ihex main.bin $(HEXFILE)
	./checksize main.bin

flash:
	avrdude -p m8 -P usb -c avrispmkII -Uflash:w:$(HEXFILE) -B 2.0

# Fuse high byte:
# 0xc9 = 1 1 0 0   1 0 0 1 <-- BOOTRST (boot reset vector at 0x0000)
#        ^ ^ ^ ^   ^ ^ ^------ BOOTSZ0
#        | | | |   | +-------- BOOTSZ1
#        | | | |   + --------- EESAVE (don't preserve EEPROM over chip erase)
#        | | | +-------------- CKOPT (full output swing)
#        | | +---------------- SPIEN (allow serial programming)
#        | +------------------ WDTON (WDT not always on)
#        +-------------------- RSTDISBL (reset pin is enabled)
# Fuse low byte:
# 0x9f = 1 0 0 1   1 1 1 1
#        ^ ^ \ /   \--+--/
#        | |  |       +------- CKSEL 3..0 (external >8M crystal)
#        | |  +--------------- SUT 1..0 (crystal osc, BOD enabled)
#        | +------------------ BODEN (BrownOut Detector enabled)
#        +-------------------- BODLEVEL (2.7V)
fuse:
	avrdude -p m8 -P usb -c avrispmkII -Uhfuse:w:0xc9:m -Ulfuse:w:0x9f:m -B 10.0

reset:
	avrdude -p m8 -P usb -c avrispmkII -B 10.0

erase:
	avrdude -p m8 -P usb -c avrispmkII -e -B 10.0
