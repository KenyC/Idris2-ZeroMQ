#!/usr/bin/chezscheme9.5 --script

; @generated
(import (chezscheme))
(case (machine-type)
  [(i3le ti3le a6le ta6le) (load-shared-object "libc.so.6")]
  [(i3osx ti3osx a6osx ta6osx) (load-shared-object "libc.dylib")]
  [(i3nt ti3nt a6nt ta6nt) (load-shared-object "msvcrt.dll")                           (load-shared-object "ws2_32.dll")]
  [else (load-shared-object "libc.so")])



(let ()
(define (blodwen-os)
  (case (machine-type)
    [(i3le ti3le a6le ta6le) "unix"]  ; GNU/Linux
    [(i3ob ti3ob a6ob ta6ob) "unix"]  ; OpenBSD
    [(i3fb ti3fb a6fb ta6fb) "unix"]  ; FreeBSD
    [(i3nb ti3nb a6nb ta6nb) "unix"]  ; NetBSD
    [(i3osx ti3osx a6osx ta6osx) "darwin"]
    [(i3nt ti3nt a6nt ta6nt) "windows"]
    [else "unknown"]))

(define blodwen-read-args (lambda (desc)
  (case (vector-ref desc 0)
    ((0) '())
    ((1) (cons (vector-ref desc 2)
               (blodwen-read-args (vector-ref desc 3)))))))
(define b+ (lambda (x y bits) (remainder (+ x y) (ash 1 bits))))
(define b- (lambda (x y bits) (remainder (- x y) (ash 1 bits))))
(define b* (lambda (x y bits) (remainder (* x y) (ash 1 bits))))
(define b/ (lambda (x y bits) (remainder (exact-floor (/ x y)) (ash 1 bits))))

(define integer->bits8 (lambda (x) (modulo x (expt 2 8))))
(define integer->bits16 (lambda (x) (modulo x (expt 2 16))))
(define integer->bits32 (lambda (x) (modulo x (expt 2 32))))
(define integer->bits64 (lambda (x) (modulo x (expt 2 64))))

(define bits16->bits8 (lambda (x) (modulo x (expt 2 8))))
(define bits32->bits8 (lambda (x) (modulo x (expt 2 8))))
(define bits32->bits16 (lambda (x) (modulo x (expt 2 16))))
(define bits64->bits8 (lambda (x) (modulo x (expt 2 8))))
(define bits64->bits16 (lambda (x) (modulo x (expt 2 16))))
(define bits64->bits32 (lambda (x) (modulo x (expt 2 32))))

(define blodwen-bits-shl (lambda (x y bits) (remainder (ash x y) (ash 1 bits))))
(define blodwen-shl (lambda (x y) (ash x y)))
(define blodwen-shr (lambda (x y) (ash x (- y))))
(define blodwen-and (lambda (x y) (logand x y)))
(define blodwen-or (lambda (x y) (logor x y)))
(define blodwen-xor (lambda (x y) (logxor x y)))

(define cast-num
  (lambda (x)
    (if (number? x) x 0)))
(define destroy-prefix
  (lambda (x)
    (cond
      ((equal? x "") "")
      ((equal? (string-ref x 0) #\#) "")
      (else x))))
(define exact-floor
  (lambda (x)
    (inexact->exact (floor x))))
(define cast-string-int
  (lambda (x)
    (exact-floor (cast-num (string->number (destroy-prefix x))))))
(define cast-int-char
  (lambda (x)
    (if (and (>= x 0)
             (<= x #x10ffff))
        (integer->char x)
        0)))
(define cast-string-double
  (lambda (x)
    (cast-num (string->number (destroy-prefix x)))))

(define (from-idris-list xs)
  (if (= (vector-ref xs 0) 0)
    '()
    (cons (vector-ref xs 1) (from-idris-list (vector-ref xs 2)))))
(define (string-pack xs) (apply string (from-idris-list xs)))
(define (to-idris-list-rev acc xs)
  (if (null? xs)
    acc
    (to-idris-list-rev (vector 1 (car xs) acc) (cdr xs))))
(define (string-unpack s) (to-idris-list-rev (vector 0) (reverse (string->list s))))
(define (string-concat xs) (apply string-append (from-idris-list xs)))
(define string-cons (lambda (x y) (string-append (string x) y)))
(define get-tag (lambda (x) (vector-ref x 0)))
(define string-reverse (lambda (x)
  (list->string (reverse (string->list x)))))
(define (string-substr off len s)
    (let* ((l (string-length s))
          (b (max 0 off))
          (x (max 0 len))
          (end (min l (+ b x))))
          (if (> b l)
              ""
              (substring s b end))))

(define (blodwen-string-iterator-new s)
  0)

(define (blodwen-string-iterator-next s ofs)
  (if (>= ofs (string-length s))
      (vector 0)  ; EOF
      (vector 1 (string-ref s ofs) (+ ofs 1))))

(define either-left
  (lambda (x)
    (vector 0 x)))

(define either-right
  (lambda (x)
    (vector 1 x)))

(define blodwen-error-quit
  (lambda (msg)
    (display msg)
    (newline)
    (exit 1)))

(define (blodwen-get-line p)
    (if (port? p)
        (let ((str (get-line p)))
            (if (eof-object? str)
                ""
                str))
        void))

(define (blodwen-get-char p)
    (if (port? p)
        (let ((chr (get-char p)))
            (if (eof-object? chr)
                #\nul
                chr))
        void))

;; Buffers

(define (blodwen-new-buffer size)
  (make-bytevector size 0))

(define (blodwen-buffer-size buf)
  (bytevector-length buf))

(define (blodwen-buffer-setbyte buf loc val)
  (bytevector-u8-set! buf loc val))

(define (blodwen-buffer-getbyte buf loc)
  (bytevector-u8-ref buf loc))

(define (blodwen-buffer-setbits16 buf loc val)
  (bytevector-u16-set! buf loc val (native-endianness)))

(define (blodwen-buffer-getbits16 buf loc)
  (bytevector-u16-ref buf loc (native-endianness)))

(define (blodwen-buffer-setbits32 buf loc val)
  (bytevector-u32-set! buf loc val (native-endianness)))

(define (blodwen-buffer-getbits32 buf loc)
  (bytevector-u32-ref buf loc (native-endianness)))

(define (blodwen-buffer-setbits64 buf loc val)
  (bytevector-u64-set! buf loc val (native-endianness)))

(define (blodwen-buffer-getbits64 buf loc)
  (bytevector-u64-ref buf loc (native-endianness)))

(define (blodwen-buffer-setint32 buf loc val)
  (bytevector-s32-set! buf loc val (native-endianness)))

(define (blodwen-buffer-getint32 buf loc)
  (bytevector-s32-ref buf loc (native-endianness)))

(define (blodwen-buffer-setint buf loc val)
  (bytevector-s64-set! buf loc val (native-endianness)))

(define (blodwen-buffer-getint buf loc)
  (bytevector-s64-ref buf loc (native-endianness)))

(define (blodwen-buffer-setdouble buf loc val)
  (bytevector-ieee-double-set! buf loc val (native-endianness)))

(define (blodwen-buffer-getdouble buf loc)
  (bytevector-ieee-double-ref buf loc (native-endianness)))

(define (blodwen-stringbytelen str)
  (bytevector-length (string->utf8 str)))

(define (blodwen-buffer-setstring buf loc val)
  (let* [(strvec (string->utf8 val))
         (len (bytevector-length strvec))]
    (bytevector-copy! strvec 0 buf loc len)))

(define (blodwen-buffer-getstring buf loc len)
  (let [(newvec (make-bytevector len))]
    (bytevector-copy! buf loc newvec 0 len)
    (utf8->string newvec)))

(define (blodwen-buffer-copydata buf start len dest loc)
  (bytevector-copy! buf start dest loc len))

;; Threads

(define blodwen-thread-data (make-thread-parameter #f))

(define (blodwen-thread p)
    (fork-thread (lambda () (p (vector 0)))))

(define (blodwen-get-thread-data ty)
  (blodwen-thread-data))

(define (blodwen-set-thread-data a)
  (blodwen-thread-data a))

(define (blodwen-mutex) (make-mutex))
(define (blodwen-lock m) (mutex-acquire m))
(define (blodwen-unlock m) (mutex-release m))
(define (blodwen-thisthread) (get-thread-id))

(define (blodwen-condition) (make-condition))
(define (blodwen-condition-wait c m) (condition-wait c m))
(define (blodwen-condition-wait-timeout c m t)
  (let ((sec (div t 1000000))
        (micro (mod t 1000000)))
  (condition-wait c m (make-time 'time-duration (* 1000 micro) sec))))
(define (blodwen-condition-signal c) (condition-signal c))
(define (blodwen-condition-broadcast c) (condition-broadcast c))

(define-record future-internal (result ready mutex signal))
(define (blodwen-make-future work)
  (let ([future (make-future-internal #f #f (make-mutex) (make-condition))])
    (fork-thread (lambda ()
      (let ([result (work)])
        (with-mutex (future-internal-mutex future)
          (set-future-internal-result! future result)
          (set-future-internal-ready! future #t)
          (condition-broadcast (future-internal-signal future))))))
    future))
(define (blodwen-await-future ty future)
  (let ([mutex (future-internal-mutex future)])
    (with-mutex mutex
      (if (not (future-internal-ready future))
          (condition-wait (future-internal-signal future) mutex))
      (future-internal-result future))))

(define (blodwen-sleep s) (sleep (make-time 'time-duration 0 s)))
(define (blodwen-usleep s)
  (let ((sec (div s 1000000))
        (micro (mod s 1000000)))
       (sleep (make-time 'time-duration (* 1000 micro) sec))))

(define (blodwen-time) (time-second (current-time)))
(define (blodwen-clock-time-utc) (current-time 'time-utc))
(define (blodwen-clock-time-monotonic) (current-time 'time-monotonic))
(define (blodwen-clock-time-duration) (current-time 'time-duration))
(define (blodwen-clock-time-process) (current-time 'time-process))
(define (blodwen-clock-time-thread) (current-time 'time-thread))
(define (blodwen-clock-time-gccpu) (current-time 'time-collector-cpu))
(define (blodwen-clock-time-gcreal) (current-time 'time-collector-real))
(define (blodwen-is-time? clk) (if (time? clk) 1 0))
(define (blodwen-clock-second time) (time-second time))
(define (blodwen-clock-nanosecond time) (time-nanosecond time))

(define (blodwen-args)
  (define (blodwen-build-args args)
    (if (null? args)
        (vector 0) ; Prelude.List
        (vector 1 (car args) (blodwen-build-args (cdr args)))))
    (blodwen-build-args (command-line)))

(define (blodwen-hasenv var)
  (if (eq? (getenv var) #f) 0 1))

(define (blodwen-system cmd)
  (system cmd))

;; Randoms
(define random-seed-register 0)
(define (initialize-random-seed-once)
  (if (= (virtual-register random-seed-register) 0)
      (let ([seed (time-nanosecond (current-time))])
        (set-virtual-register! random-seed-register seed)
        (random-seed seed))))

(define (blodwen-random-seed seed)
  (set-virtual-register! random-seed-register seed)
  (random-seed seed))
(define blodwen-random
  (case-lambda
    ;; no argument, pick a real value from [0, 1.0)
    [() (begin
          (initialize-random-seed-once)
          (random 1.0))]
    ;; single argument k, pick an integral value from [0, k)
    [(k)
      (begin
        (initialize-random-seed-once)
        (if (> k 0)
              (random k)
              (assertion-violationf 'blodwen-random "invalid range argument ~a" k)))]))

;; For finalisers

(define blodwen-finaliser (make-guardian))
(define (blodwen-register-object obj proc)
  (let [(x (cons obj proc))]
       (blodwen-finaliser x)
       x))
(define blodwen-run-finalisers
  (lambda ()
    (let run ()
      (let ([x (blodwen-finaliser)])
        (when x
          (((cdr x) (car x)) 'erased)
          (run))))))
(define NetworkC-45ZeroMQC-45Internal-prim__idris_zmq_socket (lambda (farg-0 farg-1 farg-2) ((foreign-procedure #f "idris_zmq_socket" (void* int) void*) farg-0 farg-1)))
(define NetworkC-45ZeroMQC-45Internal-prim__idris_zmq_ctx_new (lambda (farg-0) ((foreign-procedure #f "idris_zmq_ctx_new" () void*) )))
(define NetworkC-45ZeroMQC-45Internal-prim__idris_zmq_ctx_destroy (lambda (farg-0 farg-1) ((foreign-procedure #f "idris_zmq_ctx_destroy" (void*) void) farg-0) (vector 0 )))
(define NetworkC-45ZeroMQC-45Internal-prim__idris_zmq_connect (lambda (farg-0 farg-1 farg-2 farg-3 farg-4) ((foreign-procedure #f "idris_zmq_connect" (void* string string int) int) farg-0 farg-1 farg-2 farg-3)))
(define NetworkC-45ZeroMQC-45Internal-prim__idris_zmq_close (lambda (farg-0 farg-1) ((foreign-procedure #f "idris_zmq_close" (void*) void) farg-0) (vector 0 )))
(define PreludeC-45IO-prim__putStr (lambda (farg-0 farg-1) ((foreign-procedure #f "idris2_putStr" (string) void) farg-0) (vector 0 )))
(define prim__add_Integer (lambda (arg-0 arg-1) (+ arg-0 arg-1)))
(define prim__sub_Integer (lambda (arg-0 arg-1) (- arg-0 arg-1)))
(define prim__mul_Integer (lambda (arg-0 arg-1) (* arg-0 arg-1)))
(define prim__lte_Integer (lambda (arg-0 arg-1) (or (and (<= arg-0 arg-1) 1) 0)))
(define prim__eq_Int (lambda (arg-0 arg-1) (or (and (= arg-0 arg-1) 1) 0)))
(define prim__strAppend (lambda (arg-0 arg-1) (string-append arg-0 arg-1)))
(define prim__believe_me (lambda (arg-0 arg-1 arg-2) arg-2))
(define prim__cast_IntegerInt (lambda (arg-0) arg-0))
(define Main-case--main-448 (lambda (arg-0 arg-1 arg-2 arg-3 arg-4 arg-5) (let ((sc0 arg-5)) (cond ((equal? sc0 0) (PreludeC-45IO-putStrLn 'erased (vector 0 (vector 0 (vector 0 (lambda (b) (lambda (a) (lambda (func) (lambda (arg-149) (lambda (eta-0) (PreludeC-45IO-map_Functor_IO 'erased 'erased func arg-149 eta-0)))))) (lambda (a) (lambda (arg-482) (lambda (eta-0) arg-482))) (lambda (b) (lambda (a) (lambda (arg-483) (lambda (arg-485) (lambda (eta-0) (let ((act-17 (arg-483 eta-0))) (let ((act-16 (arg-485 eta-0))) (act-17 act-16))))))))) (lambda (b) (lambda (a) (lambda (arg-644) (lambda (arg-645) (lambda (eta-0) (let ((act-24 (arg-644 eta-0))) ((arg-645 act-24) eta-0))))))) (lambda (a) (lambda (arg-647) (lambda (eta-0) (let ((act-51 (arg-647 eta-0))) (act-51 eta-0)))))) (lambda (a) (lambda (arg-7161) arg-7161))) "Something went wrong!")) (else (lambda (eta-0) (let ((act-24 (NetworkC-45ZeroMQC-45Internal-prim__idris_zmq_close arg-2 eta-0))) (let ((act-25 ((PreludeC-45IO-putStrLn 'erased (vector 0 (vector 0 (vector 0 (lambda (b) (lambda (a) (lambda (func) (lambda (arg-149) (lambda (eta-1) (PreludeC-45IO-map_Functor_IO 'erased 'erased func arg-149 eta-1)))))) (lambda (a) (lambda (arg-482) (lambda (eta-1) arg-482))) (lambda (b) (lambda (a) (lambda (arg-483) (lambda (arg-485) (lambda (eta-1) (let ((act-17 (arg-483 eta-1))) (let ((act-16 (arg-485 eta-1))) (act-17 act-16))))))))) (lambda (b) (lambda (a) (lambda (arg-644) (lambda (arg-645) (lambda (eta-1) (let ((act-25 (arg-644 eta-1))) ((arg-645 act-25) eta-1))))))) (lambda (a) (lambda (arg-647) (lambda (eta-1) (let ((act-51 (arg-647 eta-1))) (act-51 eta-1)))))) (lambda (a) (lambda (arg-7161) arg-7161))) "Socket Closed") eta-0))) (let ((act-26 (NetworkC-45ZeroMQC-45Internal-prim__idris_zmq_ctx_destroy arg-0 eta-0))) ((PreludeC-45IO-putStrLn 'erased (vector 0 (vector 0 (vector 0 (lambda (b) (lambda (a) (lambda (func) (lambda (arg-149) (lambda (eta-1) (PreludeC-45IO-map_Functor_IO 'erased 'erased func arg-149 eta-1)))))) (lambda (a) (lambda (arg-482) (lambda (eta-1) arg-482))) (lambda (b) (lambda (a) (lambda (arg-483) (lambda (arg-485) (lambda (eta-1) (let ((act-17 (arg-483 eta-1))) (let ((act-16 (arg-485 eta-1))) (act-17 act-16))))))))) (lambda (b) (lambda (a) (lambda (arg-644) (lambda (arg-645) (lambda (eta-1) (let ((act-27 (arg-644 eta-1))) ((arg-645 act-27) eta-1))))))) (lambda (a) (lambda (arg-647) (lambda (eta-1) (let ((act-51 (arg-647 eta-1))) (act-51 eta-1)))))) (lambda (a) (lambda (arg-7161) arg-7161))) "Context Destroyed") eta-0))))))))))
(define Main-main (lambda (ext-0) (let ((act-24 (NetworkC-45ZeroMQC-45Internal-prim__idris_zmq_ctx_new ext-0))) (let ((act-25 ((PreludeC-45IO-putStrLn 'erased (vector 0 (vector 0 (vector 0 (lambda (b) (lambda (a) (lambda (func) (lambda (arg-149) (lambda (eta-0) (PreludeC-45IO-map_Functor_IO 'erased 'erased func arg-149 eta-0)))))) (lambda (a) (lambda (arg-482) (lambda (eta-0) arg-482))) (lambda (b) (lambda (a) (lambda (arg-483) (lambda (arg-485) (lambda (eta-0) (let ((act-17 (arg-483 eta-0))) (let ((act-16 (arg-485 eta-0))) (act-17 act-16))))))))) (lambda (b) (lambda (a) (lambda (arg-644) (lambda (arg-645) (lambda (eta-0) (let ((act-25 (arg-644 eta-0))) ((arg-645 act-25) eta-0))))))) (lambda (a) (lambda (arg-647) (lambda (eta-0) (let ((act-51 (arg-647 eta-0))) (act-51 eta-0)))))) (lambda (a) (lambda (arg-7161) arg-7161))) "Context Created") ext-0))) (let ((act-26 (NetworkC-45ZeroMQC-45Internal-prim__idris_zmq_socket act-24 4 ext-0))) (let ((act-27 ((PreludeC-45IO-putStrLn 'erased (vector 0 (vector 0 (vector 0 (lambda (b) (lambda (a) (lambda (func) (lambda (arg-149) (lambda (eta-0) (PreludeC-45IO-map_Functor_IO 'erased 'erased func arg-149 eta-0)))))) (lambda (a) (lambda (arg-482) (lambda (eta-0) arg-482))) (lambda (b) (lambda (a) (lambda (arg-483) (lambda (arg-485) (lambda (eta-0) (let ((act-17 (arg-483 eta-0))) (let ((act-16 (arg-485 eta-0))) (act-17 act-16))))))))) (lambda (b) (lambda (a) (lambda (arg-644) (lambda (arg-645) (lambda (eta-0) (let ((act-27 (arg-644 eta-0))) ((arg-645 act-27) eta-0))))))) (lambda (a) (lambda (arg-647) (lambda (eta-0) (let ((act-51 (arg-647 eta-0))) (act-51 eta-0)))))) (lambda (a) (lambda (arg-7161) arg-7161))) "Socket Created") ext-0))) (let ((act-28 (NetworkC-45ZeroMQC-45Internal-prim__idris_zmq_connect act-26 "tcp" "127.0.0.1" 5556 ext-0))) ((Main-case--main-448 act-24 act-25 act-26 act-27 act-28 (PreludeC-45EqOrd-C-47C-61_Eq_Int act-28 0)) ext-0))))))))
(define PreludeC-45Basics-not (lambda (arg-0) (let ((sc0 arg-0)) (cond ((equal? sc0 0) 1) (else 0)))))
(define PreludeC-45Basics-intToBool (lambda (arg-0) (let ((sc0 arg-0)) (cond ((equal? sc0 0) 1)(else 0)))))
(define PreludeC-45Basics-id (lambda (arg-0 arg-1) arg-1))
(define Builtin-believe_me (lambda (arg-0 arg-1 ext-0) ext-0))
(define PreludeC-45Types-case--prim__integerToNat-626 (lambda (arg-0 arg-1) (let ((sc0 arg-1)) (cond ((equal? sc0 0) (Builtin-believe_me 'erased 'erased arg-0)) (else 0)))))
(define PreludeC-45Types-prim__integerToNat (lambda (arg-0) (PreludeC-45Types-case--prim__integerToNat-626 arg-0 (let ((sc0 (or (and (<= 0 arg-0) 1) 0))) (cond ((equal? sc0 0) 1)(else 0))))))
(define PreludeC-45Num-fromInteger_Num_Int (lambda (ext-0) ext-0))
(define PreludeC-45EqOrd-__Impl_Eq_Int (lambda () (vector 0 (lambda (arg-2) (lambda (arg-3) (PreludeC-45EqOrd-C-61C-61_Eq_Int arg-2 arg-3))) (lambda (arg-4) (lambda (arg-5) (PreludeC-45EqOrd-C-47C-61_Eq_Int arg-4 arg-5))))))
(define PreludeC-45EqOrd-C-61C-61_Eq_Int (lambda (arg-0 arg-1) (let ((sc0 (or (and (= arg-0 arg-1) 1) 0))) (cond ((equal? sc0 0) 1)(else 0)))))
(define PreludeC-45EqOrd-C-47C-61_Eq_Int (lambda (arg-0 arg-1) (PreludeC-45Basics-not (PreludeC-45EqOrd-C-61C-61_Eq_Int arg-0 arg-1))))
(define PreludeC-45EqOrd-C-61C-61 (lambda (arg-0 arg-1) (let ((sc0 arg-1)) (let ((e-1 (vector-ref sc0 1))) (lambda (arg-2) (lambda (arg-3) ((e-1 arg-2) arg-3)))))))
(define PreludeC-45Interfaces-C-62C-62C-61 (lambda (arg-0 arg-1 arg-2 arg-3) (let ((sc0 arg-3)) (let ((e-2 (vector-ref sc0 2))) (lambda (arg-4) (lambda (arg-5) ((((e-2 'erased) 'erased) arg-4) arg-5)))))))
(define PrimIO-case--unsafePerformIO-531 (lambda (arg-0 arg-1 arg-2 arg-3) (PrimIO-unsafeDestroyWorld 'erased 'erased arg-3)))
(define PrimIO-case--caseC-32blockC-32inC-32io_bind-452 (lambda (arg-0 arg-1 arg-2 arg-3 arg-4 arg-5 arg-6 arg-7) (arg-7 arg-6)))
(define PrimIO-case--io_bind-430 (lambda (arg-0 arg-1 arg-2 arg-3 arg-4 arg-5) (PrimIO-case--caseC-32blockC-32inC-32io_bind-452 'erased 'erased 'erased 'erased 'erased arg-5 'erased (arg-3 arg-5))))
(define PrimIO-unsafePerformIO (lambda (arg-0 arg-1) (PrimIO-unsafeCreateWorld 'erased (lambda (w) (PrimIO-case--unsafePerformIO-531 'erased 'erased 'erased (arg-1 w))))))
(define PrimIO-unsafeDestroyWorld (lambda (arg-0 arg-1 arg-2) arg-2))
(define PrimIO-unsafeCreateWorld (lambda (arg-0 arg-1) (arg-1 #f)))
(define PrimIO-io_pure (lambda (arg-0 arg-1 ext-0) arg-1))
(define PrimIO-io_bind (lambda (arg-0 arg-1 arg-2 arg-3 ext-0) (PrimIO-case--io_bind-430 'erased 'erased 'erased arg-3 'erased (arg-2 ext-0))))
(define PrimIO-fromPrim (lambda (arg-0 arg-1) arg-1))
(define PreludeC-45IO-pure_Applicative_IO (lambda (arg-0 arg-1 ext-0) arg-1))
(define PreludeC-45IO-map_Functor_IO (lambda (arg-0 arg-1 arg-2 arg-3 ext-0) (let ((act-3 (arg-3 ext-0))) (arg-2 act-3))))
(define PreludeC-45IO-liftIO_HasIO_IO (lambda (arg-0 arg-1) arg-1))
(define PreludeC-45IO-join_Monad_IO (lambda (arg-0 arg-1 ext-0) (let ((act-2 (arg-1 ext-0))) (act-2 ext-0))))
(define PreludeC-45IO-__Impl_Monad_IO (lambda () (vector 0 (vector 0 (lambda (b) (lambda (a) (lambda (func) (lambda (arg-149) (lambda (eta-0) (PreludeC-45IO-map_Functor_IO 'erased 'erased func arg-149 eta-0)))))) (lambda (a) (lambda (arg-482) (lambda (eta-0) arg-482))) (lambda (b) (lambda (a) (lambda (arg-483) (lambda (arg-485) (lambda (eta-0) (let ((act-17 (arg-483 eta-0))) (let ((act-16 (arg-485 eta-0))) (act-17 act-16))))))))) (lambda (b) (lambda (a) (lambda (arg-644) (lambda (arg-645) (lambda (eta-0) (let ((act-24 (arg-644 eta-0))) ((arg-645 act-24) eta-0))))))) (lambda (a) (lambda (arg-647) (lambda (eta-0) (let ((act-29 (arg-647 eta-0))) (act-29 eta-0))))))))
(define PreludeC-45IO-__Impl_HasIO_IO (lambda () (vector 0 (vector 0 (vector 0 (lambda (b) (lambda (a) (lambda (func) (lambda (arg-149) (lambda (eta-0) (PreludeC-45IO-map_Functor_IO 'erased 'erased func arg-149 eta-0)))))) (lambda (a) (lambda (arg-482) (lambda (eta-0) arg-482))) (lambda (b) (lambda (a) (lambda (arg-483) (lambda (arg-485) (lambda (eta-0) (let ((act-17 (arg-483 eta-0))) (let ((act-16 (arg-485 eta-0))) (act-17 act-16))))))))) (lambda (b) (lambda (a) (lambda (arg-644) (lambda (arg-645) (lambda (eta-0) (let ((act-24 (arg-644 eta-0))) ((arg-645 act-24) eta-0))))))) (lambda (a) (lambda (arg-647) (lambda (eta-0) (let ((act-51 (arg-647 eta-0))) (act-51 eta-0)))))) (lambda (a) (lambda (arg-7161) arg-7161)))))
(define PreludeC-45IO-__Impl_Functor_IO (lambda (ext-4 ext-1 ext-2 ext-3 ext-0) (PreludeC-45IO-map_Functor_IO 'erased 'erased ext-2 ext-3 ext-0)))
(define PreludeC-45IO-__Impl_Applicative_IO (lambda () (vector 0 (lambda (b) (lambda (a) (lambda (func) (lambda (arg-149) (lambda (eta-0) (PreludeC-45IO-map_Functor_IO 'erased 'erased func arg-149 eta-0)))))) (lambda (a) (lambda (arg-482) (lambda (eta-0) arg-482))) (lambda (b) (lambda (a) (lambda (arg-483) (lambda (arg-485) (lambda (eta-0) (let ((act-17 (arg-483 eta-0))) (let ((act-16 (arg-485 eta-0))) (act-17 act-16)))))))))))
(define PreludeC-45IO-C-62C-62C-61_Monad_IO (lambda (arg-0 arg-1 arg-2 arg-3 ext-0) (let ((act-1 (arg-2 ext-0))) ((arg-3 act-1) ext-0))))
(define PreludeC-45IO-C-60C-42C-62_Applicative_IO (lambda (arg-0 arg-1 arg-2 arg-3 ext-0) (let ((act-6 (arg-2 ext-0))) (let ((act-5 (arg-3 ext-0))) (act-6 act-5)))))
(define PreludeC-45IO-putStrLn (lambda (arg-0 arg-1 arg-2) (PreludeC-45IO-putStr 'erased arg-1 (string-append arg-2 "\xa;"))))
(define PreludeC-45IO-putStr (lambda (arg-0 arg-1 arg-2) (let ((sc0 arg-1)) (let ((e-2 (vector-ref sc0 2))) ((e-2 'erased) (lambda (eta-0) (PreludeC-45IO-prim__putStr arg-2 eta-0)))))))
(define PreludeC-45IO-primIO (lambda (arg-0 arg-1 arg-2 arg-3) (let ((sc0 arg-2)) (let ((e-2 (vector-ref sc0 2))) ((e-2 'erased) arg-3)))))
(define PreludeC-45IO-liftIO (lambda (arg-0 arg-1 arg-2) (let ((sc0 arg-2)) (let ((e-2 (vector-ref sc0 2))) (lambda (arg-3) ((e-2 'erased) arg-3))))))
(load-shared-object "libidris2_zmq.so")
(load-shared-object "libidris2_support.so")
(collect-request-handler (lambda () (collect) (blodwen-run-finalisers)))
(PrimIO-unsafePerformIO 'erased (lambda (eta-0) (Main-main eta-0)))(collect 4)
(blodwen-run-finalisers))
