module Network.ZeroMQ

import Network.Socket.Data 
--
import Control.Monad.Either

import Network.ZeroMQ.Internal
import Network.ZeroMQ.Data


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


export
connect : (HasIO io) 
       => Network.ZeroMQ.Socket 
       -> Protocol
       -> SocketAddress
       -> Port
       -> io Bool
connect socket protocol adress port = do
    return_code <- primIO $ prim__idris_zmq_connect (sock socket) (show protocol) (show adress) port
    pure $ return_code == 0

export
bind : (HasIO io) 
       => Network.ZeroMQ.Socket 
       -> Protocol
       -> SocketAddress
       -> Port
       -> io Bool
bind socket protocol adress port = do
    return_code <- primIO $ prim__idris_zmq_bind (sock socket) (show protocol) (show adress) port
    pure $ return_code == 0

export
send : (HasIO io) 
   =>  Network.ZeroMQ.Socket 
   ->  String 
   ->  Flags 
   ->  io (Either ZMQError ())
send socket message flags = do 
    return_code <- primIO $ prim__idris_zmq_send (sock socket) message (toCode flags)
    if return_code == 0
        then pure $ Right ()
        else case (fromCode {a=ZMQError} return_code) of
            Just error => pure $ Left error
            Nothing    => pure $ Right ()

export
recv : (HasIO io) 
   =>  Network.ZeroMQ.Socket 
   ->  Flags 
   ->  io (Either ZMQError String)
recv socket flags = do 
    recv_response <- primIO $ prim__idris_zmq_recv (sock socket) (toCode flags)
    return_code   <- primIO $ prim__idris_get_result_code recv_response

    case (fromCode {a=ZMQError} return_code) of
        Just error => do 
            primIO $ prim__idris_free_recv_struct recv_response
            pure $ Left error
        Nothing    => do
            payload <- primIO $ prim__idris_get_payload recv_response
            primIO $ prim__idris_free_recv_struct recv_response
            pure $ Right payload


export
moreToReceive : (HasIO io) => Network.ZeroMQ.Socket -> io Bool
moreToReceive socket = do
  result <- primIO $ prim__idris_more_to_receive $ sock socket
  pure $ result /= 0


export
recvMany : (HasIO io) 
        => Network.ZeroMQ.Socket 
        -> Flags 
        -> io (Either ZMQError (List String))
recvMany socket flags = runEitherT {m=io} $ do
                          firstPart <- MkEitherT $ recv socket flags  
                          more      <- moreToReceive socket

                          if more
                            then do
                                (firstPart::) <$> (MkEitherT $ recvMany socket flags)
                            else pure $ [firstPart]  
export
sendMany : (HasIO io) 
        => Network.ZeroMQ.Socket 
        -> List String 
        -> Flags
        -> io (Either ZMQError ())

sendMany socket []                 flags = pure $ Right ()
sendMany socket [message]          flags = send socket message flags
sendMany socket (message::strings) flags = runEitherT {m=io} $ do
                                                firstPart <- MkEitherT $ send socket message $ ZMQ_SndMore :: flags 
                                                MkEitherT $ sendMany socket strings flags
-- sendMany socket (message::(mesage2::strings)) flags = send socket message flags