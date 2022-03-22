bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    s dw -22,145,-48,127
    ls equ ($-s)/2
    d times ls db 0
; our code starts here
segment code use32 class=code
    start:
        ;  Se da un sir de cuvinte s. Sa se construiasca sirul de octeti d, astfel incat d sa contina pentru fiecare pozitie din s:
            ;- numarul de biti de 0, daca numarul este negativ
            ;- numarul de biti de 1, daca numarul este pozitiv
        mov ESI, s  ; pointeaza la s
        mov ECX, ls  ; lungimea lui s
        mov EDI, d  ; pointeaza la d
        
        jecxz iesire
        CLD     ; modul de pargurgere al lui s = de la stanga la dreapta
        parcurge_s:
            lodsw   ; in AX avem WORD-ul curent din s
            cmp AX, 0   ; aflam semnul 
            push ECX
            js negativ
            ; caz - pozitiv
                mov ECX, 16
                CLC
                cifre_caz1:
                    SHR AX, 1
                    JNC skip1
                        inc byte[EDI]
                    skip1:
                loop cifre_caz1
            jmp sfarsit_parcurge
            ; caz - negativ
            negativ:
                mov ECX, 16
                CLC
                cifre_caz2:
                    SHR AX, 1
                    JC skip2
                        inc byte[EDI]
                    skip2:
                loop cifre_caz2
            sfarsit_parcurge:
            pop ECX
            inc EDI
        loop parcurge_s
        
        iesire:
        push    dword 0
        call    [exit]
