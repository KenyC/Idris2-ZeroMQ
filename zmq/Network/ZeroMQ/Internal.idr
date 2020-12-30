module Network.ZeroMQ.Internal



public export
ZMQCtx : Type
ZMQCtx = AnyPtr

public export
ZMQSock : Type
ZMQSock = AnyPtr

public export
ZMQRecvRep : Type
ZMQRecvRep = AnyPtr

export
%foreign "C:idris_zmq_socket,libidris2_zmq"
prim__idris_zmq_socket : ZMQCtx -> Int -> PrimIO ZMQSock

export
%foreign "C:idris_zmq_close,libidris2_zmq"
prim__idris_zmq_close : ZMQSock -> PrimIO ()

export
%foreign "C:idris_zmq_ctx_new,libidris2_zmq"
prim__idris_zmq_ctx_new : PrimIO ZMQCtx

export
%foreign "C:idris_zmq_ctx_destroy,libidris2_zmq"
prim__idris_zmq_ctx_destroy : ZMQCtx -> PrimIO ()

export
%foreign "C:idris_zmq_bind,libidris2_zmq"
prim__idris_zmq_bind : ZMQSock -> String -> String -> Int -> PrimIO Int

export
%foreign "C:idris_zmq_connect,libidris2_zmq"
prim__idris_zmq_connect : ZMQSock -> String -> String -> Int -> PrimIO Int
-- int    idris_zmq_connect     (void* socket, char* protocol, char* hostname, int port);



-- int   idris_get_result_code  (void* recv_result);
-- char* idris_get_payload      (void* recv_result);
-- void  idris_free_recv_struct (void* res_struct);

-- int    idris_zmq_send        (void* socket, char* message, int flags);
-- void*  idris_zmq_recv        (void* socket, int flags);
