
TESTS = Internal HighLevelClient HighLevelServer
DEPS  = zmq network


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
	@echo "> All done!"
	@$(RUN_CMD)