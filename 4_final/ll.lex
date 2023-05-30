%{
/* Variable declaration */
int lines_done=0;
int void_lines_done=0;
int lines_comment=0;

int plus = 0;
int minus = 0;
int multiply = 0;
int power = 0;
int space = 0;
int leftbr = 0;
int rightbr = 0;
int number = 0;
int perm = 0;

int test;

int errors_detected=0;

#include "ll.h"
#include "y.tab.h"
#include <stdio.h>
#include <stdlib.h>

int process_pattern(int number, char *Message, int Pattern);
void print_error(int ERRNO);
void print_msg(char *msg);
%}

%%
^#.*\n  {lines_comment=process_pattern(lines_comment,"Comment deleted.\n",PATT_NO);}
\+      {plus=process_pattern(plus,"+ operator detected.",PATT_PLUS);
            return PLUS;
        }
\-      {minus=process_pattern(minus,"- operator detected.",PATT_MINUS);
            return MINUS;
        }        
\*      {multiply=process_pattern(multiply,"* operator detected.",PATT_MULTIPLY);
            return MULTIPLY;
        }
\^      {power=process_pattern(power,"^ operator detected.",PATT_POWER);
            return POWER;
        }
\       {space=process_pattern(space,"Space detected.",PATT_SPACE);
            return SPACE;
        }
\(      {leftbr=process_pattern(leftbr,"Opening bracket detected.",PATT_LEFT_BR);
            return LEFT_BR;
        }
\)      {rightbr=process_pattern(rightbr,"Closing bracket detected.",PATT_RIGHT_BR);
            return RIGHT_BR;
        }
(?:0|[1-9][0-9]*)  {number=process_pattern(number, "number detected.",PATT_NUMBER);
            yylval.integer = atoi(yytext);
            //test = atoi(yytext);
            return NUMBER;
        }
perm   {perm=process_pattern(perm,"Perm detected.",PATT_PERM);
            return PERM;
        }
^\n     {void_lines_done++;        
            print_msg("Void line detected.\n");
        }       
\n      {lines_done++;
            print_msg("Line detected.\n");
            return LINE_END;
        }

[ \t]+ ; /*Skip whitespace*/

.      {errors_detected=process_pattern(errors_detected,"An error detected.\n",PATT_ERR);} /* What is not from alphabet: lexer error  */

%%


int yywrap(void) {
return 1;
}
/*int main()
    {
        yylex();
        printf("%d of total errors detected in input file.\n",errors_detected);
        printf("%d of + operators detected.\n", plus);
        printf("%d of - operators detected.\n", minus);
        printf("%d of * operators detected.\n", multiply);
        printf("%d of ^ operators detected.\n", power);
        printf("%d of spaces detected.\n", space);
        printf("%d of opening brackets detected.\n", leftbr);
        printf("%d of closing brackets detected.\n", rightbr);
        printf("%d of numbers detected.\n", number);
        printf("%d of permutation declarations detected.\n", perm);
        printf("%d of void lines ignored.\nFile processed sucessfully.\n",void_lines_done);
        printf("Totally %d of valid code lines in file processed.\nFile processed sucessfully.\n",lines_done);
        
    }*/

void print_msg(char *msg){
    #ifdef VERBOSE
        printf("%s",msg);
    #endif
}

void print_error(int ERRNO){
    #ifdef VERBOSE
        char *message = Err_Messages[ERRNO];
        printf("%s - %d - %s\n",ErrMsgMain,ERR_PATTERN,message);
    #endif
}

int process_pattern(int number,char* Message, int Pattern) {
    if (Pattern == PATT_ERR) {       
        print_error(ERR_PATTERN);        
        //exit(ERR_PATTERN);
    }    

    print_msg(Message);
    //printf("%s",Message);
    
    number++;
    return number;
}
