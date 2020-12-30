
TESTS = Internal API
DEPS  = idris2_zmq network


I ?= undef

ifneq ($(I), undef)
	EXTRA_FLAGS := -o $@
else
	EXTRA_FLAGS := 
endif

$(TESTS): 
	idris2 $(EXTRA_FLAGS) $(@:%=Test%.idr) $(DEPS:%=-p % ) 
