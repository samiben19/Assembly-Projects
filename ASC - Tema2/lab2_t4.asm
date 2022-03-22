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
    a DB 5
    b DB 2
    c DB 1
    d DW 6
; our code starts here
segment code use32 class=code
    start:
    ; [2*(a+b)-5*c]*(d-3)
        mov AL, 2   ; AL = 2
        mov AH, [a] ; AH = a
        add AH, [b] ; AH = a+b
                    
        mul AH      ; AX = AL*AH = 2*(a+b)
        
        mov BX, AX  ; BX = AX pentru a putea face inmultirea
        
        mov AL, 5   ; AL = 5
        mul BYTE[c]      ; AX = AL*c = 5*c
        
        sub BX, AX  ; BX = BX - AX = 2*(a+b)-5*c
        
        mov AX, [d] ; AX = d
        sub AX, 3   ; AX = AX - 3 = d-3
        
        mul BX      ; DX:AX = AX*BX = (d-3)*[2*(a+b)-5*c]
        
        push DX
        push AX
        pop EAX     ; rezultatul final este in EAX
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
