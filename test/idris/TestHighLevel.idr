
import Network.ZeroMQ
import Network.ZeroMQ.Data
import Network.ZeroMQ.Internal



main : IO ()
main = do
    ctx  <- primIO $ prim__idris_zmq_ctx_new
    -- withContext $ \context => do
    putStrLn "Context Created"
    sock <- primIO $ prim__idris_zmq_socket ctx 3
    putStrLn "Socket Created"


    rc <- primIO $ prim__idris_zmq_connect sock "tcp" "127.0.0.1" 5555
    if rc /= 0
        then putStrLn "Something went wrong!"
        else 
            do
                putStrLn "BHDT"
                code <- primIO $ prim__idris_zmq_send sock "A brave new message" 0
                putStrLn "Sent Something"
                if code /= 0 
                    then putStrLn "Something went wrong!"
                    else
                        do
                            recv_result <- primIO $ prim__idris_zmq_recv sock 0
                            code <- primIO $ prim__idris_get_result_code recv_result
                            putStrLn "Received Something"
                            if code /= 0 
                                then putStrLn "Something went wrong!"
                                else
                                    do
                                        payload <- primIO $ prim__idris_get_payload recv_result
                                        putStrLn payload
                                        primIO $ prim__idris_zmq_close sock
                                        putStrLn "Socket Closed"
                                        primIO $ prim__idris_zmq_ctx_destroy ctx
                                        putStrLn "Context Destroyed"

    -- pure ()


