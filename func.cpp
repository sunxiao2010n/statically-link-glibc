#include <iostream>

extern "C" int func() {
auto f = [](){std::cout << "statically link cpp 11 \n";};
f();
return 1;
}
