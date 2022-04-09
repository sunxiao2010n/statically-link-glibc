//#include <iostream>
#include <stdio.h>

extern "C" int func() {
//auto f = [](){std::cout << "I'm printed from static libc\n";};
//f();
printf("I'm printed from static libc\n");
return 1;
}
