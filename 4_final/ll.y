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

extern int yylineno;
int yylex();
void yyerror(const char *s);
//extern int yylineno, yylval;

struct Cycle;

int* addNumberToArray(int number, int *arrayNumbers, int arraySize);
int** addCycleToArray(int* cycle, int **arrayCycles, int arraySize);
int*** addPermutationToArray(int** permutation, int*** arrayPermutations, int arraySize);
void calculatePerm(int*** permutations, int noOfPermutations, int* noOfCycles, int** noOfCyclesArr);
int containsNumber(int* arr, int sizeOfArr, int target);
void printResult(int** result, int* sizeArr, int size);
int calculateLCD(int* arr, int sizeOfArr);

%}

%union {
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
}

%token PLUS
%token MINUS
%token MULTIPLY
%token POWER
%token SPACE
%token LEFT_BR
%token RIGHT_BR
%token<integer> NUMBER
%token PERM
%token LINE_END

%type <integer> basic number power
%type <cycleStruct> cycle_inside cycle
%type <cyclesStruct> cycles perm
%type <permutations> perm_expr

%%
Lang:
    expr
    | Lang expr
    ;
expr:
    basic LINE_END { 
        printf("Syntax OK, basic expr\n");
        printf("vysledek: %d\n\n", $1);
        }
    | perm_expr LINE_END { 
        printf("Syntax OK, perm expr\n");
        calculatePerm($1.permutations, $1.noOfPermutations, $1.cycleSizesArrSize, $1.cycleSizes);
        }
    ;
basic:
    number
    | basic PLUS number {
        //printf("basic expr + number\n");
        $$ = $1 + $3;
        }
    | basic MULTIPLY number {
        //printf("basic expr * number\n");
        $$ = $1 * $3;
        }
    ;
number:
    NUMBER {
        //printf("number\n");
        $$ = $1;
        }
    ;
perm_expr:
    perm {
        //printf("perm expr\n");
        $$.noOfPermutations = 1;
        int*** array = malloc(1 * sizeof(int**));
        $$.permutations = array;
        $$.permutations[0] = $1.cycles;
        int** perms = malloc(1 * sizeof(int*));
        $$.cycleSizes = perms;
        $$.cycleSizes[0] = $1.cycleSizes;
        int* permsArr = malloc(1 * sizeof(int));
        $$.cycleSizesArrSize = permsArr;
        $$.cycleSizesArrSize[0] = $1.noOfCycles;

        int pow = $1.power;
        while(pow > 1){
            int lastSize = $$.noOfPermutations;
            $$.noOfPermutations = lastSize + 1;
            $$.permutations = addPermutationToArray($1.cycles, $$.permutations, lastSize);
            $$.cycleSizes = addCycleToArray($1.cycleSizes, $$.cycleSizes, lastSize);
            $$.cycleSizesArrSize = addNumberToArray($1.noOfCycles, $$.cycleSizesArrSize, lastSize);
            pow = pow - 1;
        }

        }
    | perm_expr MULTIPLY perm {
        //printf("perm expr * perm expr\n");
        int lastSize = $$.noOfPermutations;
        $$.noOfPermutations = lastSize + 1;
        $$.permutations = addPermutationToArray($3.cycles, $$.permutations, lastSize);
        $$.cycleSizes = addCycleToArray($3.cycleSizes, $$.cycleSizes, lastSize);
        $$.cycleSizesArrSize = addNumberToArray($3.noOfCycles, $$.cycleSizesArrSize, lastSize);
        int pow = $3.power;
        while(pow > 1){
            lastSize = $$.noOfPermutations;
            $$.noOfPermutations = lastSize + 1;
            $$.permutations = addPermutationToArray($3.cycles, $$.permutations, lastSize);
            $$.cycleSizes = addCycleToArray($3.cycleSizes, $$.cycleSizes, lastSize);
            $$.cycleSizesArrSize = addNumberToArray($3.noOfCycles, $$.cycleSizesArrSize, lastSize);
            pow = pow - 1;
        }
        }
    ;
perm:
    PERM cycles {
        //printf("perm\n");
        $$.noOfCycles = $2.noOfCycles;
        $$.cycles = $2.cycles;
        $$.cycleSizes = $2.cycleSizes;
        $$.power = 1;
        }
    | PERM cycles power {
        //printf("perm powered\n");
        $$.noOfCycles = $2.noOfCycles;
        $$.cycles = $2.cycles;
        $$.cycleSizes = $2.cycleSizes;
        $$.power = 1;
        int lcd = calculateLCD($2.cycleSizes, $2.noOfCycles);
        int pow = $3;
        while(pow <= 0){
            pow = pow + lcd;
        }
        $$.power = pow;
        }
    ;
cycles:
    cycle {
        //printf("cycle\n");
        $$.noOfCycles = 1;
        int** array = malloc(1 * sizeof(int*));
        $$.cycles = array;
        $$.cycles[0] = $1.numbers;
        int* cycles = malloc(1 * sizeof(int));
        $$.cycleSizes = cycles;
        $$.cycleSizes[0] = $1.size;
        }
    | cycles cycle {
        //printf("cycles, cycle\n");
        int lastSize = $$.noOfCycles;
        $$.noOfCycles = lastSize + 1;
        $$.cycles = addCycleToArray($2.numbers, $$.cycles, lastSize);
        $$.cycleSizes = addNumberToArray($2.size, $$.cycleSizes, lastSize);
        }
    ;
cycle:
    LEFT_BR cycle_inside RIGHT_BR {
        //printf("one cycle\n");
        $$ = $2;
        }
    ;
cycle_inside:
    number {
        //printf("number inside a cycle\n");
        $$.size = 1;
        int* array = malloc(1 * sizeof(int));
        array[0] = $1;
        $$.numbers = array;
        }
    | cycle_inside SPACE number {
        //printf("inside a cycle\n");
        int lastSize = $$.size;
        $$.size = lastSize + 1;
        $$.numbers = addNumberToArray($3, $$.numbers, lastSize);
        }
    ;
power:
    POWER number {
        //printf("to the power of number\n");
        $$ = $2;
        }
    | POWER MINUS number {
        //printf("to the power of negative number\n");
        $$ = (-1) * $3;
        }
    ;
%%

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