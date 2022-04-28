SRC=../

target:
	gcc -ggdb3 -fPIC -c ${SRC}/test.c -o test.o
	gcc -ggdb3 -fPIC -c ${SRC}/func.c -o func.o
	ar -rc test.a test.o
	ar -rc func.a func.o
	#statically link lib
	gcc -shared -nostdlib -static-libgcc -fPIC -Wl,--whole-archive test.a -Wl,--no-whole-archive func.a -Wl,--version-script=${SRC}/test.map -o libshared.so
	#statically link target
	gcc -o run ${SRC}/main.c libshared.so -Wl,-rpath=.

clean:
	rm run *.o *.so *.a -f
