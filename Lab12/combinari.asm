bits 32

extern printf
import printf msvcrt.dll

segment data use32 class=data
    endl db 10, 0
    sirp times 17 db 0

segment code use32 public class=code
global combinari

;int n, k, v[20], s[20];

; void back(int pas, int k)
; {
    ; if(pas==k)
    ; {
        ; for(int j=0;j<pas;j++)
            ; cout<<v[s[j]-1]<<' ';
        ; cout<<endl;
    ; }
    ; for(int j=s[pas-1]+1;j<=n;j++)
    ; {
        ; s[pas]=j;
        ; back(pas+1, k);
    ; }
; }

; int main()
; {
    ; cin>>n;
    ; for(int i=0;i<n;i++)
        ; cin>>v[i];
    ; cin>>k;
    ; back(0, k);
    ; return 0;
; }

;int combinari(pas, k, n, adresa_sir)
combinari:
    ; STIVA
    ; ESP - revenire
    ; ESP+4 - pas
    ; ESP+8 - k
    ; ESP+12 - n
    ; ESP+16 - adresa_sir
    cmp dword[ESP+4], dword[ESP+8]
    jne .formare
        push dword sirp
        call [printf]
        add ESP, 4*1
        push endl
        call [printf]
        add ESP, 4*1
    ; for(int j=s[pas-1]+1;j<=n;j++)
    ; {
        ; s[pas]=j;
        ; back(pas+1, k);
    ; }
    .formare:
    
    