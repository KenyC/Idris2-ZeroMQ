
import Network.ZeroMQ
import Network.ZeroMQ.Data
import Network.ZeroMQ.Internal
import Network.Socket.Data 

address :  SocketAddress
address = IPv4Addr 127 0 0 1

protocol : Protocol
protocol = Tcp

port : Int
port = 5555 




main : IO ()
main = withContext $ \context => do
            putStrLn "Context Created"
            sock <- socket context ZMQ_REQ
            putStrLn "Socket Created"
            rc <- connect sock protocol address port
            when (not rc) $ putStrLn "Ohoh"
            send sock "Some tremendously interesting message" 0
            maybe_message <- recv sock 0
            case maybe_message of
                Left  error   => putStrLn "That is a problem"
                Right message => putStrLn $ "Server says:" ++ message
            putStrLn "Socket Connected"
            close sock

        -- if rc /= 0
        --     then putStrLn "Something went wrong!"
        --     else 
        --         do
        --             putStrLn "BHDT"
        --             code <- primIO $ prim__idris_zmq_send sock "A brave new message" 0
        --             putStrLn "Sent Something"
        --             if code /= 0 
        --                 then putStrLn "Something went wrong!"
        --                 else
        --                     do
        --                         recv_result <- primIO $ prim__idris_zmq_recv sock 0
        --                         code <- primIO $ prim__idris_get_result_code recv_result
        --                         putStrLn "Received Something"
        --                         if code /= 0 
        --                             then putStrLn "Something went wrong!"
        --                             else
        --                                 do
        --                                     payload <- primIO $ prim__idris_get_payload recv_result
        --                                     putStrLn payload
        --                                     primIO $ prim__idris_zmq_close sock
        --                                     putStrLn "Socket Closed"
        --                                     primIO $ prim__idris_zmq_ctx_destroy ctx
        --                                     putStrLn "Context Destroyed"

--     -- pure ()


