
PROGRAMS  =server
LIBRARIES =zmq pthread

DONE = @echo "> Done" with $@

all: $(PROGRAMS)
	@echo === All done! ===

kernel: server
	jupyter console --kernel=i2dris-test


server: server.c server.h
	gcc $< deps/yyjson.c  -o $@  $(LIBRARIES:%= -l% )
	$(DONE)

clean:
	rm -f $(PROGRAMS)
	rm -f $(PROGRAMS:%=%.o)
	@echo ">Done with cleaning, sir!"

# $(PROGRAMS):