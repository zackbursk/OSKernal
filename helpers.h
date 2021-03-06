#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <errno.h>
#include <unistd.h>
#include <signal.h>

#ifndef HELPERS_H
#define HELPERS_H

#define getHOME getenv("HOME")
#define getPWD getenv("PWD")

#define MAXCMDS 50
#define MAXARGS 300
#define MAXALIAS 100

#define MAX_ALIASES 50
#define MAX_ENV 100

//definition of table to hold aliases
char * envTable[MAX_ENV][2];
int envCount;

//https://overiq.com/c-programming-101/array-of-structures-in-c/
typedef struct aliasS {
    char  *name;
    char  *word;
} aliasS;

typedef struct com {
    char   *name;
    int     checkExternal;
    int     numArgs;
    int     numCommands;
    char *atThis[50];
}  com;

extern aliasS       aTable[];
extern com      commandTable[];
extern int         currentCommand;
extern int         aliasCount;
extern char        *aliasroot;
#endif