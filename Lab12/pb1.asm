;Să se citească din fişierul „f1.txt” un şir S de maximum 16 caractere, fără spaţii.
;Să se calculeze lungimea acestui şir, notată cu N.
;Se va verifica faptul că lungimea acestui şir este cuprinsă între 1 şi 16;
;dacă nu este cuprinsă între 1 şi 16, se va afişa mesajul de eroare „Lungimea şirului nu este cuprinsă între 1 şi 16!”
;şi programul se va termina .
;Se citeste de la tastatura numarul k intre 1 si 16.
;Se vor genera toate „combinările de N luate câte k”, C_N^k , dintre caracterele şirului S, pe ecran, pe linii distincte.
;(adica "submultimile de k elemente ale multimi icu n elemente" )
;ex: abcdef0123456789
;submultimile de cate un element sunt a,b,c,d,...
;submultimile de cate doua elemente sunt ab,ac,ad,...

bits 32
global start     

extern exit, fopen, fclose, fread, printf
import exit msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fread msvcrt.dll
import printf msvcrt.dll

segment data use32 class=data
    nume_fisier db "fisier.txt", 0
    mod_acces db "r", 0
    descriptor dd -1
    format_citire db "%s", 0
    
    afis_citire db "Sirul din fisier este: ", 0
    afis_lungime0 db "Lungimea sirului nu este cuprinsa intre 1 si 16!", 0
    endl db 10, 0
    
    caracter db 0
    S times 17 db 0
    N db 0

segment code use32 class=code
    start:
    ; Deschidere fisier
    ; EAX = fopen(nume_fisier,mod_acces)
    push dword mod_acces
    push dword nume_fisier
    call [fopen]
    
    mov [descriptor], EAX
    ; Verificam daca fisierul s-a creat cu succes
    cmp EAX, 0
    je final
    
    ; Citire din fisier
    ; EAX = fread(text, 1, len, descriptor_fis)
    mov EDI, S
    while_citire:
        push dword [descriptor]
        push dword 1
        push dword 1
        push dword caracter    
        call [fread]
        add esp, 4*4  ; dupa apelul functiei fread EAX contine numarul de caractere citite din fisier
        
        cmp EAX, 0
        je iesire_citire
        mov AL, [caracter]
        stosb
        inc byte[N]
        jmp while_citire
    iesire_citire:
    
    ; Verificam daca N este cuprins intre 1 si 16
    cmp byte[N], 0
    jbe final_0
    
    cmp byte[N], 16
    ja final_0
    
    ; Afisam sirul initial
    ; printf(format, var)
    push dword afis_citire
    call [printf]
    add ESP, 4*1
    
    push dword S
    push dword format_citire
    call [printf]
    add ESP, 4*2
    
    push dword endl
    call [printf]
    add ESP, 4*1
    jmp final
    
    final_0:
    ; Afisam mesajul 
    ; printf(format, var)
    push dword afis_lungime0
    call [printf]
    add ESP, 4*1
    
    final:
    push dword 0
    call [exit]