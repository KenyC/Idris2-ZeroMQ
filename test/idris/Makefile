
TESTS = Internal HighLevel
DEPS  = idris2_zmq network


I ?= undef

ifneq ($(I), undef)
	EXTRA_FLAGS = 
	RUN_CMD     = @echo 
else
	EXTRA_FLAGS = -o $@
	RUN_CMD     = build/exec/$@ 
endif

$(TESTS): 
	idris2 $(@:%=Test%.idr) $(EXTRA_FLAGS)  $(DEPS:%=-p % )
	$(RUN_CMD)