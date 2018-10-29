# pic12f1840_test
Trying to migrate from 12f675 to 12f1840 to play with - if I get this to work, it will blink!

My setup: 3 x AA batteries for power during programming and testing.
Programming with pickit3, which mostly work and report all ok
Software is latest MPLABx, programming is assembler
The standalone MCU does nothing
There should be a blinking/pulsing output on pin 7, and the clock Fosc/4 should be available from pin 3
Strategies from here:
- pullup on the mclr pin - even if reset is disabled with fuses/config
- play around with config bits
- cry out on reddit                   
