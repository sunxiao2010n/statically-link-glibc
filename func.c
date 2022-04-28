#include <stdio.h>
int func() { printf("%s:I'm printed from static libc\n",__FILE__); return 1; }
