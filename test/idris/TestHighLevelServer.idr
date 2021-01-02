

import Network.ZeroMQ
import Network.ZeroMQ.Data
import Network.ZeroMQ.Internal
--
import Network.Socket.Data 
--
import Data.Strings

address :  SocketAddress
address = IPv4Addr 127 0 0 1

protocol : Protocol
protocol = Tcp

port : Int
port = 5555 




main : IO ()
main = withContext $ \context => do
            putStrLn "Context Created"
            sock <- socket context ZMQ_REP
            putStrLn "Socket Created"
            rc <- bind sock protocol address port
            when (not rc) $ putStrLn "Oh no, an error has occured in binding."
            maybe_messages <- recvMany sock []
            case maybe_messages of
                Left  error   => putStrLn "Oh no, an error has occured in reception!"
                Right message => putStrLn $ "Client says:" ++ (fastConcat message)
            sendMany sock ["I have ", "received your beautiful message"] []
            close sock
            putStrLn "Socket Closed"

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


