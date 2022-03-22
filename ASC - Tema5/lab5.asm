bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    s db '+', '4', '2', 'a', '8', '4', 'X', '5'
    l equ $-s
    d times l db 0
; our code starts here
segment code use32 class=code
    start:
        ; Se da un sir de caractere S. Sa se construiasca sirul D care sa contina toate caracterele cifre din sirul S.
        mov ECX, l  ; de cate ori se repeta loop-ul
        mov EBX, 0  ; contor pentru 'd'
        mov ESI, 0  ; contor pentru 's'
        repet:  ; inceputul structurii repetitive
        mov AL, [s+ESI] ; in AL se va afla codul ASCII al lui [s+ESI]
        cmp AL, '0'     ; se compara codul ASCII al lui AL cu codul ASCII al lui 0
        JB skip             ;daca in urma compararii, AL e mai mic decat 0 se sare la 'skip'
        cmp AL, '9'     ; se compara codul ASCII al lui AL cu codul ASCII al lui 9
        JA skip             ;daca in urma compararii, AL e mai mare decat 9 se sare la 'skip'
        mov [d+EBX], AL ; daca in urma celor 2 comparari nu s-au realizat sarituri inseamna ca 
                                ;in AL se afla o cifra deci o memoram in [d]
        inc EBX                 ;se incrementeaza EBX
        skip:   
        inc ESI ; se incrementeaza ESI
        loop repet  ; se decrementeaza ECX si se verifica daca nu este egal cu 0. Daca este diferit de 0, se sare la 'repet'
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
