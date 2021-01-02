#include <zmq.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <assert.h>
#include <pthread.h> 
#include "server.h"
#include "deps/yyjson.h"





int main(int argc, char *argv[])
{
	/**************************************
	RETRIEVE AND READ CONNECTION FILE
	***************************************/

	/********* READ FILE *********/

	if (argc < 2)
	{
		EXIT_WITH_ERROR("No connection file provided, exitting")
	}

	// FILE *file = fopen(argv[1], r);
	FILE *file = fopen(argv[1], "r");
	if(file == NULL) {
		EXIT_WITH_ERROR("Couldn't open file")
	} 

	fseek(file, 0, SEEK_END);
	int file_size = ftell(file);
	fseek(file, 0, SEEK_SET);  /* same as rewind(f); */

	char *contents = malloc(file_size + 1);
	fread(contents, 1, file_size, file);

	contents[file_size] = '\0';
	fclose(file);
	// printf("%s\n", contents);

	/********* PARSE FILE *********/
	yyjson_doc *doc  = yyjson_read(contents, strlen(contents), 0);
	free(contents);
	yyjson_val *root = yyjson_doc_get_root(doc);

	// yyjson_val *hbport = yyjson_obj_get(root, "hb_port");
	// printf("hb_port: %d\n", (int) yyjson_get_int(hbport));
	int hb_port      = GET_JSON_INT(root, "hb_port");
	int shell_port   = GET_JSON_INT(root, "shell_port");
	int control_port = GET_JSON_INT(root, "control_port");
	int iopub_port   = GET_JSON_INT(root, "iopub_port");
	int stdin_port   = GET_JSON_INT(root, "stdin_port");
	const char* ip         = GET_JSON_STR(root, "ip");
	const char* transport  = GET_JSON_STR(root, "transport");

	printf("Stdin port: %i\n", stdin_port);
	printf("IP:         %s\n", ip);
	printf("Transport:  %s\n", transport);

	/********* CLEAN UP   *********/
	yyjson_doc_free(doc);

	/**************************************
	THREAD CREATION
	***************************************/
	connection hb_connection;
	hb_connection.port     = hb_port;
	hb_connection.address  = ip;
	hb_connection.protocol = transport;
	hb_connection.zmq_context = zmq_ctx_new();

	pthread_t hb_id, shell_id, control_id, iopub_id;
	pthread_create(&hb_id, NULL, hb_server, &hb_connection);

	connection shell_connection = hb_connection;
	shell_connection.port = shell_port;
	pthread_create(&shell_id, NULL, shell_server, &shell_connection);

	// connection control_connection = hb_connection;
	// control_connection.port = control_port;
	// pthread_create(&control_id, NULL, shell_server, &control_connection);

	// connection iopub_connection = hb_connection;
	// iopub_connection.port = iopub_port;
	// pthread_create(&iopub_id, NULL, shell_server, &iopub_connection);


	pthread_join(hb_id, NULL); 
	

	zmq_ctx_destroy(hb_connection.zmq_context);
	return 0;
}




void* hb_server(void* argp) {
	connection *hb_connection = (connection*) argp;
	/**************************************
	BINDING
	***************************************/
	

	LOG_HB ("Socket creation...\n");
	void *responder = zmq_socket (hb_connection->zmq_context, ZMQ_REP);

	LOG_HB ("Socket created...\n");
	char address[256];
	sprintf(address, "%s://%s:%i", 
		hb_connection->protocol, 
		hb_connection->address, 
		hb_connection->port
	); 
	LOG_HB ("Trying to bind...\n");
	int rc = zmq_bind (responder, address);
	LOG_HB ("Jupyter server bound...\n");
	assert (rc == 0);

	/**************************************
	RECEIVE MESSAGE FROM CLIENT
	***************************************/
	
	char *content;
	int size_msg;
	{
		zmq_msg_t message;
		rc = zmq_msg_init (&message);
		if(rc != 0) {
			// EXIT_WITH_ERROR("Couldn't initialize message")
		}
		
		LOG_HB (">>> Waiting for message...\n");
		size_msg = zmq_msg_recv (&message, responder, 0);
		if (size_msg < 0)
		{
			// EXIT_WITH_ERROR(zmq_strerror(zmq_errno()));
		}
		LOG_HB ("Received message of size %d\n", size_msg);

		content = malloc(size_msg + 1);
		strncpy(content, zmq_msg_data(&message), size_msg);
		content[size_msg] = '\0';
		LOG_HB ("Content of message is %s\n", content);




		rc = zmq_msg_close(&message);
		if(rc != 0) {
			// EXIT_WITH_ERROR("Couln't close message")
		}
	}

	/**************************************
	SEND MESSAGE TO CLIENT
	***************************************/
	
	{
		LOG_HB("<<< Sending message\n");
		zmq_msg_t message;
		rc = zmq_msg_init_data(
			&message, 
			(void*) strdup(content),
			size_msg+2, 
			&free_char, 
			NULL
		);
		assert(rc == 0);

		LOG_HB ("Sending %s...\n", content);
		zmq_msg_send (&message, responder,  0);

		rc = zmq_msg_close(&message);
		assert(rc == 0);
	}
	free(content);
	return NULL;
}

void* shell_server(void* argp) {
	connection *shell_connection = (connection*) argp;
	/**************************************
	BINDING
	***************************************/
	
	LOG_SHELL ("Starting Jupyter server...\n");
	void *context   = zmq_ctx_new ();

	LOG_SHELL ("Socket creation...\n");
	void *responder = zmq_socket (shell_connection->zmq_context, ZMQ_ROUTER);

	LOG_SHELL ("Socket created...\n");
	char address[256];
	sprintf(address, "%s://%s:%i", 
		shell_connection->protocol, 
		shell_connection->address, 
		shell_connection->port
	); 
	LOG_SHELL ("Trying to bind...\n");
	int rc = zmq_bind (responder, address);
	LOG_SHELL ("Jupyter server bound...\n");
	assert (rc == 0);

	/**************************************
	RECEIVE MESSAGE FROM CLIENT
	***************************************/
	
	char *content;
	int size_msg;
	{
		zmq_msg_t message;
		rc = zmq_msg_init (&message);
		if(rc != 0) {
			// EXIT_WITH_ERROR("Couldn't initialize message")
		}
		
		LOG_SHELL (">>> Waiting for message...\n");
		size_msg = zmq_msg_recv (&message, responder, 0);
		if (size_msg < 0)
		{
			LOG_SHELL("%s", zmq_strerror(zmq_errno()));
			return NULL;
		}
		LOG_SHELL ("Received message of size %d\n", size_msg);

		content = malloc(size_msg + 1);
		strncpy(content, zmq_msg_data(&message), size_msg);
		content[size_msg] = '\0';
		LOG_SHELL ("Content of message is %s\n", content);




		rc = zmq_msg_close(&message);
		if(rc != 0) {
			// EXIT_WITH_ERROR("Couln't close message")
		}
	}

	/**************************************
	SEND MESSAGE TO CLIENT
	***************************************/
	
	{
		LOG_SHELL("<<< Sending message\n");
		zmq_msg_t message;
		rc = zmq_msg_init_data(
			&message, 
			(void*) strdup(content),
			size_msg, 
			&free_char, 
			NULL
		);
		assert(rc == 0);

		LOG_SHELL ("Sending %s...\n", content);
		free(content);
		zmq_msg_send (&message, responder,  0);

		rc = zmq_msg_close(&message);
		assert(rc == 0);
	}
	return NULL;
}

