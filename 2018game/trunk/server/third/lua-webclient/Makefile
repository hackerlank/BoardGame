.PHONY : all win clean

CFLAGS=`pkg-config --cflags libcurl` -I /opt/skynet/3rd/lua -std=gnu99 -fPIC
LDFLAGS=`pkg-config --libs libcurl`
CC_ROOT=../../

OS := $(shell uname)
ifeq ($(OS),Darwin)
# Run MacOS commands 
SHARED =     -bundle -undefined dynamic_lookup
else
SHARED = 	 -shared
endif

all : webclient.so

webclient.so : webclient.c
	env gcc -O2 -Wall $(SHARED) $(CFLAGS) $(LDFLAGS) -o $@ $^

clean :
	rm -f webclient.so webclient.dll

install :
	chmod +x webclient.so
	cp webclient.so $(CC_ROOT)luaclib
	cp webclient.lua $(CC_ROOT)service
