#include <stdio.h>

int cifra_sute(int x);

int main()
{
    int s1[1000], s2[1000], n=0, i;
    int x;
    printf("Introduceti numere intregi in baza 10 (0 pentru a incheia citirea): ");
    scanf("%d", &x);
    while(x != 0)
    {
        s1[n] = x;
        s2[n] = cifra_sute(x);
        n++;
        scanf("%d", &x);
    }
    for(i=0;i<n;i++)
        printf("%d ", s2[i]);
    return 0;
}
