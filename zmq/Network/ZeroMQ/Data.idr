module Network.ZeroMQ.Data

import Network.Socket.Data 

public export
data SocketType = ZMQ_CLIENT
                | ZMQ_PAIR 
                | ZMQ_PUB 
                | ZMQ_SUB 
                | ZMQ_REQ 
                | ZMQ_REP 
                | ZMQ_DEALER 
                | ZMQ_ROUTER 
                | ZMQ_PULL 
                | ZMQ_PUSH 
                | ZMQ_XPUB 
                | ZMQ_XSUB 
                | ZMQ_STREAM 



export
ToCode Network.ZeroMQ.Data.SocketType where
    toCode ZMQ_PAIR   = 0
    toCode ZMQ_PUB    = 1
    toCode ZMQ_SUB    = 2
    toCode ZMQ_REQ    = 3
    toCode ZMQ_REP    = 4
    toCode ZMQ_DEALER = 5
    toCode ZMQ_ROUTER = 6
    toCode ZMQ_PULL   = 7
    toCode ZMQ_PUSH   = 8
    toCode ZMQ_XPUB   = 9
    toCode ZMQ_XSUB   = 10
    toCode ZMQ_STREAM = 11
    toCode _          = 100

