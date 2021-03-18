#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

char*
fmtname(char *path)
{
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
    ;
  p++;

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p),0, DIRSIZ-strlen(p));
  return buf;
}

void find(char *path,const char *filename)
{
    int fd;
    char buf[20],*p;
    struct stat st;
    struct dirent de;

    if((fd = open(path,0)) < 0){
        //fprintf(2,"find: cannot open %s\n",path);
        return;
    }


    strcpy(buf,path);
    p = buf + strlen(buf);
    *p++ = '/';
    while(read(fd,&de,sizeof(de)) == sizeof(de)){
        if(de.inum == 0)
            continue;
        memmove(p,de.name,DIRSIZ);
        p[DIRSIZ] = 0;
        stat(buf,&st);

        if(st.type == T_DIR){
            if((strcmp(fmtname(buf),".") != 0) && (strcmp(fmtname(buf),"..") != 0)){
                //printf("buf%s,%d\n",buf,st.type);
                find(buf,filename);
            }
        }
        else {
            if(strcmp(fmtname(buf),filename) == 0)
                printf("%s\n",buf);
        }
    }

}

int main(int argc,char *argv[])
{
    if(argc < 3)
        fprintf(2,"argv error\n");

    find(argv[1],argv[2]);

    exit(0);
}
