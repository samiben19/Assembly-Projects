bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; a - byte, b - word, c - double word, d - qword - Interpretare fara semn
    a DB 87h
    b DW 1234h
    c DD 14411441h
    d DQ 2345678998765432h
    
    x RESQ 1
; our code starts here
segment code use32 class=code 
    start:
        ; (d+d)-(a+a)-(b+b)-(c+c)
        ; 1 (d+d) - quad
        mov EAX, dword[d]       ; EAX = Double wordul LOW a lui [d]
        mov EDX, dword[d+4]     ; EDX = Double wordul HIGH a lui [d]
        
        add EAX, EAX        ; Se aduna partea LOW a lui [d] cu ea insasi => EAX = EAX+EAX
        adc EDX, EDX        ; Se aduna partea HIGH a lui [d] cu ea insasi 
                            ; si cu transport daca exista => EDX = EDX+EDX+CF
                             
        mov dword[x], EAX       ; Salvam rezultatul in [x] pentru a elibera registrii
        mov dword[x+4], EDX
        ; 2 (a+a) - byte
        mov AL, [a]     ; AL = [a]
        mov AH, 0       ; Conversie in WORD a lui [a]
        
        add AL, AL      ; Se aduna partea LOW a lui [a] cu ea insasi => AL = AL+AL
        adc AH, AH      ; Chiar daca BH=0, daca exista depasire se aduna CF => AH = 0+CF
        
        push AX
        mov EAX, 0     ; Conversie in DOUBLE a lui (a+a)
        pop AX
        
        sub dword[x], EAX   ; Scadem doar partea LOW fiindca partea HIGH este 0
        ; 3 (b+b) - word
        mov EAX, 0
        mov AX, [b]     ; Convertit la DWORD pentru a incapea rezultatul
        
        add EAX, EAX
        
        sub dword[x], EAX
        ; 4 (c+c) - dword
        mov EAX, [c]
        mov EDX, 0      ; Convertit la QWORD pentru a face scaderea
        
        add EAX, EAX
        adc EDX, EDX
        
        sub dword[x], EAX
        sbb dword[x+4], EDX
        
        mov EAX, dword[x] ;pentru vizualizarea rezultatului
        mov EDX, dword[x+4]
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
