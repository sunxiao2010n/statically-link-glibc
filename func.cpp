#include <iostream>

extern "C" int func() {
auto f = [](){std::cout << "cpp printed from static libc\n";};
f();
return 1;
}
