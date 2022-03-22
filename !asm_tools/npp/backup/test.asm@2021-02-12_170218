bits 32
global start

extern exit, printf
import exit msvcrt.dll
import printf msvcrt.dll

segment data use32 class=data
    s db "aAa baAaaAa aaabc asc1 aaAbc aAaabc 12aAa 123aA", 0
    subsir_cautare db "aAa", 0
    subsir_inlocuire db "X", 0
    format db "%s", 0
    
segment code use32 class=code
    inlocuire:  ; void(sir, subsir, subsir_inloc)
        
    ret 4*3
    cauta:  ; int(sir, subsir, lung)
        mov ESI, [ESP+4]
        mov EDI, [ESP+8]
        mov EDX, 0
        repeta1:
            mov AL, [esi]
            mov AH, [edi]
            cmp AL, AH
            jne reseteaza
            inc EDX
            jmp sari_reseteaza
            reseteaza:
            mov EDI, [ESP+8]
            mov edx, 0
            sari_reseteaza:
            inc ESI
            inc EDI
            cmp EDX, [ESP+12]
            je 
        jmp repeta1
        iesire_repeta1:
        
    ret 4*3
    
    start:
        mov ESI, s
        mov EDI, s

        eticheta1:
            mov EBX, 0
            eticheta2:
                cmp byte[edi], " "
                je sari1
                cmp byte[edi], 0
                je sari1
                inc EBX
                inc edi
            jmp eticheta2
            sari1:
            cmp edi, " "
            jne sari3
            inc edi
            sari3:
            cmp EBX, 4
            jl sari2
                push EBX
                push ESI
                push EDI
                push dword EBX
                push dword subsir_cautare
                push dword ESI
                call cauta
                pop EDI
                pop ESI
                pop EBX
                
                cmp EAX, -1
                je sari2
                
                push dword subsir_inlocuire
                push dword subsir
                push dword [ESI+EAX]
                call inlocuire
                
            sari2:
            mov esi, edi
            
        cmp byte[esi], 0
        jne eticheta1
        
        push dword s
        push dword format
        call [printf]
        add ESP, 4*2
        
        push dword 0
        call [exit]