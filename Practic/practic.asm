;Se citeste de la tastatura numele unui fisier. Sa se citeasca continutul fisierului si sa se calculeze dimensiunea fisierului in octeti. Sa se adauge ;la sfarsitul fisierului aceasta dimensiune.

;Exemplu:
;input.txt
;abcd efgh

;=> input.txt
;abcd efgh 9

bits 32

global start        

extern exit, scanf, fread, fprintf, fopen, fclose
import exit msvcrt.dll
import scanf msvcrt.dll
import fread msvcrt.dll
import fprintf msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll


segment data use32 class=data
    format_string db "%s", 0
    format_numar db " %d", 0
    mod_acces db "a+", 0
    
    nume_fisier times 31 db 0
    descriptor dd -1
    caracter db 0
    dimensiune_fisier dd 0
    

segment code use32 class=code
    start:
        ;scanf(format,adr_variab)
        push dword nume_fisier
        push dword format_string
        call [scanf]
        add esp, 4*2
        
        ; Deschidem fisierul cu drepturi de citire si append
        ; EAX = fopen(nume_fisier,mod_acces)
        push dword mod_acces
        push dword nume_fisier
        call [fopen]
        add esp, 4*2
        
        mov [descriptor], EAX
        
        ; Verificam daca fisierul s-a creat cu succes
        cmp EAX, 0
        je final
        
        ; Citire din fisier
        ; EAX = fread(text, 1, len, descriptor_fis)
        while_citire:
            push dword [descriptor]
            push dword 1
            push dword 1
            push dword caracter    
            call [fread]
            add esp, 4*4  ; dupa apelul functiei fread EAX contine numarul de caractere citite din fisier
            
            cmp EAX, 0
            je iesire_citire
            add dword[dimensiune_fisier], EAX
            jmp while_citire
        iesire_citire:
        
        ; Adaugam in fisier dimensiunea
        ; fprintf(descriptor,format,var)
        push dword [dimensiune_fisier]
        push dword format_numar
        push dword [descriptor]
        call [fprintf]
        add esp, 4*3
        
        final:
        ; Inchidere fisier fclose(descriptor_fis)
        push dword [descriptor]
        call [fclose]
        add esp, 4*1
        
        push    dword 0
        call    [exit]
