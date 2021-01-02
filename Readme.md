Idris 2 bindings to libzmq
===========================

This package provides minimal Idris 2 bindings to the C library [libzmq](http://api.zeromq.org/), which is an API for ZeroMQ sockets.

# Build & Install

Set your Idris directory (e.g. ``~/.idris2/idris2-0.2.1/``) in the file ``config.mk``, then run:

```bash
make all
```
# Use

Build your code against the package, using ``-p`` flag:

```bash
idris2 my_divine_code -p zmq
```
