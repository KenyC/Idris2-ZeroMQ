#include <zmq.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <assert.h>

#define MESSAGE     1
#define BUFFER_SIZE 9

#ifdef MESSAGE

void free_char(void* pointer, void *hint) {
    free(pointer);
}

int main(void)
{
    /**************************************
    BINDING
    ***************************************/
    
    printf ("Starting hello world server…\n");
    void *context   = zmq_ctx_new ();
    void *responder = zmq_socket (context, ZMQ_REP);
    int rc = zmq_bind (responder, "tcp://127.0.0.1:5555");
    assert (rc == 0);



    /**************************************
    SERVER EVENT LOOP
    ***************************************/
    
    char message_text[] = "Long response";
    int size = (strlen(message_text))* sizeof(char);
    int request_nbr = 0;
    int i;
    while (1) {
        /**************************************
        RECEIVE MESSAGE FROM CLIENT
        ***************************************/
        
        {
            zmq_msg_t message;
            rc = zmq_msg_init (&message);
            if(rc != 0) {
                return -1;
            }
            printf("A\n");
            
            int size_msg = zmq_msg_recv (&message, responder, 0);
            if (size_msg < 0)
            {
                printf("Error: %s\n", zmq_strerror(zmq_errno()));
                return -1;
            }
            printf ("Received message of size %d\n", size_msg);

            char *content;
            content = malloc(size_msg + 1);
            strncpy(content, zmq_msg_data(&message), size_msg);
            content[size_msg] = '\0';
            printf ("Content of message is %s\n", content);
            free(content);




            rc = zmq_msg_close(&message);
            if(rc != 0) {
                return -1;
            }
            printf("B\n");
        }
        /**************************************
        SEND MESSAGE TO CLIENT
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
            assert(rc == 0);

            printf ("Sending Hello%d...\n", request_nbr);
            zmq_msg_send (&message, responder,  0);

            rc = zmq_msg_close(&message);
            assert(rc == 0);
        }
        request_nbr ++;
    }

    return 0;
}


#else

int main (void)
{
    //  Socket to talk to clients
    void *context = zmq_ctx_new ();
    void *responder = zmq_socket (context, ZMQ_REP);
    printf("Witness me!\n");
    int rc = zmq_bind (responder, "tcp://127.0.0.1:5555");
    assert (rc == 0);

    while (1) {
        char buffer [BUFFER_SIZE];
        for (int i = 0; i < BUFFER_SIZE; ++i)
        {
            buffer[i] = '\0';
        }
        zmq_recv (responder, buffer, BUFFER_SIZE, 0);
        printf ("Received\"%s\"\n", buffer);
        sleep (1);          //  Do some 'work'
        zmq_send (responder, "World", 5, 0);
    }
    return 0;
}

#endif