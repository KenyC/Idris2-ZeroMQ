PACKAGE = zmq
IDRIS2  = idris2
RM      = rm

all:
	${IDRIS2} --build   $(PACKAGE).ipkg

install:
	${IDRIS2} --install $(PACKAGE).ipkg

clean:
	$(RM) -r build
