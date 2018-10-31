#include <p12f1840.inc> ; suitable constants for this chip
    
; my chosen config was built using "Set configuration bits" in mplab x ide
; to suit this project. The options should be self-explaining
    
; CONFIG1
; __config 0x3F84
 __CONFIG _CONFIG1, _FOSC_INTOSC & _WDTE_OFF & _PWRTE_ON & _MCLRE_OFF & _CP_OFF & _CPD_OFF & _BOREN_ON & _CLKOUTEN_OFF & _IESO_ON & _FCMEN_ON
; CONFIG2
; __config 0x1EFF
 __CONFIG _CONFIG2, _WRT_OFF & _PLLEN_OFF & _STVREN_ON & _BORV_LO & _LVP_OFF


; Constants
  ; no PLL, 4MHz clock, internal clock source
OSCCONBITS EQU (0 << SPLLEN) | (b'1011' << IRCF0) | (b'10' << SCS0)
  ; analog select (1) - set to 0 for digital port pin
ANSELBITS EQU b'00010100' ; buggers are all on by default (!)
  ; a single output pin for led management
TRISBITS EQU b'111100' ; 0=output, 1=input (high impedance)
  
T1CONBITS EQU b'00110001' ; 1/8 prescale, run ..  

  cblock 0x70
    INNER
    OUTER
  endc
 
RVECT  code    0x0000        ; processor reset vector
  goto    SETUP

ISR    code    0x0004        ; interrupts go here
  goto    INTHANDLER

SETUP 

  ; setting it up .. configure clock, io and peripherals
  movlb 1 ; start messing around with banks, OSCCON is bank 1
  movlw OSCCONBITS
  movwf OSCCON                  ; clock = 4MHz (1MHz instructions)
  movlw TRISBITS
  movwf TRISA                   ; setup inputs/outputs
  ; peripherals are in general disabled, no trouble on startup
  ; but the comparator can be tied down if not used for even 
  ; less power usage
  movlb 3 ; ANSEL resides here ..
  movlw ANSELBITS
  movwf ANSELA
  ; configure TMR1 to blink
  movlb 0
  movlw T1CONBITS
  movwf T1CON
  ; end setting up
  ;movlb 0 .. default to bank 0
  
MAIN
  ; blink a led .. enable interrupts
  bsf INTCON, PEIE ; peripfheral ints (exists in all banks)
  movlb 1
  bsf PIE1, TMR1IE ; enable timer 1 overflow interrupt
  movlb 0
  bsf INTCON, GIE  ; master switch to enable interrupts
  movlw T1CONBITS
  movwf T1CON      ; T1CON is accessible from bank 0
  bcf PIR1, TMR1IF ; clear existing interrupt flag
  movlb 2          ; to work on LATA
  
LOOP  
  
  incfsz INNER, f
  goto $-1
  incfsz OUTER, f
  goto LOOP
  movlw 0x02
  iorwf LATA, f    ; toggle output 1
  
  goto LOOP        ; endlessly do this

INTHANDLER  

  movlb 0
  bcf PIR1, TMR1IF ; clear existing interrupt flag
  movlb 2
  movlw b'00000001'; prepare to flip a bit
  xorwf LATA, f    ; flip output of bit 0, RA0, pin 7
  
  retfie           ; auto state change on interrupt - just leave when done
  
  END
