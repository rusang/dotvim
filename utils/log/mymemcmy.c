#include <stdio.h>
#include <assert.h>
#include <string.h>


void *mymemcmy(void *v_dst, const void *v_src, int c)
{
    assert(v_dst);
    assert(v_src);
    const char*src = v_src;
    char *dst = v_dst;
    if (v_dst <= v_src) 
    {
        while (c--) 
        {
            *dst++ = *src++;
        }
    }
    else
    {
        src = src + c -1;
        dst = dst + c -1;
        while (c--) 
        {
            *dst-- = *src--;
        }
    }
    return v_dst;
}

int main(void)
{
    char p1[] = "0123456789abcdef1";
    char p2[] = "123";
    printf("length of p1 = %d\n", strlen(p1));
    printf("p1 = %p\np2 = %p\n", p1, p2);
    mymemcmy(p2, p1,strlen(p1));
    printf("%s\n%s\n",p1,p2);
    return 0;
}
