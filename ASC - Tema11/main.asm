bits 32

global start

extern exit, scanf, printf
import exit msvcrt.dll
import scanf msvcrt.dll
import printf msvcrt.dll

extern cifra_sute

segment data use32 class=data
    format_citire db 'Introduceti numere intregi in baza 10 (cate unul pe linie, 0 pentru a incheia citirea): ', 10, 0 
    format_mesaj_afis db 'Sirul compus din cifra sutelor a numerelor este: ', 0
    format_afis db '%d ', 0
    format_zero db 'Nu exista numere in sir !', 0
    
    n dd 0
    format db '%d', 0
    len_s1 dd 0
    s1 dd 0
    
    
segment code use32 public class=code
;Sa se citeasca un sir de numere intregi s1 (reprezentate pe dublucuvinte) in baza 10. Sa se determine si sa se afiseze sirul s2 ;compus din cifrele aflate pe poziţia sutelor în fiecare numar intreg din sirul s1.
    ;Exemplu:
    ;Sirul s1: 5892, 456, 33, 7, 245
    ;Sirul s2: 8, 4, 0, 0, 2
    start:
        ; Citirea (pana se citeste 0)
        push dword format_citire
        call [printf]
        add esp, 4
        
        .citire:
            push dword n
            push dword format
            call [scanf]
            add esp, 4*2
            
            cmp dword[n], 0
            jz .continua
            mov edx, [n]
            mov eax, [len_s1]
            mov [s1+eax*4], edx
            inc dword[len_s1]
            cmp dword[n],0
            jnz .citire
        .continua:
        ; Prelucrare sir
        ;mov ecx, dword[len_s1]
        ;inc [ecx]
        mov ecx, dword[len_s1]
        jecxz .final
        ; Afis mesaj
        pushad
        push format_mesaj_afis
        call [printf]
        add esp, 4
        popad
        
        lea edx, [s1+4*ecx]
        mov ecx, 0
        .repeta:
            mov eax, dword[s1+ecx*4]
            PUSHAD
            
            push eax
            call cifra_sute
            ;mov eax, 0FFh
            
            mov dword[n], eax
            ;add esp, 4
            POPAD
            mov eax, dword[n]
            mov dword[edx], eax
            
            ;afis
            PUSHAD
            push EAX
            push format_afis
            call [printf]
            add esp, 4*2
            POPAD
            
            add edx, 4
            inc ecx
            cmp ecx, dword[len_s1]
            jne .repeta
        .final:
        cmp ecx, 0
        jnz .fara_mesaj
        push format_zero
        call [printf]
        add esp, 4
        .fara_mesaj:
        push    dword 0
        call    [exit]