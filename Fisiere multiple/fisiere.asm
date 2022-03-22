bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fopen, fclose, fread, printf, fprintf
import exit msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fread msvcrt.dll
import fprintf msvcrt.dll
import printf msvcrt.dll

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    sir db "abcdefghij", 0
    fisier_in db "fisier_in.txt", 0
    mod_citire db "r", 0
    mod_scriere db "w", 0
    descriptor dd -1
    descriptor_out dd -1
    
    n db 0
    fisier_out db "output-i.txt", 0
    care_fis db 0
    format db "%c", 0
    

;Se da in data segment un sir de exact 10 caractere si numele unui fisier. Fisierul dat contine un numar de la 0 la 9. Sa se ;citeasca acel numar (fie n numarul citit). Sa se creeze n fisiere, fiecare avand numele output-i.txt, unde i=0,n. Sa se scrie in ;fiecare fisier primele (i+1) caractere din sirul dat.

;Exemplu:
;sir: abcdefghij nume: input.txt input.txt 2 => output-0.txt a output-1.txt ab output-2.txt abc

segment code use32 class=code
    start:
        ; Deschidere fisier
        ; EAX = fopen(nume_fisier,mod_acces)
        push dword mod_citire
        push dword fisier_in
        call [fopen]
        add esp, 4*2
        
        mov [descriptor], EAX
        ; Verificam daca fisierul s-a creat cu succes
        cmp EAX, 0
        je final
        
        ; Citire din fisier
        ; EAX = fread(text, 1, len, descriptor_fis)
        push dword [descriptor]
        push dword 1
        push dword 1
        push dword n   
        call [fread]
        add esp, 4*4  ; dupa apelul functiei fread EAX contine numarul de caractere citite din fisier
        
        mov CL, byte[n]
        sub CL, '0'
        mov byte[n], CL
        
        mov CL, 0
        while1:
            mov BL, CL
            mov [care_fis], BL
            add BL, '0'
            mov [fisier_out+7], BL
            ; Deschidere fisier out
            ; EAX = fopen(nume_fisier,mod_acces)
            pushad
            push dword mod_scriere
            push dword fisier_out
            call [fopen]
            add esp, 4*2
            
            mov [descriptor_out], EAX
            popad
            ; Verificam daca fisierul s-a creat cu succes
            cmp EAX, 0
            je finalp
            
            ; fprintf(descriptor_fis, format, var)
            pushad
            mov CL, 0
            mov ESI, sir
            while_afis:
                mov EAX, 0
                lodsb
                pushad
                push dword EAX
                push dword format
                push dword [descriptor_out]
                call [fprintf]
                add esp, 4*3
                popad
                inc CL
                cmp CL, [care_fis]
                jbe while_afis
            popad
            finalp:
            ; Inchidere fisier fclose(descriptor_fis)
            pushad
            push dword [descriptor_out]
            call [fclose]
            add esp, 4*1
            popad
            
            inc CL
            cmp CL, [n]
            jb while1
            
        final:
        ; Inchidere fisier fclose(descriptor_fis)
        push dword [descriptor]
        call [fclose]
        add esp, 4*1
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
