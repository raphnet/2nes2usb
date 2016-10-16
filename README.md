# 2nes2usb: Firmware to connect up to two NES/SNES controllers to USB

2nes2usb is a firmware for Atmel ATmega8 and Atmega168 micro-controllers which allows one to
connect up to 2 NES and/or SNES controllers to a PC using a single circuit.

The device connects to an USB port and appears to the
PC as standard HID joystick with 2 report Id's. This means
that it looks like 2 controllers in the Windows
control_panel->game_controllers window.

## Project homepage

Schematic and additional information such as build examples are available on the project homepage:

English: [2 NES/SNES to USB](http://www.raphnet.net/electronique/2nes2usb/index_en.php)
French: [2 NES/SNES à USB](http://www.raphnet.net/electronique/2nes2usb/index.php)

## Supported micro-controller(s)

Currently supported micro-controller(s):

* Atmega8
* Atmega168

Adding support for other micro-controllers should be easy, as long as the target has enough
IO pins, enough memory (flash and SRAM) and is supported by V-USB.

## Built with

* [avr-gcc](https://gcc.gnu.org/wiki/avr-gcc)
* [avr-libc](http://www.nongnu.org/avr-libc/)
* [gnu make](https://www.gnu.org/software/make/manual/make.html)

## License

This project is licensed under the terms of the GNU General Public License, version 2.

## Acknowledgments

* Thank you to Objective development, author of [V-USB](https://www.obdev.at/products/vusb/index.html) for a wonderful software-only USB device implementation.
