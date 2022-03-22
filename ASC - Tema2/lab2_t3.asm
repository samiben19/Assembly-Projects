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
    a DW 2
    b DW 3
    c DW 4
    d DW 1
; our code starts here
segment code use32 class=code
    start:
    ; c-(d+a)+(b+c)
        mov AX, [c] ; AX = c
        
        mov BX, [d] ; BX = d
        add BX, [a] ; BX = BX+a = d+a
        
        sub AX, BX  ; AX = AX-BX = c-(d+a)
        
        mov BX, [b] ; BX = b
        add BX, [c] ; BX = BX+c = b+c
        
        add AX, BX  ; AX = AX+BX = c-(d+a)+(b+c)
                    ; rezultatul final se afla in AX
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
