
CFLAGS := -fPIC
OS := $(shell uname)

all: plugin main

ifeq ($(OS), Linux)
DYN_EXPORT := -Wl,--export-dynamic
LIBS := -ldl
START_GROUP := -Wl,--whole-archive -Wl,--start-group
END_GROUP := -Wl,--end-group -Wl,--no-whole-archive
endif

ifeq ($(OS), Darwin)
DYN_EXPORT := -Wl,-export_dynamic 
START_GROUP := -Wl,-all_load
END_GROUP := -Wl,-noall_load
endif

clean:
	$(RM) -f *.o *.a main plugin

plugin: plugin.o
	$(CC) $(CFLAGS) -Wl,-undefined -Wl,dynamic_lookup -shared -o $@ $< 

lib.a: lib.o
	$(AR) crsT lib.a lib.o

lib_base.a: lib_base.o
	$(AR) crsT lib_base.a lib_base.o
	
main: main.o lib.a lib_base.a
	$(CC) $(CFLAGS) -o $@ main.o $(DYN_EXPORT) $(LIBS) $(START_GROUP) lib.a lib_base.a $(END_GROUP)
	
.c.o:
	$(CC) -c $(CFLAGS) -o $@ $<