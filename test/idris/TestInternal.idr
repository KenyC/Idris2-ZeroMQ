
import Network.ZeroMQ
import Network.ZeroMQ.Data
import Network.ZeroMQ.Internal



main : IO ()
main = do
    ctx  <- primIO $ prim__idris_zmq_ctx_new
    -- withContext $ \context => do
    putStrLn "Context Created"
    sock <- primIO $ prim__idris_zmq_socket ctx 4
    putStrLn "Socket Created"


    rc <- primIO $ prim__idris_zmq_connect sock "tcp" "127.0.0.1" 5556
    if rc /= 0
        then putStrLn "Something went wrong!"
        else 
            do
                primIO $ prim__idris_zmq_close sock
                putStrLn "Socket Closed"
                primIO $ prim__idris_zmq_ctx_destroy ctx
                putStrLn "Context Destroyed"
    -- pure ()


    