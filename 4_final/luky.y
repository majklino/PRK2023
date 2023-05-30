%{
/* Original EBNF

MyLang ::= expression

expression ::= term,expression2
expression2 ::= "+",term,expression2 
expression2 ::= ""
term ::= term2,term3
term2 ::= factor,operation
term3 ::= "*", term, term3
term3 ::= ""
operation ::= "~",factor,operation
operation ::= ""

term2 ::= "*",factor,term2
term2 ::= term3
term2 ::= ""
term3 ::= "~",factor,term3
term3 ::= ""
factor ::= "("expression")"
factor ::= integer
factor ::= binary
factor ::= hexa
factor ::= array
factor ::= rand

digits ::={"0","1","2","3","4","5","6","7","8","9"}
integer ::= digits+
binary ::= "b",("0"|"1")+
hexa ::= "0x",hexdigits+
hexdigits ::= {"0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f","A","B","C","D","E","F"}
array ::= "[",arrayNumbers,"]"
arrayNumbers ::= integerArray
arrayNumbers ::= binaryArray
arrayNumbers ::= hexaArray
integerArray ::= integer
integerArray ::= integerArray,separator,integer
binaryArray ::= binary
binaryArray ::= binaryArray,separator,binary
hexaArray ::= hexa
hexaArray ::= hexaArray,separator,hexa
separator = ","

rand ::= "rand(",rand_arguments,")"
rand_arguments ::= ""
rand_arguments ::= data_type
rand_arguments ::= integer,separator,integer
rand_arguments ::= integer,separator,integer,separator,data_type
rand_arguments ::= integer
rand_arguments ::= integer,separator,data_type
rand_arguments ::= integer,separator,integer,separator,integer
rand_arguments ::= integer,separator,integer,separator,integer,separator,data_type

data_type ::= "int"
data_type ::= "bin"
data_type ::= "hex"

*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

int yylex();
void yyerror(const char *s);
extern int yylineno;

char* intToBinary(int n);
char* intToHexa(int n);
struct Number plusOperation(struct Number firstNumber, struct Number secondNumber);
struct Number multiplyOperation(struct Number firstNumber, struct Number secondNumber);
struct Number tildeOperation(struct Number firstNumber, struct Number secondNumber);
int* sumTwoArrays(int *firstArray, int *secondArray, int size);
int* sumNumWithArray(int number, int *array, int size);
int* multiplyTwoArrays(int *firstArray, int *secondArray, int size);
int* multiplyNumWithArray(int number, int *array, int size);
int* tildeTwoArrays(int *firstArray, int *secondArray, int size);
int* tildeNumWithArray(int number, int *array, int size);
char* getNumberType(char* firstType, char* secondType);
int generateRandomNumber();
int generateRandomNumberWithBounds(int min, int max);
int* generateRandomArray(int n);
int* generateRandomArrayWithBounds(int n, int min, int max);
int* addNumberToArray(int number, int *arrayNumbers, int arraySize);
void printResult(struct Number number);
void printNumber(int value, char* numberType);
void printArray(int *arrayNumbers, int arraySize, char* numberType);
void printArrayInt(int *arrayNumbers, int arraySize);
void printArrayBin(int *arrayNumbers, int arraySize);
void printArrayHexa(int *arrayNumbers, int arraySize);

%}

%union {
  struct Number {
    char* type;
    int value;
    int isArray;
    int arraySize;
    int *arrayNumbers;
  } number;
  int integer;
}

%token<integer> INTEGER
%token<integer> BINARY
%token<integer> HEXA
%token ARRAY_START
%token ARRAY_END
%token PLUS
%token MPY
%token TILDE
%token L_BR
%token R_BR
%token RAND
%token SEPARATOR
%token INT_TYPE
%token BIN_TYPE
%token HEX_TYPE
%token LINE_END

%type <number> MyLang expression expression2 term term2 term3 operation factor array random rand_args data_type arrayNumbers integerArray binaryArray hexaArray

%%

MyLang:
    MyLang expression LINE_END {
        printResult($2);
        printf("---------------- OK ----------------\n");
    } //Rule1
    | expression LINE_END {
        printResult($1);
        printf("---------------- OK ----------------\n");
    } //Rule2
    ;

expression:
    term expression2 {
        $$ = plusOperation($1, $2);
    } //Rule3
    ;

expression2:
    PLUS term expression2 {
        printf("Operator +\n");
        $$ = plusOperation($2, $3);
    } //Rule4
    | {
        $$.type = "none";
        $$.value = 0;
        $$.isArray = 0;
        $$.arraySize = 0;
    } //Rule5
    ;

term:
    term2 term3 {
        $$ = multiplyOperation($1, $2);
    } //Rule6
    ;

term2:
    factor operation {
        $$ = tildeOperation($1, $2);
    } //Rule7
    ;

term3:
    MPY term term3  {
        printf("Operator * \n");
        $$ = multiplyOperation($2, $3);
    } //Rule8
    | {
        $$.type = "none";
        $$.value = 0;
        $$.isArray = 0;
        $$.arraySize = 0;
    } //Rule9
    ;

operation:
    TILDE factor operation  {
        printf("Operator ~ \n");
        $$ = tildeOperation($2, $3);
    } //Rule10
    | {
        $$.type = "none";
        $$.value = 0;
        $$.isArray = 0;
        $$.arraySize = 0;
    } //Rule11
    ;

factor:
    L_BR expression R_BR {
        printf("Závorky\n");
        $$ = $2;
    } //Rule12
    | INTEGER {
        printf("INTEGER (%d)\n", $1);
        $$.type = "int";
        $$.value = $1;
        $$.isArray = 0;
        $$.arraySize = 0;
    } //Rule13
    | BINARY {
        printf("BINARY (%s) -> int hodnota %d\n", intToBinary($1), $1);
        $$.type = "bin";
        $$.value = $1;
        $$.isArray = 0;
        $$.arraySize = 0;
    } //Rule14
    | HEXA {
        printf("HEXA (%s) -> int hodnota %d\n", intToHexa($1), $1);
        $$.type = "hex";
        $$.value = $1;
        $$.isArray = 0;
        $$.arraySize = 0;
    } //Rule15
    | array {
        $$=$1;
    } //Rule16
    | random {
        $$=$1;
    } //Rule17
    ;

array:
    ARRAY_START arrayNumbers ARRAY_END {
        $$ = $2;
    } //Rule18
    ;

arrayNumbers:
    integerArray {
        printf("INT array ");
        printArrayInt($1.arrayNumbers, $1.arraySize);
        printf("\n");
        $$ = $1;
    } //Rule19
    | binaryArray {
        printf("BIN array ");
        printArrayBin($1.arrayNumbers, $1.arraySize);
        printf(" -> int hodnoty ");
        printArrayInt($1.arrayNumbers, $1.arraySize);
        printf("\n");
        $$ = $1;
    } //Rule20
    | hexaArray {
        printf("HEX array ");
        printArrayHexa($1.arrayNumbers, $1.arraySize);
        printf(" -> int hodnoty ");
        printArrayInt($1.arrayNumbers, $1.arraySize);
        printf("\n");
        $$ = $1;
    } //Rule21
    ;

integerArray:
    INTEGER {
        if (($$.isArray == 0) && ($$.arraySize == 0)) {
            $$.type = "int";
            $$.value = 0;
            $$.isArray = 1;
            $$.arraySize = 1;
            int* array = malloc(1 * sizeof(int));
            array[0] = $1;
            $$.arrayNumbers = array;
        } else {
            $$.type = "int";
            $$.value = 0;
            $$.isArray = 1;
            int lastSize = $$.arraySize;
            $$.arraySize = lastSize + 1;
            $$.arrayNumbers = addNumberToArray($1, $$.arrayNumbers, lastSize);
        }
    } //Rule22
    | integerArray SEPARATOR INTEGER {
        $$.type = "int";
        $$.value = 0;
        $$.isArray = 1;
        int lastSize = $$.arraySize;
        $$.arraySize = lastSize + 1;
        $$.arrayNumbers = addNumberToArray($3, $$.arrayNumbers, lastSize);
    } //Rule23
    ;

binaryArray:
    BINARY {
        if (($$.isArray == 0) && ($$.arraySize == 0)) {
            $$.type = "bin";
            $$.value = 0;
            $$.isArray = 1;
            $$.arraySize = 1;
            int* array = malloc(1 * sizeof(int));
            array[0] = $1;
            $$.arrayNumbers = array;
        } else {
            $$.type = "bin";
            $$.value = 0;
            $$.isArray = 1;
            int lastSize = $$.arraySize;
            $$.arraySize = lastSize + 1;
            $$.arrayNumbers = addNumberToArray($1, $$.arrayNumbers, lastSize);
        }
    } //Rule24
    | binaryArray SEPARATOR BINARY {
        $$.type = "bin";
        $$.value = 0;
        $$.isArray = 1;
        int lastSize = $$.arraySize;
        $$.arraySize = lastSize + 1;
        $$.arrayNumbers = addNumberToArray($3, $$.arrayNumbers, lastSize);
    } //Rule25
    ;

hexaArray:
    HEXA {
        if (($$.isArray == 0) && ($$.arraySize == 0)) {
            $$.type = "hex";
            $$.value = 0;
            $$.isArray = 1;
            $$.arraySize = 1;
            int* array = malloc(1 * sizeof(int));
            array[0] = $1;
            $$.arrayNumbers = array;
        } else {
            $$.type = "hex";
            $$.value = 0;
            $$.isArray = 1;
            int lastSize = $$.arraySize;
            $$.arraySize = lastSize + 1;
            $$.arrayNumbers = addNumberToArray($1, $$.arrayNumbers, lastSize);
        }
    } //Rule26
    | hexaArray SEPARATOR HEXA {
        $$.type = "hex";
        $$.value = 0;
        $$.isArray = 1;
        int lastSize = $$.arraySize;
        $$.arraySize = lastSize + 1;
        $$.arrayNumbers = addNumberToArray($3, $$.arrayNumbers, lastSize);
    } //Rule27
    ;

random:
    RAND rand_args R_BR {
        $$ = $2;
    } //Rule28
    ;

rand_args:
    data_type {
        $$.type = $1.type;
        $$.value = generateRandomNumber();
        $$.isArray = 0;
        $$.arraySize = 0;
        printf("rand(type)\n");
        printf("rand(%s) -> number ", $1.type);
        printNumber($$.value, $$.type);
        printf("\n");
    } //Rule29
    | INTEGER SEPARATOR INTEGER {
        $$.type = "int";
        $$.value = generateRandomNumberWithBounds($1, $3);
        $$.isArray = 0;
        $$.arraySize = 0;
        printf("rand(x,y)\n");
        printf("rand(%d,%d) -> number %d\n", $1, $3, $$.value);
    } //Rule30
    | INTEGER SEPARATOR INTEGER SEPARATOR data_type {
        $$.type = $5.type;
        $$.value = generateRandomNumberWithBounds($1, $3);
        $$.isArray = 0;
        $$.arraySize = 0;
        printf("rand(x,y,type)\n");
        printf("rand(%d,%d,%s) -> number ", $1, $3, $5.type);
        printNumber($$.value, $$.type);
        printf("\n");
    } //Rule31
    | INTEGER {
        $$.type = "int";
        $$.value = 0;
        $$.isArray = 1;
        $$.arraySize = $1;
        $$.arrayNumbers = generateRandomArray($1);
        printf("rand(n)\n");
        printf("rand(%d) -> array ", $1);
        printArray($$.arrayNumbers, $$.arraySize, $$.type);
        printf("\n");
    } //Rule32
    | INTEGER SEPARATOR data_type {
        $$.type = $3.type;
        $$.value = 0;
        $$.isArray = 1;
        $$.arraySize = $1;
        $$.arrayNumbers = generateRandomArray($1);
        printf("rand(n,type)\n");
        printf("rand(%d,%s) -> array ", $1, $3.type);
        printArray($$.arrayNumbers, $$.arraySize, $$.type);
        printf("\n");
    } //Rule33
    | INTEGER SEPARATOR INTEGER SEPARATOR INTEGER {
        $$.type = "int";
        $$.value = 0;
        $$.isArray = 1;
        $$.arraySize = $5;
        $$.arrayNumbers = generateRandomArrayWithBounds($5, $1, $3);
        printf("rand(x,y,n)\n");
        printf("rand(%d,%d,%d) -> array ", $1, $3, $5);
        printArray($$.arrayNumbers, $$.arraySize, $$.type);
        printf("\n");
    } //Rule34
    | INTEGER SEPARATOR INTEGER SEPARATOR INTEGER SEPARATOR data_type {
        $$.type = $7.type;
        $$.value = 0;
        $$.isArray = 1;
        $$.arraySize = $5;
        $$.arrayNumbers = generateRandomArrayWithBounds($5, $1, $3);
        printf("rand(x,y,n,type)\n");
        printf("rand(%d,%d,%d,%s) -> array ", $1, $3, $5, $7.type);
        printArray($$.arrayNumbers, $$.arraySize, $$.type);
        printf("\n");
    } //Rule35
    | {
        $$.type = "int";
        $$.value = generateRandomNumber();
        $$.isArray = 0;
        $$.arraySize = 0;
        printf("rand() -> number %d\n", $$.value);
    } //Rule36
    ;
  
data_type:
    INT_TYPE {
        $$.type = "int";
    } //Rule37
    | BIN_TYPE {
        $$.type = "bin";
    } //Rule38
    | HEX_TYPE {
        $$.type = "hex";
    } //Rule39
    ;
%%


void yyerror(const char* s) {   
    printf("%s\n",s);
}

int main(){
    // yydebug = 1;
    yyparse();
}


char* intToBinary(int n) {
    int bit_count = 0;
    int temp = n;
    while (temp != 0) {
        temp /= 2;
        bit_count++;
    }
    bit_count = bit_count == 0 ? 1 : bit_count;
    char* binary_str = (char*)malloc(sizeof(char) * (bit_count + 1));
    memset(binary_str, '0', bit_count);
    binary_str[bit_count] = '\0';

    int i = bit_count - 1;
    while (n != 0) {
        binary_str[i--] = (n % 2) + '0';
        n /= 2;
    }
    int first_nonzero_index = 0;
    while (binary_str[first_nonzero_index] == '0' && first_nonzero_index < bit_count - 1) {
        first_nonzero_index++;
    }
    char* result = (char*)malloc(sizeof(char) * (bit_count - first_nonzero_index + 2));
    sprintf(result, "b%s", &binary_str[first_nonzero_index]);
    free(binary_str);
    return result;
}

char* intToHexa(int n) {
    char* hexa = malloc(sizeof(char) * 20);
    sprintf(hexa, "0x%X", n);
    return hexa;
}

struct Number plusOperation(struct Number firstNumber, struct Number secondNumber) {
    // PLUS:
    struct Number result;
    if (strcmp(secondNumber.type, "none") == 0) {
        result = firstNumber;   
    } else if (firstNumber.isArray && secondNumber.isArray) {
        result.type = firstNumber.type;
        result.value = 0;
        result.isArray = 1;
        int size = 0;
        if(firstNumber.arraySize == secondNumber.arraySize) {
            size = firstNumber.arraySize;
        } else {
            //error
            yyerror("Nelze provádět operace mezi různě velkými poli!");
            exit(1);
        }
        result.arraySize = size;
        result.arrayNumbers = sumTwoArrays(firstNumber.arrayNumbers, secondNumber.arrayNumbers, size);
    } else if (firstNumber.isArray && !(secondNumber.isArray)) {
        result.type = firstNumber.type;
        result.value = 0;
        result.isArray = 1;
        int size = firstNumber.arraySize;
        result.arraySize = size;
        result.arrayNumbers = sumNumWithArray(secondNumber.value, firstNumber.arrayNumbers, size);
    } else if (!(firstNumber.isArray) && secondNumber.isArray) {
        result.type = secondNumber.type;
        result.value = 0;
        result.isArray = 1;
        int size = secondNumber.arraySize;
        result.arraySize = size;
        result.arrayNumbers = sumNumWithArray(firstNumber.value, secondNumber.arrayNumbers, size);
    } else {
        result.type = firstNumber.type;
        result.value = firstNumber.value + secondNumber.value;
        result.isArray = 0;
        result.arraySize = 0;
    }
    return result;
}

struct Number multiplyOperation(struct Number firstNumber, struct Number secondNumber) {
    // MULTIPLY:
    struct Number result;
    if (strcmp(secondNumber.type, "none") == 0) {
        result = firstNumber;   
    } else if (firstNumber.isArray && secondNumber.isArray) {
        result.type = firstNumber.type;
        result.value = 0;
        result.isArray = 1;
        int size = 0;
        if(firstNumber.arraySize == secondNumber.arraySize) {
            size = firstNumber.arraySize;
        } else {
            //error
            yyerror("Nelze provádět operace mezi různě velkými poli!");
            exit(1);
        }
        result.arraySize = size;
        result.arrayNumbers = multiplyTwoArrays(firstNumber.arrayNumbers, secondNumber.arrayNumbers, size);
    } else if (firstNumber.isArray && !(secondNumber.isArray)) {
        result.type = firstNumber.type;
        result.value = 0;
        result.isArray = 1;
        int size = firstNumber.arraySize;
        result.arraySize = size;
        result.arrayNumbers = multiplyNumWithArray(secondNumber.value, firstNumber.arrayNumbers, size);
    } else if (!(firstNumber.isArray) && secondNumber.isArray) {
        result.type = secondNumber.type;
        result.value = 0;
        result.isArray = 1;
        int size = secondNumber.arraySize;
        result.arraySize = size;
        result.arrayNumbers = multiplyNumWithArray(firstNumber.value, secondNumber.arrayNumbers, size);
    } else {
        result.type = firstNumber.type;
        result.value = firstNumber.value * secondNumber.value;
        result.isArray = 0;
        result.arraySize = 0;
    }
    return result;
}

struct Number tildeOperation(struct Number firstNumber, struct Number secondNumber) {
    // TILDE:
    struct Number result;
    if (strcmp(secondNumber.type, "none") == 0) {
        result = firstNumber;   
    } else if (firstNumber.isArray && secondNumber.isArray) {
        result.type = firstNumber.type;
        result.value = 0;
        result.isArray = 1;
        int size = 0;
        if(firstNumber.arraySize == secondNumber.arraySize) {
            size = firstNumber.arraySize;
        } else {
            //error
            yyerror("Nelze provádět operace mezi různě velkými poli!");
            exit(1);
        }
        result.arraySize = size;
        result.arrayNumbers = tildeTwoArrays(firstNumber.arrayNumbers, secondNumber.arrayNumbers, size);
    } else if (firstNumber.isArray && !(secondNumber.isArray)) {
        result.type = firstNumber.type;
        result.value = 0;
        result.isArray = 1;
        int size = firstNumber.arraySize;
        result.arraySize = size;
        result.arrayNumbers = tildeNumWithArray(secondNumber.value, firstNumber.arrayNumbers, size);
    } else if (!(firstNumber.isArray) && secondNumber.isArray) {
        result.type = secondNumber.type;
        result.value = 0;
        result.isArray = 1;
        int size = secondNumber.arraySize;
        result.arraySize = size;
        result.arrayNumbers = tildeNumWithArray(firstNumber.value, secondNumber.arrayNumbers, size);
    } else {
        result.type = firstNumber.type;
        result.value = ((firstNumber.value * secondNumber.value) + firstNumber.value + secondNumber.value);
        result.isArray = 0;
        result.arraySize = 0;
    }
    return result;
}

int* sumTwoArrays(int *firstArray, int *secondArray, int size) {
    int* resultArray = malloc(size * sizeof(int));
    for (int i = 0; i < size; i++) {
        resultArray[i] = firstArray[i] + secondArray[i];
    }
    return resultArray;
}

int* sumNumWithArray(int number, int *array, int size) {
    int* resultArray = malloc(size * sizeof(int));
    for (int i = 0; i < size; i++) {
        resultArray[i] = array[i] + number;
    }
    return resultArray;
}

int* multiplyTwoArrays(int *firstArray, int *secondArray, int size) {
    int* resultArray = malloc(size * sizeof(int));
    for (int i = 0; i < size; i++) {
        resultArray[i] = firstArray[i] * secondArray[i];
    }
    return resultArray;
}

int* multiplyNumWithArray(int number, int *array, int size) {
    int* resultArray = malloc(size * sizeof(int));
    for (int i = 0; i < size; i++) {
        resultArray[i] = array[i] * number;
    }
    return resultArray;
}

int* tildeTwoArrays(int *firstArray, int *secondArray, int size) {
    int* resultArray = malloc(size * sizeof(int));
    for (int i = 0; i < size; i++) {
        resultArray[i] = (firstArray[i] * secondArray[i]) + firstArray[i] + secondArray[i];
    }
    return resultArray;
}

int* tildeNumWithArray(int number, int *array, int size) {
    int* resultArray = malloc(size * sizeof(int));
    for (int i = 0; i < size; i++) {
        resultArray[i] = (number * array[i]) + number + array[i];
    }
    return resultArray;
}

char* getNumberType(char* firstType, char* secondType) {
    if (strcmp(secondType, "array") == 0) {
        return secondType;
    } else {
        return firstType;
    }
}

int generateRandomNumber() {
    int min = 0;
    int max = 100;
    srand(time(NULL));
    int randomNumber = (rand() % (max - min + 1)) + min;
    return randomNumber;
}

int generateRandomNumberWithBounds(int min, int max) {
    srand(time(NULL));
    int randomNumber = (rand() % (max - min + 1)) + min;
    return randomNumber;
}

int* generateRandomArray(int n) {
    int min = 0;
    int max = 100;
    int* array = malloc(n * sizeof(int));
    srand(time(NULL));
    for (int i = 0; i < n; i++) {
        array[i] = (rand() % (max - min + 1)) + min;
    }
    return array;
}

int* generateRandomArrayWithBounds(int n, int min, int max) {
    int* array = malloc(n * sizeof(int));
    srand(time(NULL));
    for (int i = 0; i < n; i++) {
        array[i] = (rand() % (max - min + 1)) + min;
    }
    return array;
}

int* addNumberToArray(int number, int *arrayNumbers, int arraySize) {
    arrayNumbers = (int*) realloc(arrayNumbers, (arraySize + 1) * sizeof(int));
    arrayNumbers[arraySize] = number;
    return arrayNumbers;
}

void printResult(struct Number number) {
    printf("\n");
    if (number.isArray == 0) {
        if (strcmp(number.type, "int") == 0) {
            printf("RESULT: %d\n", number.value);
        } else if (strcmp(number.type, "bin") == 0) {
            char* binary = intToBinary(number.value);
            printf("RESULT: %s (hodnota %d)\n", binary, number.value);
            //free(binary);
        } else if (strcmp(number.type, "hex") == 0) {
            char* hexa = intToHexa(number.value);
            printf("RESULT: %s (hodnota %d)\n", hexa, number.value);
            //free(hexa);
        } else {
            printf("RESULT: %d (Ani jedno ze 3)\n", number.value);
        }
    } else {
        if (strcmp(number.type, "int") == 0) {
            printf("RESULT: ");
            printArrayInt(number.arrayNumbers, number.arraySize);
            printf("\n");
        } else if (strcmp(number.type, "bin") == 0) {
            printf("RESULT: ");
            printArrayBin(number.arrayNumbers, number.arraySize);
            printf(" - int hodnoty: ");
            printArrayInt(number.arrayNumbers, number.arraySize);
            printf("\n");
        } else if (strcmp(number.type, "hex") == 0) {
            printf("RESULT: ");
            printArrayHexa(number.arrayNumbers, number.arraySize);
            printf(" - int hodnoty: ");
            printArrayInt(number.arrayNumbers, number.arraySize);
            printf("\n");
        } else {
            printf("RESULT: ");
            printArrayInt(number.arrayNumbers, number.arraySize);
            printf(" (Ani jedno ze 3)\n");
        }
    }
}

void printNumber(int value, char* numberType) {
    if (strcmp(numberType, "int") == 0) {
        printf("%d", value);
    } else if (strcmp(numberType, "bin") == 0) {
        printf("%s", intToBinary(value));
    } else if (strcmp(numberType, "hex") == 0) {
        printf("%s", intToHexa(value));
    }
}

void printArray(int *arrayNumbers, int arraySize, char* numberType) {
    if (strcmp(numberType, "int") == 0) {
        printArrayInt(arrayNumbers, arraySize);
    } else if (strcmp(numberType, "bin") == 0) {
        printArrayBin(arrayNumbers, arraySize);
    } else if (strcmp(numberType, "hex") == 0) {
        printArrayHexa(arrayNumbers, arraySize);
    }
}

void printArrayInt(int *arrayNumbers, int arraySize) {
    printf("[");
    for (int i = 0; i < arraySize; i++) {
        printf("%d", arrayNumbers[i]);
        if (i != arraySize - 1) {
            printf(", ");
        }
    }
    printf("]");
}

void printArrayBin(int *arrayNumbers, int arraySize) {
    printf("[");
    for (int i = 0; i < arraySize; i++) {
        printf("%s", intToBinary(arrayNumbers[i]));
        if (i != arraySize - 1) {
            printf(", ");
        }
    }
    printf("]");
}

void printArrayHexa(int *arrayNumbers, int arraySize) {
    printf("[");
    for (int i = 0; i < arraySize; i++) {
        printf("%s", intToHexa(arrayNumbers[i]));
        if (i != arraySize - 1) {
            printf(", ");
        }
    }
    printf("]");
}
