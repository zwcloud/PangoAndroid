AR_TEST = "$(CC) -print-prog-name=ar"
#AR="/Users/guysherman/Source/toolchains/arm-android/bin/../lib/gcc/arm-linux-androideabi/4.8/../../../../arm-linux-androideabi/bin/ar"

all: cpu-features.o
	$(AR) -r -cs libcpu-features.a cpu-features.o

cpu-features.o:
	$(CC) -c cpu-features.c -o cpu-features.o
