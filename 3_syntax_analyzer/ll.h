#undef VERBOSE 

#define _CPP_IOSTREAMS y



/* Define constants for patterns - used in process_pattern function */

#define PATT_NO 0 /* No pattern will be sent to parser */

#define PATT_PLUS 1
#define PATT_MINUS 2
#define PATT_MULTIPLY 3
#define PATT_POWER 4
#define PATT_SPACE 5
#define PATT_LEFT_BR 6
#define PATT_RIGHT_BR 7
#define PATT_NUMBER 8
#define PATT_PERM 9

#define PATT_ERR 100 /* Error in patterns: exit on errors! */


#define ERR_PATTERN 10 /* Lexer: an error pattern detected. */

char *ErrMsgMain = "Error detected with code:";

char Err_Messages[][255] = {"No Error","Lexer: Wrong character detected. Exiting."};