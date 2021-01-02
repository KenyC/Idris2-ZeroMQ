module Network.ZeroMQ.Data

import Network.Socket.Data 

public export
interface FromCode a where
  fromCode : Int -> Maybe a

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

public export 
data ZMQError = ENOTSUP 
              | EPROTONOSUPPORT 
              | ENOBUFS 
              | ENETDOWN 
              | EADDRINUSE 
              | EADDRNOTAVAIL 
              | ECONNREFUSED 
              | EINPROGRESS 
              | ENOTSOCK 
              | EMSGSIZE 
              | EAFNOSUPPORT 
              | ENETUNREACH 
              | ECONNABORTED 
              | ECONNRESET 
              | ENOTCONN 
              | ETIMEDOUT 
              | EHOSTUNREACH 
              | ENETRESET 
              | EFSM 
              | ENOCOMPATPROTO 
              | ETERM 
              | EMTHREAD 




public export 
data Protocol = Tcp
              | Ipc
              | Inproc
              | Pgm
              | Vmci

export
Show Protocol where
    show Tcp    = "tcp"
    show Ipc    = "ipc"
    show Inproc = "inproc"
    show Pgm    = "pgm"
    show Vmci   = "vmci"

public export 
data Flag  = ZMQ_DontWait
           | ZMQ_SndMore

public export
Flags : Type
Flags = List Flag

-- export 
-- FromCode Flags where
--     fromCode = Just . id

export 
ToCode Flag where
    toCode ZMQ_DontWait = 1
    toCode ZMQ_SndMore  = 2



bitwise_or : Int -> Int -> Int
bitwise_or 0 y = y
bitwise_or x 0 = x
bitwise_or x y = (max x_mod_2 y_mod_2) + 2 * bitwise_or (x_div_2) (y_div_2)
                 where
                      x_mod_2 : Int
                      x_mod_2 = x `mod` 2 
                      y_mod_2 : Int
                      y_mod_2 = y `mod` 2 
                      x_div_2 : Int
                      x_div_2 = x `div` 2 
                      y_div_2 : Int
                      y_div_2 = y `div` 2 


export 
ToCode Flags where
    toCode = (foldr bitwise_or 0) . (map toCode)



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

zmqHausNumber : Int
zmqHausNumber = 156384712

export
ToCode ZMQError where
    toCode ENOTSUP         = (zmqHausNumber + 1)
    toCode EPROTONOSUPPORT = (zmqHausNumber + 2)
    toCode ENOBUFS         = (zmqHausNumber + 3)
    toCode ENETDOWN        = (zmqHausNumber + 4)
    toCode EADDRINUSE      = (zmqHausNumber + 5)
    toCode EADDRNOTAVAIL   = (zmqHausNumber + 6)
    toCode ECONNREFUSED    = (zmqHausNumber + 7)
    toCode EINPROGRESS     = (zmqHausNumber + 8)
    toCode ENOTSOCK        = (zmqHausNumber + 9)
    toCode EMSGSIZE        = (zmqHausNumber + 10)
    toCode EAFNOSUPPORT    = (zmqHausNumber + 11)
    toCode ENETUNREACH     = (zmqHausNumber + 12)
    toCode ECONNABORTED    = (zmqHausNumber + 13)
    toCode ECONNRESET      = (zmqHausNumber + 14)
    toCode ENOTCONN        = (zmqHausNumber + 15)
    toCode ETIMEDOUT       = (zmqHausNumber + 16)
    toCode EHOSTUNREACH    = (zmqHausNumber + 17)
    toCode ENETRESET       = (zmqHausNumber + 18)
    toCode EFSM            = (zmqHausNumber + 51)
    toCode ENOCOMPATPROTO  = (zmqHausNumber + 52)
    toCode ETERM           = (zmqHausNumber + 53)
    toCode EMTHREAD        = (zmqHausNumber + 54)
    toCode _               = 0

export
FromCode ZMQError where
    fromCode 156384713 = Just ENOTSUP
    fromCode 156384714 = Just EPROTONOSUPPORT
    fromCode 156384715 = Just ENOBUFS
    fromCode 156384716 = Just ENETDOWN
    fromCode 156384717 = Just EADDRINUSE
    fromCode 156384718 = Just EADDRNOTAVAIL
    fromCode 156384719 = Just ECONNREFUSED
    fromCode 156384720 = Just EINPROGRESS
    fromCode 156384721 = Just ENOTSOCK
    fromCode 156384722 = Just EMSGSIZE
    fromCode 156384723 = Just EAFNOSUPPORT
    fromCode 156384724 = Just ENETUNREACH
    fromCode 156384725 = Just ECONNABORTED
    fromCode 156384726 = Just ECONNRESET
    fromCode 156384727 = Just ENOTCONN
    fromCode 156384728 = Just ETIMEDOUT
    fromCode 156384729 = Just EHOSTUNREACH
    fromCode 156384730 = Just ENETRESET
    fromCode 156384763 = Just EFSM
    fromCode 156384764 = Just ENOCOMPATPROTO
    fromCode 156384765 = Just ETERM
    fromCode 156384766 = Just EMTHREAD
    fromCode _ = Nothing
