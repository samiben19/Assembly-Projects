bits 32

segment code use32 public class=code
global _cifra_sute

;int cifra_sute(int x)

_cifra_sute:
    ; creare cadru de stiva pentru programul apelat
    push ebp
    mov ebp, esp
    ; ebp     => val ebp pt apelant
    ; ebp + 4 => adresa de intoarcere in main
    ; ebp + 8 => x
    
    mov eax, [ebp + 8]
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
    
    ; refacem cadrul de stiva pentru programul apelant
    mov esp, ebp
    pop ebp
    
    ret 4