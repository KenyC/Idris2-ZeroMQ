

all: c_lib idris_package
	@echo ">>>>>>>>>>>>>>>>>>>>>>>> All done!"

c_lib:
	make -C foreign/ all
	@echo ">>>>>>>>>>>>>>>>>>>>>>>> C library built!"

idris_package:
	make -C zmq/
	@echo ">>>>>>>>>>>>>>>>>>>>>>>> Idris package built!"
	make -C zmq/ install
	@echo ">>>>>>>>>>>>>>>>>>>>>>>> Idris package installed!"