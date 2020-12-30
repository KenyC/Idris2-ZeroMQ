#include "idris_zeromq.h"
#include <zmq.h>
#include <string.h>
#include <stdio.h>
#include <assert.h>
// #include <unistd.h>

int main (void)
{
    void *context = idris_zmq_ctx_new ();
    printf ("New Context\n");
    void *requester = idris_zmq_socket (context, ZMQ_REQ);
    printf ("New Socket\n");
    int rc = idris_zmq_connect (requester, "tcp", "127.0.0.1", 5555);
    printf ("Connected\n");
    assert(rc == 0);

    char message_text[]= "Some hella message";
    
    rc = idris_zmq_send(requester, message_text, 0);
    if(rc != 0) {
        printf("%s\n", zmq_strerror(rc));
        return -1; 
    }
    idris_zeromq_recv_result* recv_response = (idris_zeromq_recv_result*) idris_zmq_recv(requester, 0);
    if(recv_response->result_code != 0) {
        idris_free_recv_struct((void*) recv_response);
        printf("%s\n", zmq_strerror(recv_response->result_code));
        return -1;         
    }
    printf("%s\n", (char*) recv_response->payload);
    idris_free_recv_struct((void*) recv_response);


    idris_zmq_close(requester);
    printf ("Closed socket\n");
    idris_zmq_ctx_destroy (context);
    printf ("Destroyed context\n");
    return 0;
}