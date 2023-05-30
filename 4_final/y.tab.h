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
extern YYSTYPE yylval;
