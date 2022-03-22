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
    a DB 4
    b DB 5
    c DB 2
; our code starts here
segment code use32 class=code
    start:
        ; (a*b)/c
        mov AL, [a]     ;AL = a
        mul BYTE[b]     ;AX = AL*b
        
        div BYTE[c]     ;AL = AX/c si AH = AX%c
                        ;rezultatul se afla in AL(catul) si in AH(restul)
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
