module Network.ZeroMQ

import Network.ZeroMQ.Internal
import Network.ZeroMQ.Data
import Network.Socket.Data 

export
record Context where
    constructor MkContext
    ctx : ZMQCtx



{- 
This is unsafe: an Exception raised by ErrorT IO will not trigger the context to be destroyed
-}
export
withContext : (HasIO io) => (Context -> io a) -> io a
withContext continuation = do
    context_ <- primIO $ prim__idris_zmq_ctx_new
    let context = MkContext context_
    result  <- continuation context
    primIO $ prim__idris_zmq_ctx_destroy $ ctx context
    pure result


export
record Network.ZeroMQ.Socket where
    constructor MkSocket
    sock : ZMQSock

export
socket : (HasIO io) => Context -> Network.ZeroMQ.Data.SocketType -> io Network.ZeroMQ.Socket
socket context type = do
    s <- primIO $ prim__idris_zmq_socket (ctx context) (toCode type)
    pure $ Network.ZeroMQ.MkSocket s

export
close : (HasIO io) => Network.ZeroMQ.Socket -> io () 
close = primIO . prim__idris_zmq_close . sock
