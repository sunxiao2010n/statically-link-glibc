//#include <iostream>
#include <stdio.h>

int func() {
//auto f = [](){std::cout << "I'm printed from static libc\n";};
//f();
printf("%s:I'm printed from static libc\n",__FILE__);
return 1;
}
