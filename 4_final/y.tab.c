/* original parser id follows */
/* yysccsid[] = "@(#)yaccpar	1.9 (Berkeley) 02/21/93" */
/* (use YYMAJOR/YYMINOR for ifdefs dependent on parser version) */

#define YYBYACC 1
#define YYMAJOR 1
#define YYMINOR 9
#define YYPATCH 20140715

#define YYEMPTY        (-1)
#define yyclearin      (yychar = YYEMPTY)
#define yyerrok        (yyerrflag = 0)
#define YYRECOVERING() (yyerrflag != 0)
#define YYENOMEM       (-2)
#define YYEOF          0
#define YYPREFIX "yy"

#define YYPURE 0

#line 2 "ll.y"
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
/*#include "prk-stack.h"*/
/*#include "prints.h"*/

extern int yylineno;
int yylex();
void yyerror(const char *s);
/*extern int yylineno, yylval;*/

struct Cycle;

int* addNumberToArray(int number, int *arrayNumbers, int arraySize);
int** addCycleToArray(int* cycle, int **arrayCycles, int arraySize);
int*** addPermutationToArray(int** permutation, int*** arrayPermutations, int arraySize);
void calculatePerm(int*** permutations, int noOfPermutations, int* noOfCycles, int** noOfCyclesArr);
int containsNumber(int* arr, int sizeOfArr, int target);
void printResult(int** result, int* sizeArr, int size);
int calculateLCD(int* arr, int sizeOfArr);

#line 39 "ll.y"
#ifdef YYSTYPE
#undef  YYSTYPE_IS_DECLARED
#define YYSTYPE_IS_DECLARED 1
#endif
#ifndef YYSTYPE_IS_DECLARED
#define YYSTYPE_IS_DECLARED 1
typedef union {
    struct Cycle {
        int size;
        int *numbers;
    } cycleStruct;

    struct Cycles {
        int noOfCycles;
        int** cycles;
        int* cycleSizes;
        int power;
    } cyclesStruct;

    struct Permutations {
        int noOfPermutations;
        int*** permutations;
        int** cycleSizes;
        int* cycleSizesArrSize;

    } permutations;

    int integer;
} YYSTYPE;
#endif /* !YYSTYPE_IS_DECLARED */
#line 88 "y.tab.c"

/* compatibility with bison */
#ifdef YYPARSE_PARAM
/* compatibility with FreeBSD */
# ifdef YYPARSE_PARAM_TYPE
#  define YYPARSE_DECL() yyparse(YYPARSE_PARAM_TYPE YYPARSE_PARAM)
# else
#  define YYPARSE_DECL() yyparse(void *YYPARSE_PARAM)
# endif
#else
# define YYPARSE_DECL() yyparse(void)
#endif

/* Parameters sent to lex. */
#ifdef YYLEX_PARAM
# define YYLEX_DECL() yylex(void *YYLEX_PARAM)
# define YYLEX yylex(YYLEX_PARAM)
#else
# define YYLEX_DECL() yylex(void)
# define YYLEX yylex()
#endif

/* Parameters sent to yyerror. */
#ifndef YYERROR_DECL
#define YYERROR_DECL() yyerror(const char *s)
#endif
#ifndef YYERROR_CALL
#define YYERROR_CALL(msg) yyerror(msg)
#endif

extern int YYPARSE_DECL();

#define PLUS 257
#define MINUS 258
#define MULTIPLY 259
#define POWER 260
#define SPACE 261
#define LEFT_BR 262
#define RIGHT_BR 263
#define NUMBER 264
#define PERM 265
#define LINE_END 266
#define YYERRCODE 256
typedef short YYINT;
static const YYINT yylhs[] = {                           -1,
    0,    0,    9,    9,    1,    1,    1,    2,    8,    8,
    7,    7,    6,    6,    5,    4,    4,    3,    3,
};
static const YYINT yylen[] = {                            2,
    1,    2,    2,    2,    1,    3,    3,    1,    1,    3,
    2,    3,    1,    2,    3,    1,    3,    2,    3,
};
static const YYINT yydefred[] = {                         0,
    8,    0,    0,    0,    5,    9,    0,    1,    0,   13,
    0,    2,    0,    0,    3,    0,    4,   16,    0,    0,
   12,   14,    6,    7,   10,    0,   15,    0,   18,   17,
   19,
};
static const YYINT yydgoto[] = {                          3,
    4,    5,   21,   19,   10,   11,    6,    7,    8,
};
static const YYINT yysindex[] = {                      -240,
    0, -255, -240, -256,    0,    0, -257,    0, -252,    0,
 -244,    0, -252, -252,    0, -242,    0,    0, -241, -250,
    0,    0,    0,    0,    0, -252,    0, -252,    0,    0,
    0,
};
static const YYINT yyrindex[] = {                         0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
 -253,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,
};
static const YYINT yygindex[] = {                         0,
    0,   -9,    0,    0,    4,    0,    5,    0,   23,
};
#define YYTABLESIZE 26
static const YYINT yytable[] = {                         18,
   13,   16,   14,   23,   24,   11,    9,   28,   17,   15,
   29,    1,   11,    1,   22,   20,   30,    9,   31,   26,
   25,   27,    2,    1,    2,   12,
};
static const YYINT yycheck[] = {                          9,
  257,  259,  259,   13,   14,  259,  262,  258,  266,  266,
   20,  264,  266,  264,   11,  260,   26,  262,   28,  261,
   16,  263,  265,  264,  265,    3,
};
#define YYFINAL 3
#ifndef YYDEBUG
#define YYDEBUG 0
#endif
#define YYMAXTOKEN 266
#define YYUNDFTOKEN 278
#define YYTRANSLATE(a) ((a) > YYMAXTOKEN ? YYUNDFTOKEN : (a))
#if YYDEBUG
static const char *const yyname[] = {

"end-of-file",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,"PLUS","MINUS","MULTIPLY","POWER",
"SPACE","LEFT_BR","RIGHT_BR","NUMBER","PERM","LINE_END",0,0,0,0,0,0,0,0,0,0,0,
"illegal-symbol",
};
static const char *const yyrule[] = {
"$accept : Lang",
"Lang : expr",
"Lang : Lang expr",
"expr : basic LINE_END",
"expr : perm_expr LINE_END",
"basic : number",
"basic : basic PLUS number",
"basic : basic MULTIPLY number",
"number : NUMBER",
"perm_expr : perm",
"perm_expr : perm_expr MULTIPLY perm",
"perm : PERM cycles",
"perm : PERM cycles power",
"cycles : cycle",
"cycles : cycles cycle",
"cycle : LEFT_BR cycle_inside RIGHT_BR",
"cycle_inside : number",
"cycle_inside : cycle_inside SPACE number",
"power : POWER number",
"power : POWER MINUS number",

};
#endif

int      yydebug;
int      yynerrs;

int      yyerrflag;
int      yychar;
YYSTYPE  yyval;
YYSTYPE  yylval;

/* define the initial stack-sizes */
#ifdef YYSTACKSIZE
#undef YYMAXDEPTH
#define YYMAXDEPTH  YYSTACKSIZE
#else
#ifdef YYMAXDEPTH
#define YYSTACKSIZE YYMAXDEPTH
#else
#define YYSTACKSIZE 10000
#define YYMAXDEPTH  10000
#endif
#endif

#define YYINITSTACKSIZE 200

typedef struct {
    unsigned stacksize;
    YYINT    *s_base;
    YYINT    *s_mark;
    YYINT    *s_last;
    YYSTYPE  *l_base;
    YYSTYPE  *l_mark;
} YYSTACKDATA;
/* variables for the parser stack */
static YYSTACKDATA yystack;
#line 227 "ll.y"

void yyerror(const char* s) {   
    printf("%s\n",s);
}


int* addNumberToArray(int number, int *arrayNumbers, int arraySize) {
    arrayNumbers = (int*) realloc(arrayNumbers, (arraySize + 1) * sizeof(int));
    arrayNumbers[arraySize] = number;
    return arrayNumbers;
}

int** addCycleToArray(int* cycle, int **arrayCycles, int arraySize) {
    arrayCycles = (int**) realloc(arrayCycles, (arraySize + 1) * sizeof(int*));
    arrayCycles[arraySize] = cycle;
    return arrayCycles;
}

int*** addPermutationToArray(int** permutation, int*** arrayPermutations, int arraySize) {
    arrayPermutations = (int***) realloc(arrayPermutations, (arraySize + 1) * sizeof(int**));
    arrayPermutations[arraySize] = permutation;
    return arrayPermutations;
}

void calculatePerm(int*** permutations, int noOfPermutations, int* noOfCycles, int** noOfCyclesArr) {
    int** outputPerm = malloc(1 * sizeof(int*));
    outputPerm[0] = malloc(1 * sizeof(int));
    int outputI = 0;
    int outputJ = 0;
    int actNumber = 1;
    int nextToTest = actNumber;
    outputPerm[outputI][outputJ] = actNumber;
    int sizeOfOutputPerm = 0;
    int* sizeArr = malloc(1 * sizeof(int));
    sizeArr[0] = 0;
    int* usedNumbers = malloc(1 * sizeof(int));
    usedNumbers[0] = 1;
    int usedNumbersSize = 1;

    int changedOnce = 1;
    while(changedOnce == 1){
        
        changedOnce = 0;
        int changed = 0;
        for(int i = 0; i < noOfPermutations; i++){
            for(int j = 0; j < noOfCycles[i]; j++){
                for(int k = 0; k < noOfCyclesArr[i][j]; k++){
                    if(permutations[i][j][k] == actNumber && changed == 0){
                        changed = 1;
                        changedOnce = 1;
                        if(k + 1 >= noOfCyclesArr[i][j]){
                            actNumber = permutations[i][j][0];
                        }
                        else{
                            actNumber = permutations[i][j][k+1];
                        }
                    }
                }
            }
            changed = 0;
        }

        if(changedOnce){
            if(containsNumber(outputPerm[outputI], sizeOfOutputPerm, actNumber) == 0){
                outputJ = outputJ + 1;
                outputPerm[outputI] = addNumberToArray(actNumber, outputPerm[outputI], sizeOfOutputPerm);
                sizeOfOutputPerm = sizeOfOutputPerm + 1;
                sizeArr[outputI] = sizeArr[outputI] + 1;
                usedNumbers = addNumberToArray(actNumber, usedNumbers, usedNumbersSize);
                usedNumbersSize = usedNumbersSize + 1;
                if(actNumber == nextToTest){
                    nextToTest = nextToTest + 1;
                    while(containsNumber(usedNumbers, usedNumbersSize, nextToTest)){
                        nextToTest = nextToTest + 1;
                    }
                }
            }
            else{
                //sizeArr[outputI] = sizeArr[outputI] + 1;
                outputJ = 0;
                outputI = outputI + 1;
                sizeOfOutputPerm = 0;
                int* newPerm = malloc(1 * sizeof(int));
                outputPerm = addCycleToArray(newPerm, outputPerm, outputI);
                if(actNumber == nextToTest){
                    nextToTest = nextToTest + 1;
                    while(containsNumber(usedNumbers, usedNumbersSize, nextToTest)){
                        nextToTest = nextToTest + 1;
                    }
                }
                actNumber = nextToTest;
                sizeArr = addNumberToArray(0, sizeArr, outputI);
                outputPerm[outputI][outputJ] = actNumber;
            }
        }
        //changedOnce = 0;
    }

    printResult(outputPerm, sizeArr, outputI+1);

}

int containsNumber(int* arr, int sizeOfArr, int target) {
    for (int i = 0; i < sizeOfArr; i++) {
        if (arr[i] == target) {
            return 1;
        }
    }
    return 0;
}

void printResult(int** result, int* sizeArr, int size){
    for(int i = 0; i < size; i++){
        if(sizeArr[i] == 0){
            continue;
        }
        printf("(");
        for(int j = 0; j < sizeArr[i]; j++){
            printf("%d", result[i][j]);
            if(j < sizeArr[i] - 1){
                printf(" ");
            }
        }
        printf(")");
    }
    printf("\n\n");
}

int calculateLCD(int* arr, int sizeOfArr) {
    int lcd = arr[0];
    for (int i = 1; i < sizeOfArr; i++) {
        lcd = lcd * arr[i];
    }
    return lcd;
}

int main(){

    // yydebug = 1;
    //debug_print("Entering the main");
    printf("Entering the matrix\n");
    yyparse();   
}
#line 398 "y.tab.c"

#if YYDEBUG
#include <stdio.h>		/* needed for printf */
#endif

#include <stdlib.h>	/* needed for malloc, etc */
#include <string.h>	/* needed for memset */

/* allocate initial stack or double stack size, up to YYMAXDEPTH */
static int yygrowstack(YYSTACKDATA *data)
{
    int i;
    unsigned newsize;
    YYINT *newss;
    YYSTYPE *newvs;

    if ((newsize = data->stacksize) == 0)
        newsize = YYINITSTACKSIZE;
    else if (newsize >= YYMAXDEPTH)
        return YYENOMEM;
    else if ((newsize *= 2) > YYMAXDEPTH)
        newsize = YYMAXDEPTH;

    i = (int) (data->s_mark - data->s_base);
    newss = (YYINT *)realloc(data->s_base, newsize * sizeof(*newss));
    if (newss == 0)
        return YYENOMEM;

    data->s_base = newss;
    data->s_mark = newss + i;

    newvs = (YYSTYPE *)realloc(data->l_base, newsize * sizeof(*newvs));
    if (newvs == 0)
        return YYENOMEM;

    data->l_base = newvs;
    data->l_mark = newvs + i;

    data->stacksize = newsize;
    data->s_last = data->s_base + newsize - 1;
    return 0;
}

#if YYPURE || defined(YY_NO_LEAKS)
static void yyfreestack(YYSTACKDATA *data)
{
    free(data->s_base);
    free(data->l_base);
    memset(data, 0, sizeof(*data));
}
#else
#define yyfreestack(data) /* nothing */
#endif

#define YYABORT  goto yyabort
#define YYREJECT goto yyabort
#define YYACCEPT goto yyaccept
#define YYERROR  goto yyerrlab

int
YYPARSE_DECL()
{
    int yym, yyn, yystate;
#if YYDEBUG
    const char *yys;

    if ((yys = getenv("YYDEBUG")) != 0)
    {
        yyn = *yys;
        if (yyn >= '0' && yyn <= '9')
            yydebug = yyn - '0';
    }
#endif

    yynerrs = 0;
    yyerrflag = 0;
    yychar = YYEMPTY;
    yystate = 0;

#if YYPURE
    memset(&yystack, 0, sizeof(yystack));
#endif

    if (yystack.s_base == NULL && yygrowstack(&yystack) == YYENOMEM) goto yyoverflow;
    yystack.s_mark = yystack.s_base;
    yystack.l_mark = yystack.l_base;
    yystate = 0;
    *yystack.s_mark = 0;

yyloop:
    if ((yyn = yydefred[yystate]) != 0) goto yyreduce;
    if (yychar < 0)
    {
        if ((yychar = YYLEX) < 0) yychar = YYEOF;
#if YYDEBUG
        if (yydebug)
        {
            yys = yyname[YYTRANSLATE(yychar)];
            printf("%sdebug: state %d, reading %d (%s)\n",
                    YYPREFIX, yystate, yychar, yys);
        }
#endif
    }
    if ((yyn = yysindex[yystate]) && (yyn += yychar) >= 0 &&
            yyn <= YYTABLESIZE && yycheck[yyn] == yychar)
    {
#if YYDEBUG
        if (yydebug)
            printf("%sdebug: state %d, shifting to state %d\n",
                    YYPREFIX, yystate, yytable[yyn]);
#endif
        if (yystack.s_mark >= yystack.s_last && yygrowstack(&yystack) == YYENOMEM)
        {
            goto yyoverflow;
        }
        yystate = yytable[yyn];
        *++yystack.s_mark = yytable[yyn];
        *++yystack.l_mark = yylval;
        yychar = YYEMPTY;
        if (yyerrflag > 0)  --yyerrflag;
        goto yyloop;
    }
    if ((yyn = yyrindex[yystate]) && (yyn += yychar) >= 0 &&
            yyn <= YYTABLESIZE && yycheck[yyn] == yychar)
    {
        yyn = yytable[yyn];
        goto yyreduce;
    }
    if (yyerrflag) goto yyinrecovery;

    YYERROR_CALL("syntax error");

    goto yyerrlab;

yyerrlab:
    ++yynerrs;

yyinrecovery:
    if (yyerrflag < 3)
    {
        yyerrflag = 3;
        for (;;)
        {
            if ((yyn = yysindex[*yystack.s_mark]) && (yyn += YYERRCODE) >= 0 &&
                    yyn <= YYTABLESIZE && yycheck[yyn] == YYERRCODE)
            {
#if YYDEBUG
                if (yydebug)
                    printf("%sdebug: state %d, error recovery shifting\
 to state %d\n", YYPREFIX, *yystack.s_mark, yytable[yyn]);
#endif
                if (yystack.s_mark >= yystack.s_last && yygrowstack(&yystack) == YYENOMEM)
                {
                    goto yyoverflow;
                }
                yystate = yytable[yyn];
                *++yystack.s_mark = yytable[yyn];
                *++yystack.l_mark = yylval;
                goto yyloop;
            }
            else
            {
#if YYDEBUG
                if (yydebug)
                    printf("%sdebug: error recovery discarding state %d\n",
                            YYPREFIX, *yystack.s_mark);
#endif
                if (yystack.s_mark <= yystack.s_base) goto yyabort;
                --yystack.s_mark;
                --yystack.l_mark;
            }
        }
    }
    else
    {
        if (yychar == YYEOF) goto yyabort;
#if YYDEBUG
        if (yydebug)
        {
            yys = yyname[YYTRANSLATE(yychar)];
            printf("%sdebug: state %d, error recovery discards token %d (%s)\n",
                    YYPREFIX, yystate, yychar, yys);
        }
#endif
        yychar = YYEMPTY;
        goto yyloop;
    }

yyreduce:
#if YYDEBUG
    if (yydebug)
        printf("%sdebug: state %d, reducing by rule %d (%s)\n",
                YYPREFIX, yystate, yyn, yyrule[yyn]);
#endif
    yym = yylen[yyn];
    if (yym)
        yyval = yystack.l_mark[1-yym];
    else
        memset(&yyval, 0, sizeof yyval);
    switch (yyn)
    {
case 3:
#line 85 "ll.y"
	{ 
        printf("Syntax OK, basic expr\n");
        printf("vysledek: %d\n\n", yystack.l_mark[-1].integer);
        }
break;
case 4:
#line 89 "ll.y"
	{ 
        printf("Syntax OK, perm expr\n");
        calculatePerm(yystack.l_mark[-1].permutations.permutations, yystack.l_mark[-1].permutations.noOfPermutations, yystack.l_mark[-1].permutations.cycleSizesArrSize, yystack.l_mark[-1].permutations.cycleSizes);
        }
break;
case 6:
#line 96 "ll.y"
	{
        /*printf("basic expr + number\n");*/
        yyval.integer = yystack.l_mark[-2].integer + yystack.l_mark[0].integer;
        }
break;
case 7:
#line 100 "ll.y"
	{
        /*printf("basic expr * number\n");*/
        yyval.integer = yystack.l_mark[-2].integer * yystack.l_mark[0].integer;
        }
break;
case 8:
#line 106 "ll.y"
	{
        /*printf("number\n");*/
        yyval.integer = yystack.l_mark[0].integer;
        }
break;
case 9:
#line 112 "ll.y"
	{
        /*printf("perm expr\n");*/
        yyval.permutations.noOfPermutations = 1;
        int*** array = malloc(1 * sizeof(int**));
        yyval.permutations.permutations = array;
        yyval.permutations.permutations[0] = yystack.l_mark[0].cyclesStruct.cycles;
        int** perms = malloc(1 * sizeof(int*));
        yyval.permutations.cycleSizes = perms;
        yyval.permutations.cycleSizes[0] = yystack.l_mark[0].cyclesStruct.cycleSizes;
        int* permsArr = malloc(1 * sizeof(int));
        yyval.permutations.cycleSizesArrSize = permsArr;
        yyval.permutations.cycleSizesArrSize[0] = yystack.l_mark[0].cyclesStruct.noOfCycles;

        int pow = yystack.l_mark[0].cyclesStruct.power;
        while(pow > 1){
            int lastSize = yyval.permutations.noOfPermutations;
            yyval.permutations.noOfPermutations = lastSize + 1;
            yyval.permutations.permutations = addPermutationToArray(yystack.l_mark[0].cyclesStruct.cycles, yyval.permutations.permutations, lastSize);
            yyval.permutations.cycleSizes = addCycleToArray(yystack.l_mark[0].cyclesStruct.cycleSizes, yyval.permutations.cycleSizes, lastSize);
            yyval.permutations.cycleSizesArrSize = addNumberToArray(yystack.l_mark[0].cyclesStruct.noOfCycles, yyval.permutations.cycleSizesArrSize, lastSize);
            pow = pow - 1;
        }

        }
break;
case 10:
#line 136 "ll.y"
	{
        /*printf("perm expr * perm expr\n");*/
        int lastSize = yyval.permutations.noOfPermutations;
        yyval.permutations.noOfPermutations = lastSize + 1;
        yyval.permutations.permutations = addPermutationToArray(yystack.l_mark[0].cyclesStruct.cycles, yyval.permutations.permutations, lastSize);
        yyval.permutations.cycleSizes = addCycleToArray(yystack.l_mark[0].cyclesStruct.cycleSizes, yyval.permutations.cycleSizes, lastSize);
        yyval.permutations.cycleSizesArrSize = addNumberToArray(yystack.l_mark[0].cyclesStruct.noOfCycles, yyval.permutations.cycleSizesArrSize, lastSize);
        int pow = yystack.l_mark[0].cyclesStruct.power;
        while(pow > 1){
            lastSize = yyval.permutations.noOfPermutations;
            yyval.permutations.noOfPermutations = lastSize + 1;
            yyval.permutations.permutations = addPermutationToArray(yystack.l_mark[0].cyclesStruct.cycles, yyval.permutations.permutations, lastSize);
            yyval.permutations.cycleSizes = addCycleToArray(yystack.l_mark[0].cyclesStruct.cycleSizes, yyval.permutations.cycleSizes, lastSize);
            yyval.permutations.cycleSizesArrSize = addNumberToArray(yystack.l_mark[0].cyclesStruct.noOfCycles, yyval.permutations.cycleSizesArrSize, lastSize);
            pow = pow - 1;
        }
        }
break;
case 11:
#line 155 "ll.y"
	{
        /*printf("perm\n");*/
        yyval.cyclesStruct.noOfCycles = yystack.l_mark[0].cyclesStruct.noOfCycles;
        yyval.cyclesStruct.cycles = yystack.l_mark[0].cyclesStruct.cycles;
        yyval.cyclesStruct.cycleSizes = yystack.l_mark[0].cyclesStruct.cycleSizes;
        yyval.cyclesStruct.power = 1;
        }
break;
case 12:
#line 162 "ll.y"
	{
        /*printf("perm powered\n");*/
        yyval.cyclesStruct.noOfCycles = yystack.l_mark[-1].cyclesStruct.noOfCycles;
        yyval.cyclesStruct.cycles = yystack.l_mark[-1].cyclesStruct.cycles;
        yyval.cyclesStruct.cycleSizes = yystack.l_mark[-1].cyclesStruct.cycleSizes;
        yyval.cyclesStruct.power = 1;
        int lcd = calculateLCD(yystack.l_mark[-1].cyclesStruct.cycleSizes, yystack.l_mark[-1].cyclesStruct.noOfCycles);
        int pow = yystack.l_mark[0].integer;
        while(pow <= 0){
            pow = pow + lcd;
        }
        yyval.cyclesStruct.power = pow;
        }
break;
case 13:
#line 177 "ll.y"
	{
        /*printf("cycle\n");*/
        yyval.cyclesStruct.noOfCycles = 1;
        int** array = malloc(1 * sizeof(int*));
        yyval.cyclesStruct.cycles = array;
        yyval.cyclesStruct.cycles[0] = yystack.l_mark[0].cycleStruct.numbers;
        int* cycles = malloc(1 * sizeof(int));
        yyval.cyclesStruct.cycleSizes = cycles;
        yyval.cyclesStruct.cycleSizes[0] = yystack.l_mark[0].cycleStruct.size;
        }
break;
case 14:
#line 187 "ll.y"
	{
        /*printf("cycles, cycle\n");*/
        int lastSize = yyval.cyclesStruct.noOfCycles;
        yyval.cyclesStruct.noOfCycles = lastSize + 1;
        yyval.cyclesStruct.cycles = addCycleToArray(yystack.l_mark[0].cycleStruct.numbers, yyval.cyclesStruct.cycles, lastSize);
        yyval.cyclesStruct.cycleSizes = addNumberToArray(yystack.l_mark[0].cycleStruct.size, yyval.cyclesStruct.cycleSizes, lastSize);
        }
break;
case 15:
#line 196 "ll.y"
	{
        /*printf("one cycle\n");*/
        yyval.cycleStruct = yystack.l_mark[-1].cycleStruct;
        }
break;
case 16:
#line 202 "ll.y"
	{
        /*printf("number inside a cycle\n");*/
        yyval.cycleStruct.size = 1;
        int* array = malloc(1 * sizeof(int));
        array[0] = yystack.l_mark[0].integer;
        yyval.cycleStruct.numbers = array;
        }
break;
case 17:
#line 209 "ll.y"
	{
        /*printf("inside a cycle\n");*/
        int lastSize = yyval.cycleStruct.size;
        yyval.cycleStruct.size = lastSize + 1;
        yyval.cycleStruct.numbers = addNumberToArray(yystack.l_mark[0].integer, yyval.cycleStruct.numbers, lastSize);
        }
break;
case 18:
#line 217 "ll.y"
	{
        /*printf("to the power of number\n");*/
        yyval.integer = yystack.l_mark[0].integer;
        }
break;
case 19:
#line 221 "ll.y"
	{
        /*printf("to the power of negative number\n");*/
        yyval.integer = (-1) * yystack.l_mark[0].integer;
        }
break;
#line 771 "y.tab.c"
    }
    yystack.s_mark -= yym;
    yystate = *yystack.s_mark;
    yystack.l_mark -= yym;
    yym = yylhs[yyn];
    if (yystate == 0 && yym == 0)
    {
#if YYDEBUG
        if (yydebug)
            printf("%sdebug: after reduction, shifting from state 0 to\
 state %d\n", YYPREFIX, YYFINAL);
#endif
        yystate = YYFINAL;
        *++yystack.s_mark = YYFINAL;
        *++yystack.l_mark = yyval;
        if (yychar < 0)
        {
            if ((yychar = YYLEX) < 0) yychar = YYEOF;
#if YYDEBUG
            if (yydebug)
            {
                yys = yyname[YYTRANSLATE(yychar)];
                printf("%sdebug: state %d, reading %d (%s)\n",
                        YYPREFIX, YYFINAL, yychar, yys);
            }
#endif
        }
        if (yychar == YYEOF) goto yyaccept;
        goto yyloop;
    }
    if ((yyn = yygindex[yym]) && (yyn += yystate) >= 0 &&
            yyn <= YYTABLESIZE && yycheck[yyn] == yystate)
        yystate = yytable[yyn];
    else
        yystate = yydgoto[yym];
#if YYDEBUG
    if (yydebug)
        printf("%sdebug: after reduction, shifting from state %d \
to state %d\n", YYPREFIX, *yystack.s_mark, yystate);
#endif
    if (yystack.s_mark >= yystack.s_last && yygrowstack(&yystack) == YYENOMEM)
    {
        goto yyoverflow;
    }
    *++yystack.s_mark = (YYINT) yystate;
    *++yystack.l_mark = yyval;
    goto yyloop;

yyoverflow:
    YYERROR_CALL("yacc stack overflow");

yyabort:
    yyfreestack(&yystack);
    return (1);

yyaccept:
    yyfreestack(&yystack);
    return (0);
}
