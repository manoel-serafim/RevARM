RevARM: A Pseudo-Secure TCP Reverse Shell Implementation for ARM-based Systems

## Overview
RevARM is an implementation of a TCP reverse shell for ARM-based systems. It provides the impression of security and an extremely efficient way to remotely access ARM-based devices. A C2(command and control framework) can be implemented on top of it in order to manage a range of devices.

## Usage
To use RevARM, you need to assemble and link the source code in an ARM-based device using the following commands:
```
as -o reverse.o reverse.s
ld -o reverse reverse.o
```
You can also use objcopy and xxd in order to generate needed shellcode.

## License
RevARM is released under the GNU General Public License v2.0. See the [LICENSE](LICENSE) file for more details.

## Disclaimer
RevARM is intended for educational and research purposes only. It is the end user's responsibility to obey all applicable laws regarding the use of RevARM.
