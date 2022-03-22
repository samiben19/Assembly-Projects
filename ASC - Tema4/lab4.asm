bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    a DB 00101010b
    b DB 11100101b
    c DB 00000010b
    d DB 10100101b
; our code starts here
segment code use32 class=code
    start:
        ; Dandu-se 4 octeti, sa se obtina in AX suma numerelor intregi reprezentate de bitii 4-6 ai celor 4 octeti.
        XOR AX, AX
        OR AL, [a]
        AND AL, 01110000b
        SHR AL, 4
        
        mov ECX, 3
        mov ESI, 0
        
        repet:
            XOR BX, BX
            OR BL, byte[b+ESI]
            AND BL, 01110000b
            SHR BL, 4
            add AL, BL
            adc AH, 0
            inc ESI
        loop repet
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
