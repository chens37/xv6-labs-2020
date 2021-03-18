#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"


int main(int argc,char *argv[])
{
    char fbyte;
    char cbyte;
    int ftoc[2];
    int ctof[2];

    pipe(ftoc);
    pipe(ctof);
     
    if(fork() == 0) {
        close(ftoc[1]);
        close(ctof[0]);

        read(ftoc[0],&cbyte,1);

        printf("%d: received ping\n",getpid());
        write(ctof[1],&cbyte,1);

        close(ftoc[0]);
        close(ctof[1]);

        exit(0);
    }else {
        close(ftoc[0]);
        close(ctof[1]);
        fbyte = 0xa;
        write(ftoc[1],&fbyte,1);
        
        read(ctof[0],&cbyte,1);
        printf("%d: received pong\n",getpid());

        close(ftoc[1]);
        close(ctof[0]);
    }

    wait(0);
    exit(0);
}
