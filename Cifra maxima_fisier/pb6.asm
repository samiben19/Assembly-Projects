bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fopen, fclose, printf, fread
import exit msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import printf msvcrt.dll
import fread msvcrt.dll

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    nume_fisier db "test.txt", 0
    mod_acces db "r",0
    desciptor_fis dd -1
    len equ 100
    text times len db 0
    
    format2 db "Cifra cu cea mai mare frecventa e: %d si apare de: %d ori", 0
    
    ;len_cif equ $-cifre
    cifre times $-text db 0
    len_cifre db 0
    fr times 10 db 0
    cifm dd 0
    frm dd 0
; our code starts here
segment code use32 class=code
    start:
        ; ...
        ; Se da un fisier text. Sa se citeasca continutul fisierului, sa se determine cifra cu cea mai mare frecventa si sa se afiseze acea cifra impreuna cu frecventa acesteia. Numele fisierului text este definit in segmentul de date.
        
        ; Deschidere fisier
        push dword mod_acces
        push dword nume_fisier
        call [fopen]
        add esp, 4*2
        
        mov [desciptor_fis], eax
        cmp eax, 0
        je final
        
        ; Citire
        push dword [desciptor_fis]
        push dword len
        push dword 1
        push dword text
        call [fread]
        add esp, 4*4
        
        ; Inchidere fisier
        push dword [desciptor_fis]
        call [fclose]
        add esp, 4
        
        ; Luam cifrele
        mov ecx, len
        mov esi, text
        mov edi, cifre
        cifre_repeta:
            lodsb
            cmp AL, '0'
            JB skip      
            cmp AL, '9'    
            JA skip      
            sub AL, '0' ; Convertim din ASCII in nr
            stosb
            inc byte[len_cifre] ; Sa stim cate cifre sunt
            skip:
        loop cifre_repeta
        
        ; Contorizarea in "vectorul de frecventa"
        mov ecx, [len_cifre]
        mov esi, cifre
        frecventa_repeta:
            mov EAX, 0
            lodsb
            inc byte[fr+eax]
        loop frecventa_repeta
        
        ; Cifra maxima
        mov ecx, 9
        mov esi, 0
        mov al,0
        mov bl,0
        mov al,byte[fr+esi]
        mov [cifm],bl
        mov [frm],al
        repeta3:
        inc esi
        mov bl,byte[fr+esi]
        cmp al,bl
        jb mic
        ja sari


        mic:
        mov al, bl
        mov [cifm], esi
        mov [frm], al

        sari:
        loop repeta3
        
        ; Afis
        push dword [frm]
        push dword [cifm]
        push dword format2
        call [printf]
        add esp, 4*3
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
