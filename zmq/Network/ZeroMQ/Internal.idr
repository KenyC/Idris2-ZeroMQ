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

export
%foreign "C:idris_zmq_send,libidris2_zmq"
prim__idris_zmq_send : ZMQSock -> String -> Int -> PrimIO Int

export
%foreign "C:idris_zmq_recv,libidris2_zmq"
prim__idris_zmq_recv : ZMQSock -> Int -> PrimIO ZMQRecvRep

export
%foreign "C:idris_get_result_code,libidris2_zmq"
prim__idris_get_result_code : ZMQRecvRep -> PrimIO Int

export
%foreign "C:idris_get_payload,libidris2_zmq"
prim__idris_get_payload : ZMQRecvRep -> PrimIO String

export
%foreign "C:idris_free_recv_struct,libidris2_zmq"
prim__idris_free_recv_struct : ZMQRecvRep -> PrimIO ()





