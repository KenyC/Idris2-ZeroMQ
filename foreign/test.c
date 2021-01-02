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

    char *message_text[]= {
        "Some",
        "looong",
        "message"
    };
    
    int flag;
    for (int i = 0; i < 3; ++i)
    {
        flag = (i == 2) ? 0 : ZMQ_SNDMORE;
        rc = idris_zmq_send(requester, message_text[i], flag);
        if(rc != 0) {
            printf("fezfez\n");
            printf("%s\n", zmq_strerror(rc));
            return -1; 
        }
    }


    idris_zeromq_recv_result* recv_response;
    int more;
    int idx = 1;
    do {
        recv_response = (idris_zeromq_recv_result*) idris_zmq_recv(requester, 0);
        if(recv_response->result_code != 0) {
            idris_free_recv_struct((void*) recv_response);
            printf("%s\n", zmq_strerror(recv_response->result_code));
            return -1;         
        }
        printf("%d-th part: %s\n", idx, (char*) recv_response->payload);
        idris_free_recv_struct((void*) recv_response);
        more = idris_more_to_receive(requester);
        idx++;
    } while(more);


    idris_zmq_close(requester);
    printf ("Closed socket\n");
    idris_zmq_ctx_destroy (context);
    printf ("Destroyed context\n");
    return 0;
}