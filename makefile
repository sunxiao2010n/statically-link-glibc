LIB_DIR=/root/glibc-2.17-install/lib
HIGH_LIB_DIR=/root/glibc-2.17-install/lib
COMPILER_DIR=/usr/lib/gcc/x86_64-redhat-linux/4.8.2

LINK_LIBS_BEGIN = \
  ${HIGH_LIB_DIR}/Scrt1.o \
  ${LIB_DIR}/crti.o \
  ${COMPILER_DIR}/crtbeginS.o

LINK_LIBS = -Wl,-rpath,${COMPILER_DIR} \
  -Wl,-rpath,${LIB_DIR} \
  ${LIB_DIR}/libc.a \
  ${LIB_DIR}/libdl.a \
  ${LIB_DIR}/librt.a

LINK_LIBS_END = \
  ${COMPILER_DIR}/crtendS.o \
  ${LIB_DIR}/crtn.o \



LINK_TARGET_BEGIN = ${HIGH_LIB_DIR}/Scrt1.o \
  ${HIGH_LIB_DIR}/crti.o \
  ${COMPILER_DIR}/crtbeginS.o

LINK_TARGET = \
  -L${HIGH_LIB_DIR} \
  -Wl,-rpath,${HIGH_LIB_DIR} \
  ${HIGH_LIB_DIR}/libpthread.a \
  ${HIGH_LIB_DIR}/libm.a \
  ${HIGH_LIB_DIR}/libc.a \
  ${HIGH_LIB_DIR}/libdl.a \
  -lstdc++ \
  -lgcc_s -lgcc \
  -static-libgcc

LINK_TARGET_END = \
  ${COMPILER_DIR}/crtendS.o \
  ${HIGH_LIB_DIR}/crtn.o

LINK_STDCPP = \
  ${COMPILER_DIR}/libstdc++.a \
  -lgcc_s -lgcc

target:
	gcc -fPIC -c test.c -o test.o
	g++ -fPIC -c func.c -o func.o
	gcc -c main.c -o main.o
	ar -rc test.a test.o
	ar -rc func.a func.o
	#statically link libc
	g++ -v -shared -nostdlib -static-libgcc -fPIC -Wl,--whole-archive test.a -Wl,--no-whole-archive func.a -Wl,--version-script=./test.map -o libshared.so
	gcc -v -nostdlib -static-libgcc -o run main.c ${LINK_TARGET_BEGIN} -L. -lshared -Wl,-rpath,. ${HIGH_LIB_DIR}/libc.a ${LINK_TARGET_END}

cpp:
	gcc -fPIE -c test.c -o test.o
	g++ -fPIE -std=c++11 -c func.cpp -o func.o
	gcc -c main.c -o main.o
	ar -rc test.a test.o
	ar -rc func.a func.o
	#statically link libc
	#yum install -y libstdc++-static
	g++ -v -shared -nostdlib -static-libgcc -fPIC -Wl,--whole-archive test.a -Wl,--no-whole-archive ${LINK_LIBS_BEGIN} func.a ${LINK_STDCPP} ${LINK_LIBS_END} -Wl,--version-script=./test.map -o libshared.so
	#g++ -v -shared -nostdlib -static-libgcc -fPIC -Wl,--whole-archive test.a -Wl,--no-whole-archive func.a ${LINK_STDCPP} -Wl,--version-script=./test.map -o libshared.so
	#link run
	#g++ -v -nostdlib -static-libgcc -o run main.cpp ${LINK_TARGET_BEGIN} -L. -lshared -Wl,-rpath,. ${HIGH_LIB_DIR}/libc.a ${LINK_TARGET_END}

clean:
	rm -f *.o *.a *.so run
