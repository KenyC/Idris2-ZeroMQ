#include "idris_zeromq.h"

#define ADDRESS_TEMPLATE "%s://%s:%i"
#include <zmq.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>

/**************************************
UTILS
***************************************/


size_t address_size(
	char* protocol, 
	char* hostname,
	int   port
) {
	return snprintf(
		NULL,
		0,
		ADDRESS_TEMPLATE,
		protocol, 
		hostname,
		port	
	);
}

void create_address(
	char* buffer,
	char* protocol, 
	char* hostname,
	int   port
) {
	sprintf(
		buffer,
		ADDRESS_TEMPLATE, 
		protocol, 
		hostname,
		port
	);
}

int   idris_get_result_code(void* recv_result) {
	return ((idris_zeromq_recv_result*) recv_result)->result_code;
}
char* idris_get_payload(void* recv_result) {
	return ((idris_zeromq_recv_result*) recv_result)->payload;
}
void idris_free_recv_struct(void* res_struct) {
    idris_zeromq_recv_result* i_res_struct = (idris_zeromq_recv_result*) res_struct;
    if (i_res_struct->payload != NULL) {
        free(i_res_struct->payload);
    }
    free(res_struct);
}
void free_ptr(void* pointer, void *hint) {
    free(pointer);
}

/**************************************
INTIALIZATION AND DESTRUCTION
***************************************/


void* idris_zmq_socket(void* context, int type) {
	return zmq_socket(context, type);
}

void idris_zmq_close(void* socket) {
	zmq_close(socket);
}
int idris_zmq_bind(
	void* socket, 
	char* protocol, 
	char* hostname,
	int   port
) {
	size_t needed = address_size(protocol, hostname, port);
	char  *buffer = (char*)	malloc(needed);
	create_address(buffer, protocol, hostname, port);
	int recv_code = zmq_bind(socket, buffer);
	free(buffer);
	return recv_code;
}

int idris_zmq_connect(
	void* socket, 
	char* protocol, 
	char* hostname,
	int   port
) {
	size_t needed = address_size(protocol, hostname, port);
	char  *buffer = (char*)	malloc(needed);
	create_address(buffer, protocol, hostname, port);
	int recv_code = zmq_connect(socket, buffer);
	free(buffer);
	return recv_code;
}



void* idris_zmq_ctx_new() {
	return zmq_ctx_new();
}

void idris_zmq_ctx_destroy(void* context) {
	zmq_ctx_destroy(context);
}

/**************************************
SENDING AND RECEVING
***************************************/


int idris_zmq_send (void* socket, char* message_text, int flags) {
	zmq_msg_t message;
	int error, rc;

	rc = zmq_msg_init_data(
	    &message, 
	    (void*) strdup(message_text),
	    strlen(message_text) * sizeof(char), 
	    &free_ptr, 
	    NULL
	);
	if(rc != 0) {
		error = zmq_errno();
		zmq_msg_close(&message);
	    return error;
	}

	rc = zmq_msg_send (&message, socket, flags);
	if (rc < 0)
	{
		error = zmq_errno();
		zmq_msg_close(&message);
	    return error;
	}

	rc = zmq_msg_close(&message);
	if(rc != 0) {
	    return zmq_errno();
	}
	return 0;
}

#define RETURN_WITH_ERROR() {\
	result->result_code = zmq_errno();\
	return result;\
}

void* idris_zmq_recv(void* socket, int flags) {
	idris_zeromq_recv_result *result;
	zmq_msg_t message;
	int rc;

	result = (idris_zeromq_recv_result*) malloc(sizeof(idris_zeromq_recv_result));
	result->payload = NULL;

	rc = zmq_msg_init(&message);
	if(rc != 0) {
		RETURN_WITH_ERROR();
	}
	
	int size_msg = zmq_msg_recv(&message, socket, flags);
	if (size_msg < 0)
	{
		zmq_msg_close(&message);
		RETURN_WITH_ERROR();
	}

	char *content = malloc(size_msg + sizeof(char));
	strncpy(
		content, 
		zmq_msg_data(&message), 
		size_msg
	);
	content[size_msg] = '\0';
	result->payload = (void*) content; 


	rc = zmq_msg_close(&message);
	if(rc != 0) {
		RETURN_WITH_ERROR();
	}
	result->result_code = 0;
	return result;
}