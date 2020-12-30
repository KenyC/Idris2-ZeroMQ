
FLAGS = -shared -fPIC
GCC   = gcc
BASENAME = idris_zeromq
LIBNAME  = libidris2_zmq
SO_FILE  = $(LIBNAME).so

C_FILES  = $(BASENAME:%=%.c)
H_FILES  = $(BASENAME:%=%.h)



DESTINATION_LIB = ~/.idris2/idris2-0.2.1/lib/

all: $(SO_FILE)
	cp $(SO_FILE) $(DESTINATION_LIB)
	@echo "> Done!"

# .PRECIOUS: libidris2_zmq.so

$(SO_FILE): $(C_FILES) $(H_FILES)
	$(GCC) $(FLAGS) $(C_FILES) -o $@ -l zmq

rebuild: clean all

test: build/test
	$<


build/test: idris_zeromq.c idris_zeromq.h
	mkdir -p build
	$(GCC) $(C_FILES) $(@:build/test%=test%.c) -o $@ -l zmq

clean:
	rm -f $(SO_FILE)
	rm -rf build/
	@echo "> All clean!"


