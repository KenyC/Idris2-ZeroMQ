#ifndef IDRIS_ZEROMQ
#define IDRIS_ZEROMQ

#include <stdlib.h>

/**************************************
UTILS
***************************************/

size_t address_size          (char* protocol, char* hostname, int port);
void   create_address        (char* buffer,   char* protocol, char* hostname, int port);
void   free_ptr              (void* pointer,  void *hint);


typedef struct idris_zeromq_recv_result {
    int   result_code;
    void* payload;
} idris_zeromq_recv_result;

int   idris_get_result_code  (void* recv_result);
char* idris_get_payload      (void* recv_result);
void  idris_free_recv_struct (void* res_struct);

/**************************************
INITIALIZATION & DESTRUCTION
***************************************/


void*  idris_zmq_ctx_new     ();
void   idris_zmq_ctx_destroy (void* context);

void*  idris_zmq_socket      (void* context, int type);
void   idris_zmq_close       (void* socket);
int    idris_zmq_bind        (void* socket, char* protocol, char* hostname, int port);
int    idris_zmq_connect     (void* socket, char* protocol, char* hostname, int port);

/**************************************
COMMUNICATION
***************************************/

int    idris_zmq_send        (void* socket, char* message, int flags);
void*  idris_zmq_recv        (void* socket, int flags);




#endif