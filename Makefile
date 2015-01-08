
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
	$(CXX) $(CFLAGS) -Wl,-undefined -Wl,dynamic_lookup -shared -o $@ $< 

.o.a:
	$(AR) crsT $@ $<

main: main.o lib.a lib_base.a
	$(CXX) $(CFLAGS) -o $@ main.o $(DYN_EXPORT) $(LIBS) $(START_GROUP) lib.a lib_base.a $(END_GROUP)
	
.cc.o:
	$(CXX) -c $(CFLAGS) -o $@ $<