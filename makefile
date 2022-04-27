#LIB_DIR=/home/sunxiao/statically-link/musl/lib
LIB_DIR=/usr/x86_64-linux-uclibc/usr/lib
#HIGH_LIB_DIR=/home/sunxiao/statically-link/musl/lib
HIGH_LIB_DIR=/usr/x86_64-linux-uclibc/usr/lib
COMPILER_DIR=/usr/lib/gcc/x86_64-linux-gnu/9/
#COMPILER_DIR=/usr/lib/gcc/x86_64-redhat-linux/4.8.5/
SCRT_DIR=/usr/lib/x86_64-linux-gnu/

LINK_LIBS_BEGIN = \
  ${SCRT_DIR}/Scrt1.o \
  ${LIB_DIR}/crti.o \
  ${COMPILER_DIR}/crtbeginS.o \

LINK_LIBS = \
  ${LIB_DIR}/libc.a \
  ${LIB_DIR}/libdl.a \
  ${LIB_DIR}/librt.a

LINK_LIBS_END = \
  ${COMPILER_DIR}/crtendS.o \
  ${LIB_DIR}/crtn.o \

LINK_TARGET_BEGIN = ${SCRT_DIR}/Scrt1.o \
  ${HIGH_LIB_DIR}/crti.o \
  ${COMPILER_DIR}/crtbeginS.o

LINK_TARGET = \
  ${HIGH_LIB_DIR}/libpthread.a \
  ${HIGH_LIB_DIR}/libm.a \
  ${HIGH_LIB_DIR}/libc.a \
  ${HIGH_LIB_DIR}/libdl.a \
  ${COMPILER_DIR}/libgcc.a


###################
#  -lstdc++ \
#  -lgcc_s -lgcc \
#  -static-libgcc
##################


LINK_TARGET_END = \
  ${COMPILER_DIR}/crtendS.o \
  ${HIGH_LIB_DIR}/crtn.o

LINK_STDCPP = \
  ${COMPILER_DIR}/libstdc++.a \
  ${COMPILER_DIR}/libgcc.a \
  ${COMPILER_DIR}/libgcc_eh.a \
  ${HIGH_LIB_DIR}/libc.a

target:
	gcc -ggdb3 -fPIC -c test.c -o test.o
	gcc -ggdb3 -fPIC -c func.c -o func.o
	gcc -ggdb3 -c main.c -o main.o
	ar -rc test.a test.o
	ar -rc func.a func.o
	#statically link lib
	gcc -ggdb3 -v -shared -nostdlib -static-libgcc -fPIC -Wl,--whole-archive test.a -Wl,--no-whole-archive func.a -Wl,--version-script=./test.map -o libshared.so
	#statically link target
	#gcc -v -nostdlib -static-libgcc -o run main.c ${LINK_TARGET_BEGIN} -L. -lshared -Wl,-rpath,. ${HIGH_LIB_DIR}/libc.a ${LINK_TARGET_END}
	#dynamic link target
	gcc -ggdb3 -v -o run main.c libshared.so -Wl,-rpath=.

cpp:
	gcc -mabi=sysv -ggdb3 -fPIE -fPIC -c test.c -o test.o
	g++ -mabi=sysv -ggdb3 -fPIE -fPIC -std=c++11 -c func.cpp -o func.o
	gcc -mabi=sysv -fPIE -fPIC -c main.c -o main.o
	ar -rc test.a test.o
	ar -rc func.a func.o
	#statically link libc
	#yum install -y libstdc++-static
	 #-nostartfiles -nodefaultlibs -nolibc
	 #-Wl,-z,muldefs
	gcc -mabi=sysv -nostdlib -v -ggdb3 -shared -static-libgcc -static-libstdc++ -fPIC -Wl,--whole-archive test.a -Wl,--no-whole-archive ${LINK_LIBS_BEGIN} func.a ${LINK_STDCPP} ${LINK_LIBS_END} -Wl,--version-script=./test.map -o libshared.so
	#link
	#gcc -mabi=sysv -nostartfiles -nodefaultlibs -nostdlib -static-libstdc++ -static-libgcc -v -ggdb3 -o run ${LINK_TARGET_BEGIN} main.o -L. -lshared -Wl,-rpath,. ${HIGH_LIB_DIR}/libc.a ${LINK_TARGET_END}
	#dynamic link
	gcc -v -ggdb3 -o run main.cpp libshared.so -Wl,-rpath=.
clean:
	rm -f *.o *.a *.so run
