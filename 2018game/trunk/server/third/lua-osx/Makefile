.PHONY : all win clean

CFLAGS=-I /opt/skynet/3rd/lua -std=gnu99 -fPIC
LDFLAGS=
CC_ROOT=../../

OS := $(shell uname)
ifeq ($(OS),Darwin)
# Run MacOS commands 
SHARED = -bundle -undefined dynamic_lookup
else
SHARED = -shared
endif

all : osx.so

osx.so : osx.c
	env gcc -O2 -Wall $(SHARED) $(CFLAGS) $(LDFLAGS) -o $@ $^

clean :
	rm -f osx.so osx.dll

install :
	chmod +x osx.so
	cp osx.so $(CC_ROOT)luaclib
