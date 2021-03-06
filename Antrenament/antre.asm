bits 32 

global start

extern exit, printf
import exit msvcrt.dll
import printf msvcrt.dll

segment data use32 class=data
    sir1 dd 1245AB36h, 23456789h, 1212F1EEh
    len_sir1 equ ($-sir1)/4
    sir2 times len_sir1 db 0
    sir3 times len_sir1 db 0
    len_sir2 db 0
    format db '%d', 0
    format_cu_spatiu db ' %d', 0
    format_endl db 10, 0
    a dw 2C1Dh
b db 7Ah, 3Bh

segment code use32 class=code
    start:
    mov ax, [b]
        mov ESI, sir1
        mov EDI, sir2
        mov ECX, len_sir1
        JECXZ final1
        bucla:
            lodsb
            lodsb
            cmp AL, 0
            jge skip
            stosb
            inc byte[len_sir2]
            skip:
            lodsw
        loop bucla
        mov ECX, -1
        
        final1:
        JECXZ final2
        
        mov ESI, sir2
        mov ECX, 0
        mov CL, [len_sir2]
        bucla_1:
            lodsb
            pushad
            mov ECX, 8
            bucla_nr:
                shl AL, 1
                jc afis_1
                pushad
                push dword 0
                push dword format
                call [printf]
                add ESP, 4*2
                popad
                jmp skip_1
                afis_1:
                pushad
                push dword 1
                push dword format
                call [printf]
                add ESP, 4*2
                popad
                skip_1:
            loop bucla_nr
            popad
        loop bucla_1
        
        ;ENDL
        push format_endl
        call [printf]
        add ESP, 4*1
        
        mov ESI, sir2
        mov ECX, 0
        mov CL, [len_sir2]
        bucla_2:
            lodsb
            cbw
            cwde
            pushad
            push EAX
            push format_cu_spatiu
            call [printf]
            add ESP, 4*2
            popad
        loop bucla_2
        final2:
        push    dword 0
        call    [exit]
