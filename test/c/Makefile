
PROGRAMS  =server client
LIBRARIES =zmq

DONE = @echo "> Done" with $@

all: $(PROGRAMS)
	@echo === All done! ===

rebuild: clean all

server: server.c
	gcc $@.c -o $@ -l$(LIBRARIES)
	$(DONE)

client: client.c
	gcc $@.c -o $@ -l$(LIBRARIES)
	$(DONE)


clean:
	rm -f $(PROGRAMS)
	rm -f $(PROGRAMS:%=%.o)
	@echo ">Done with cleaning, sir!"

# $(PROGRAMS):