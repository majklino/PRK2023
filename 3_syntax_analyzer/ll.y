%{
/*
syntax = basic | perm, {multiply, perm};
basic = number, {oper, number};
oper = add | multiply;
perm = 'perm', cycle, {cycle}, power;
space = ' ';
cycle = '(', number, {space, number}, ')';
multiply = '*';
add = '+';
number = firstdigit, {digit};
digit = ’0’ | ’1’ | ’2’ | ’3’ | ’4’ | ’5’ | ’6’ | ’7’ | ’8’ | ’9’;
firstdigit = ’1’ | ’2’ | ’3’ | ’4’ | ’5’ | ’6’ | ’7’ | ’8’ | ’9’;
minus = '-' |;
power = '^', minus, number |;
*/

#include <stdio.h>
//#include "prk-stack.h"
//#include "prints.h"

int yylex();
void yyerror(const char *s);
extern int yylineno, yylval;

%}

%token PLUS
%token MINUS
%token MULTIPLY
%token POWER
%token SPACE
%token LEFT_BR
%token RIGHT_BR
%token NUMBER
%token PERM
%token LINE_END

%%
Lang:
    expr
    | Lang expr
    ;
expr:
    basic LINE_END { printf("Syntax OK, basic expr\n"); }
    | perm_expr LINE_END { printf("Syntax OK, perm expr\n");}
    ;
basic:
    NUMBER {printf("number\n");}
    | basic PLUS NUMBER {printf("basic expr + number\n");}
    | basic MULTIPLY NUMBER {printf("basic expr * number\n");}
    ;
perm_expr:
    perm {printf("perm expr\n");}
    | perm_expr MULTIPLY perm {printf("perm expr * perm expr\n");}
    ;
perm:
    PERM cycles {printf("perm\n");}
    | PERM cycles power {printf("perm powered\n");}
    ;
cycles:
    cycle {printf("cycle\n");}
    | cycles cycle {printf("cycles, cycle\n");}
    ;
cycle:
    LEFT_BR cycle_inside RIGHT_BR {printf("one cycle\n");}
    ;
cycle_inside:
    NUMBER {printf("number inside a cycle\n");}
    | cycle_inside SPACE NUMBER {printf("inside a cycle\n");}
    ;
power:
    POWER NUMBER {printf("to the power of number\n");}
    | POWER MINUS NUMBER {printf("to the power of negative number\n");}
    ;
%%

void yyerror(const char* s) {   
    printf("%s\n",s);
}

int main(){
    // yydebug = 1;
    //debug_print("Entering the main");
    printf("Entering the matrix\n");
    yyparse();   
}