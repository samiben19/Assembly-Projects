bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; a - byte, b - word, c - double word, d - qword 
    a DB 67h
    b DW 1234h
    c DD 14411441h
    d DQ 2345678998765432h
    
    x RESQ 1
; our code starts here
segment code use32 class=code
    start:
        ; (d+a)-(c-b)-(b-a)+(c+d)
        ; 1: (d+a)
        mov AL, [a]
        CBW
        CWDE
        CDQ
        add EAX, [d]        ; Adunam partea LOW a lui D cu EAX(partea LOW a lui 'a')
        adc EDX, [d+4]      ; Adunam partea HIGH a lui D cu EDX(partea HIGH a lui 'a')
        
        mov [x], EAX   ; Salvam rezultatul in x pentru a elibera registrii
        mov [x+4], EDX
        ; 2: (c-b)
        mov EBX, [c]
        mov AX, [b]
        CWDE
        sub EBX, EAX
        
        sub dword[x], EBX   ; (d+a)-(c-b)
        sbb dword[x+4], 0
        ; 3: (b-a)
        mov BX, [b]
        mov AL, [a]
        CBW
        sub BX, AX
        mov AX, BX
        CWDE    ; rezultatul este qword deci convertim
        CDQ
        
        sub dword[x], EAX    ; Scadem partea LOW a rezultatului cu EAX(partea LOW a lui '(b-a)')
        sbb dword[x+4], EDX  ; Scadem partea HIGH a rezultatului X cu EDX(partea HIGH a lui '(b-a)')
        
        ;mov EAX, dword[x]
        ;mov EDX, dword[x+4]
        ; 4: (c+d)
        mov EAX, [c]
        CDQ
        add EAX, dword[d]
        adc EDX, dword[d+4]
        
        add dword[x], EAX
        adc dword[x+4], EDX
        
        mov EAX, dword[x]
        mov EDX, dword[x+4]
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
