#include <zmq.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <assert.h>

#define MESSAGE     1
#define BUFFER_SIZE 10

#ifdef MESSAGE

void free_char(void* pointer, void *hint) {
    free(pointer);
}

int main(void)
{
    /**************************************
    CONNECTION
    ***************************************/
    
    printf ("Connecting to hello world server…\n");
    void *context   = zmq_ctx_new ();
    void *requester = zmq_socket (context, ZMQ_REQ);
    zmq_connect (requester, "tcp://localhost:5555");


    /**************************************
    CLIENT's 10 REQUESTS
    ***************************************/
    
    char message_text[] = "Long message";
    int size = strlen(message_text) * sizeof(char);
    int rc; 
    int request_nbr;
    for (request_nbr = 0; request_nbr != BUFFER_SIZE; request_nbr++) {
        /**************************************
        SEND MESSAGE TO SERVER
        ***************************************/
        
        {
            zmq_msg_t message;
            rc = zmq_msg_init_data(
                &message, 
                (void*) strdup(message_text),
                size, 
                &free_char, 
                NULL
            );
            if(rc != 0) {
                printf("A\n");
                return -1;
            }

            printf ("Sending Hello%d...\n", request_nbr);
            rc = zmq_msg_send (&message, requester,  0);
            if (rc < 0)
            {
                printf("Error: %s\n", zmq_strerror(zmq_errno()));
                return -1;
            }

            rc = zmq_msg_close(&message);
            if(rc != 0) {
                printf("B\n");
                return -1;
            }
        }
        /**************************************
        RECEIVE MESSAGE FROM SERVER
        ***************************************/
        
        {
            zmq_msg_t message;
            rc = zmq_msg_init (&message);
            if (rc < 0)
            {
                printf("Error: %s\n", zmq_strerror(zmq_errno()));
                return -1;
            }
            
            zmq_msg_recv (&message, requester, 0);
            printf ("Received World %d\n", request_nbr);

            rc = zmq_msg_close(&message);
            assert(rc == 0);
        }
    }

    return 0;
}

#else
int main (void)
{
    printf ("Connecting to hello world server…\n");
    void *context = zmq_ctx_new ();
    void *requester = zmq_socket (context, ZMQ_REQ);
    zmq_connect (requester, "tcp://localhost:5555");

    int request_nbr;
    char buffer [BUFFER_SIZE];



    for (request_nbr = 0; request_nbr != BUFFER_SIZE; request_nbr++) {
        zmq_msq_t message;
        int rc = zmq_msg_init (&part);
        assert(rc != 0);
        printf ("Sending Hello%d...\n", request_nbr);
        zmq_msq_send (requester, "0123456789", 10, 0);
        // zmq_send (requester, "0123456789", 10, 0);
        zmq_recv (requester, buffer, BUFFER_SIZE, 0);
        printf ("Received World %d\n", request_nbr);
    }
    zmq_close (requester);
    zmq_ctx_destroy (context);
    return 0;
}

#endif