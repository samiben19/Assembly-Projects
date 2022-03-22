bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    a DB 67h
    b DB 34h
    c DB 23h
    e DD 12345678h
    x DQ 18765432h
    ; (a+a+b*c*64h+x)/(a+Ah)+e*a = 1879 1BF0/71 = 37 7185 + e*a = 7 5346 3BCD
    rez RESQ 1
; our code starts here
segment code use32 class=code
    start:
        ; (a+a+b*c*100+x)/(a+10)+e*a; a,b,c-byte; e-doubleword; x-qword
        ; 1: (a+a+b*c*100+x) 
        mov AL, [b]     ; (b*c*100)
        imul BYTE[c]
        mov BX, 100
        imul BX
        push DX
        push AX ; salvat (b*c*100)
        pop dword[rez]
        
        mov AL, [a]     ; (a+a+b*c*100)
        CBW
        CWDE
        add dword[rez], EAX
        add dword[rez], EAX
        
        mov EAX, dword[x]   ; (a+a+b*c*100+x) 
        mov EDX, dword[x+4]
        add dword[rez], EAX
        adc dword[rez+4], EDX
        
        mov AL, [a] ; (a+10)
        CBW
        add AX, 10
        CWDE
        mov EBX, EAX
        
        mov EAX, dword[rez]
        mov EDX, dword[rez+4]
        
        ; 2: (a+a+b*c*100+x)/(a+10)
        idiv EBX     ; in EAX catul => dword (OF)
        mov dword[rez], EAX
        ; 3: e*a = qword
        mov AL, [a]
        CBW
        CWDE
        imul dword[e]
        
        ; rez+e*a ok
        add dword[rez], EAX
        adc dword[rez+4], EDX
        
        mov EAX, dword[rez]
        mov EDX, dword[rez+4]
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
