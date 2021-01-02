#ifndef SERVER_H
#define SERVER_H



#define EXIT_WITH_ERROR(error) {\
  printf("%s", error);\
  printf("\n");\
  return -1;\
}

#define GET_JSON_INT(root, field) (int) yyjson_get_int(yyjson_obj_get(root, field))
#define GET_JSON_STR(root, field) yyjson_get_str(yyjson_obj_get(root, field))

void free_char(void* pointer, void *hint) {
    free(pointer);
}

typedef struct connection_struct {
	int   port;    
	const char* address; 
	const char* protocol;
	void*       zmq_context;
} connection;

void* hb_server   (void *argp);
void* shell_server(void *argp);


/**************************************
LOGGING
***************************************/

#define LISTEN_TO_SHELL

#define LOG_HB(message,    ...) {}
#define LOG_SHELL(message, ...) {}

#ifdef LISTEN_TO_HB
#	undef  LOG_HB
#	define LOG_HB(message, ...) printf(message, ##__VA_ARGS__)
#endif

#ifdef LISTEN_TO_SHELL
#	undef  LOG_SHELL
#	define LOG_SHELL(message, ...) printf(message, ##__VA_ARGS__)
#endif



#endif