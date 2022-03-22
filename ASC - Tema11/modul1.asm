bits 32

segment code use32 public class=code
global cifra_sute

cifra_sute:
    mov eax, [esp + 4]
    CDQ
    mov ebx, 100
    idiv ebx
    CDQ
    mov ebx, 10
    idiv ebx
    cmp dl, 0
    jge .pozitiv
    mov eax, 0
    mov al, dl
    mov bl, -1
    imul bl
    mov edx, eax
    .pozitiv:
    mov eax, edx
    ret 4
    
    ;mov eax, [esp + 4]
    ;mov edx, 0
    ;mov ebx, 100
    ;div ebx
    ;mov edx, 0
    ;mov ebx, 10
    ;div ebx
    ;mov eax, edx
    ;ret 4