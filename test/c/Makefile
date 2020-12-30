
PROGRAMS  =server client
LIBRARIES =zmq



all: $(PROGRAMS)
	@echo === All done! ===

rebuild: clean all

server: server.c
	gcc $@.c -o $@ -l$(LIBRARIES)
	@echo "> Done" with $@

client: client.c
	gcc $@.c -o $@ -l$(LIBRARIES)
	@echo "> Done" with $@

clean:
	rm -f $(PROGRAMS)
	rm -f $(PROGRAMS:%=%.o)
	@echo ">Done with cleaning, sir!"

# $(PROGRAMS):