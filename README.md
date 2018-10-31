# pic12f1840_test
Trying to migrate from 12f675 to 12f1840 to play with 
this project now works, and it blinks!

My setup: 3 x AA batteries for power during programming and testing.
Programming with pickit3, which mostly work and report all ok
Software is latest MPLABx, programming is assembler
There is blinking/pulsing output on pin 7

I believe I am now a convert :)

Learning taken from this tiny project:
- power the chip externally
- restart computer, or at least re-plut pickit3 if weird errors arise
- search out and inspect [filename].err to catch trouble 
- use the Production-Set configuration bits to configure fuses/config bits
- the 0x70 area is "global" RAM - accessible from any bank
