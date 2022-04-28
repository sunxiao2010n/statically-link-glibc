SRC_DIR=../
LIB_DIR=/usr/x86_64-linux-uclibc/usr/lib
HIGH_LIB_DIR=/usr/x86_64-linux-uclibc/usr/lib
COMPILER_DIR=/usr/lib/gcc/x86_64-linux-gnu/9/
SCRT_DIR=/usr/lib/x86_64-linux-gnu/


LINK_TARGET_BEGIN = ${SCRT_DIR}/Scrt1.o \
  ${HIGH_LIB_DIR}/crti.o \
  ${COMPILER_DIR}/crtbeginS.o

LINK_TARGET = \
  ${HIGH_LIB_DIR}/libc.a \
  ${COMPILER_DIR}/libgcc.a


LINK_TARGET_END = \
  ${COMPILER_DIR}/crtendS.o \
  ${HIGH_LIB_DIR}/crtn.o


target:
	gcc -ggdb3 -fPIC -c ${SRC_DIR}/test.c -o test.o
	gcc -ggdb3 -fPIC -c ${SRC_DIR}/func.c -o func.o
	gcc -ggdb3 -c ${SRC_DIR}/main.c -o main.o
	ar -rc test.a test.o
	ar -rc func.a func.o
	#statically link lib
	gcc -ggdb3 -v -shared -nostdlib -static-libgcc -fPIC -Wl,--whole-archive test.a -Wl,--no-whole-archive func.a ${HIGH_LIB_DIR}/libc.a -Wl,--version-script=${SRC_DIR}/test.map -o libshared.so
	#statically link target
	#gcc -v -nostdlib -static-libgcc -o run ${SRC_DIR}/main.c ${LINK_TARGET_BEGIN} -L. -lshared -Wl,-rpath,. ${LINK_TARGET} ${LINK_TARGET_END}
	#dynamic link target
	gcc -ggdb3 -v -o run ${SRC_DIR}/main.c libshared.so -Wl,-rpath=.

clean:
	rm -f *.o *.a *.so run
