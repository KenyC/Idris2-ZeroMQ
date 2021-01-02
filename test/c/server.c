#include <zmq.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <assert.h>

#define MULTI_MESSAGE
#define BUFFER_SIZE 9

#ifdef MULTI_MESSAGE

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
    int i, more;
    size_t more_size = sizeof (more);
    do {
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
        zmq_getsockopt (responder, ZMQ_RCVMORE, &more, &more_size);
    } while(more);
    char *message_text_reply[] = {"Long message split", "across muli", "lines"};
    char message_text2[] = "Long message";
    char *message_text_part;
    int flag;
    for (request_nbr = 0; request_nbr != 3; request_nbr++) {
        /**************************************
        SEND MESSAGE TO CLIENT
        ***************************************/
        message_text_part = message_text_reply[request_nbr];
        {
            zmq_msg_t message;
            rc = zmq_msg_init_data(
                &message, 
                (void*) strdup(message_text_part),
                strlen(message_text_part) * sizeof(char), 
                &free_char, 
                NULL
            );
            if(rc != 0) {
                printf("A\n");
                return -1;
            }

            printf ("Sending \"%s\"...\n", message_text_part);
            flag = (request_nbr == 2)? 0 : ZMQ_SNDMORE;
            rc = zmq_msg_send (&message, responder,    flag);
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
    
    }
    return 0;
}




#else
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
#endif