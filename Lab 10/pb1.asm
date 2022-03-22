bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import printf msvcrt.dll                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    a dw 1234h,5678h,90h
    len_a equ ($-a)/2
    b dw 4h,0abcdh,10h,1122h
    len_b equ ($-b)/2
    c resb len_a+len_b
    format_afis1 db "Numerele inainte de ordonare sunt: ", 0
    format_afis2 db "Numerele dupa ordonare sunt: ", 0
    format db "%x ",0
    endl db 10, 0
    
; our code starts here
segment code use32 class=code
    start:
        ; a. Se dau doua siruri de cuvinte a si b. Sa se obtina sirul c astfel:
        ; - concatenati sirul octetilor low din primul sir cu sirul octetilor high din al doilea sir.
        ; - sirul c se va ordona crescator
        ; - numerele din siruri se vor interpreta cu semn
        ; - afisati sirul c (numere in baza 16)
        ;1. Prelucrarea sirului A
        mov ESI, a
        mov EDI, c
        mov ECX, len_a
        prelucrare_a:
            lodsb
            stosb
            lodsb
        loop prelucrare_a
        ;2. Prelucrarea sirului B
        mov ESI, b
        lea EDI, [c+len_a]
        mov ECX, len_b
        prelucrare_b:
            lodsb
            lodsb
            stosb
        loop prelucrare_b
        
        push dword format_afis1
        call [printf]
        add ESP, 4
        
        mov ECX, len_a+len_b
        mov ESI, c
        afis0:
            mov EAX, 0
            lodsb
            PUSHAD
            push EAX
            push dword format
            call [printf]
            add ESP, 4*2
            POPAD
        loop afis0
            push dword endl
            call [printf]
            add ESP, 4
        
        ;3. Ordonarea
        mov EBX, 0
        mov ECX, (len_a+len_b)-1
        ordonare:
            lea ESI, [c+EBX]
            push ECX
            ;lodsb
            mov AL, [ESI]
            mov DL, AL
            ;dec ESI
            urmatoarele:
                mov AL, byte[ESI+ECX]
                cmp AL, byte[ESI]
                jge skip0
                mov DL, byte[ESI+ECX]
                mov DH, byte[ESI]
                mov byte[ESI+ECX], DH
                mov byte[ESI], DL
                skip0:
                dec ECX
                cmp ECX, 0
                jne urmatoarele
            inc ESI
            inc EBX
            pop ECX
        loop ordonare
        
        push dword format_afis2
        call [printf]
        add ESP, 4
        
        mov ECX, len_a+len_b
        mov ESI, c
        afis:
            mov EAX, 0
            lodsb
            PUSHAD
            push EAX
            push dword format
            call [printf]
            add ESP, 4*2
            POPAD
        loop afis
            
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
