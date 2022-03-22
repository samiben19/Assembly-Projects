bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, scanf, printf
import exit msvcrt.dll
import scanf msvcrt.dll
import printf msvcrt.dll

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    a dd 106
    mesaj_citire dd "Introduceti numarul b: ",0
    mesaj_rezultat dd "Rezultatul lui %d + %d/%d este: %d",0
    mesaj_zero dd "Nu se poate face impartirea cu 0 !",0
    b dd 0
    b_format dd "%d"
; our code starts here
segment code use32 class=code
    start:
        ; Se da un numar natural a (a: dword, definit in segmentul de date). Sa se citeasca un numar natural b si sa se calculeze: a + a/b. Sa se afiseze rezultatul operatiei. Valorile vor fi afisate in format decimal (baza 10) cu semn.
        
        
        ;afisarea mesajului de citire
        push dword mesaj_citire
        call [printf]
        add esp, 4*1
        
        ;citirea lui b
        push dword b
        push dword b_format
        call [scanf]
        add esp, 4*2
        
        ;rezolvarea cerintei
        cmp dword[b], 0
        jz zero
        mov eax, [a]
        CDQ
        idiv dword[b]
        add eax, dword[a]
        
        ;afisarea rezultatului
        push dword eax
        push dword[b]
        push dword[a]
        push dword[a]
        push mesaj_rezultat
        call [printf]
        add esp, 4*2
        
        jmp sfarsit
        zero:
        push dword mesaj_zero
        call [printf]
        add esp, 4*1
        sfarsit:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
