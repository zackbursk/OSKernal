#include "helpers.h"
#include <stdlib.h>
#include <stdio.h>
#include <pwd.h>

//call alias table struct
aliasS aTable[MAXALIAS];
//call command table struct
com commandTable[MAXCMDS];
//int for the current command in the table
int currentCommand;
//count of alias
int aliasCount;
//root alias
char *aRoot;

typedef int BOOL;
#define TRUE 1
#define FALSE 0

void listalias() {
    //iterate through table printing all values
    int i = 0;
    for(i; i<aliasCount; i++) {
        printf("%s = %s\n", aTable[i].name, aTable[i].word);
    }
}

int addalias(char *name, char *word) {
    //create alias from struct
    aliasS tempAlias;
    //set alias name/word to the inputted name/word
    tempAlias.name = name,tempAlias.word = word;
    BOOL exists = FALSE;
    int i;
    //Infinite alias checking occurs both within this function and the executeOther function
    for(i=0; i<aliasCount; i++) {
    //check if name/word is used and for infinite alias loop
        if((strcmp(word, aTable[i].name) == 0)) {
            int currPos = i;
            if (strcmp(name, aTable[currPos].word) == 0) {
                printf("Error, expansion of \"%s\" would create a loop.(Infinite loop alias-expansion detection)\n", name);
                return 0;
            } else {
                aliasS tempAlias2;
                tempAlias2.name = aTable[currPos].word;
                int pos = -1;
                for(pos=0; pos < aliasCount;pos++) {
                    if ((strcmp(tempAlias2.name, aTable[pos].name) == 0)) {
                        int currpos2 = pos;
                        if (strcmp(name, aTable[currpos2].word) == 0) {
                            printf("Error, expansion of \"%s\" would create a loop. (Infinite loop alias-expansion detection)\n", name);
                            return 0;
                        }
                    }
                }

            }
        }
    //check if name already exists, if so overwrite
    if(strcmp(name, aTable[i].name) == 0) {
        printf("Error: name \"%s\" already assigned, Overwriting Current Alias with name \"%s\" \n", name, name);
        aTable[i] = tempAlias;
        exists = TRUE;
        break;
    }
    }
    //if already exists remove old one
    if(exists) {
        aTable[i] = tempAlias;
        return 0;
    }
    else {
        //if doesnt exist and is not more than the maximum number of alias's allowed
        if(aliasCount < MAXALIAS) {
            //dont allow same name as word (infinite loop)
            if(strcmp(name, word) == 0) {
                printf("Error, expansion of \"%s\" would create a loop. (Infinite loop alias-expansion detection)\n", name);
                return 0;
            }
            //add alias
            aTable[i] = tempAlias;
            //increase count
            aliasCount++;
            return 1;
        }
    }
    return 0;
}

int unalias(char *name) {
    int i = 0;
    int pos = -1;
    //iterate through all alias
    for(i; i<aliasCount; i++) {
        //if found
        if(strcmp(name, aTable[i].name) == 0) {
            for(pos = i; pos < aliasCount;pos++) {
                //remove
                aTable[pos] = aTable[pos+1];
            }
            //decrease count
            aliasCount--;
            return 1;
        }
    }
    return 0;
}

int addEnv(char* var, char* value) {

    for (int i = 0; i < MAX_ENV; i++) {
        // Check if the env variable exists, update if true
        if (i < envCount && strcmp(envTable[i][0],var) == 0) {
            envTable[i][1] = value;
            break;
        }
        // If variable doesn't exist, add to end of list
        else if (i == envCount) {
            envCount++;
            envTable[i][0] = var;
            envTable[i][1] = value;
            break;
        }
    }
}

int printEnv() {
    for (int i = 0; i < envCount; i++) {
        // Print all env's that have not been removed (non-empty strings)
        if (strcmp(envTable[i][0],""))
            printf("%s=%s\n", envTable[i][0], envTable[i][1]);
    }
}

int unSetEnv(char* var) {
    for (int i = 0; i < envCount; i++) {
        if (!strcmp(envTable[i][0], var)) {
            // sets a removed env to an empty string
            envTable[i][0] = "";
            envTable[i][1] = "";
        }

    }
}

int isalias(char *name) {
    int found = -1;
    int i = 0;
    //basically print alias without printing (returns 1 if found, 0 if not found
    for(i; i<aliasCount; i++) {
        if(strcmp(name, aTable[i].name) == 0) {
            found = i;
            break;
        }
    }
    return found;
}

void executeOther(void) {
    int curr = currentCommand % MAXCMDS;
    char pwd[5000];
    //if its a build in command, it's executed outside of this function
    if(commandTable[curr].checkExternal == 0) {
        return;
    }
    else {
        //check if inputted command is an alias:
        if(isalias(commandTable[curr].commandName) != -1) {
            commandTable[curr].checkExternal = 0;
            if(aRoot == NULL) {
                aRoot = aTable[isalias(commandTable[curr].commandName)].name;
            }
            //parse the string for the alias command (the word specified by the user)
            //basically execute the alias command by calling yyparse again
            scan_string(aTable[isalias(commandTable[curr].commandName)].word);
            //execute alias command
            executeOther();
        }
        else {
            //If not an alias, potentially an external command
            aRoot = NULL;
            //fork process
            pid_t child = fork();
            int status;
            int success = -1;

            //make sure process completes
            while(waitpid(child, &status, 0) == -1) {
                //if call was not interrupted
                if(errno != EINTR) {
                    //success (exit while loop)
                    status = -1;
                    break;
                }
            }
            //error
            if(child < 0) {
                exit(1);
            }
            //if process successfully forked
            else if(child == 0) {
                //set up path to call external command
                char tmp[256];
                //get environment variable PATH for the command
                char *path = strcpy(tmp, getenv("PATH"));
                //breaks the path into tokens
                char *token = strtok(path, ":");

                while(token) {
                    char temp2[255];
                    //If trying to run a specified command (i.e. "./testdir/test.o")
                    char *cmp = "./";
                    //check if first part of command matches "." or "/"
                    if(commandTable[curr].commandName[0] == cmp[0] || commandTable[curr].commandName[0] == cmp[1]) {
                        //if it does match copy the command name to the temp array
                        strcpy(temp2, commandTable[curr].commandName);
                    }
                    else {
                        // If destination is not specified
                        //copy path into temp array
                        //makes it path
                        strcpy(temp2, token);
                        // Append "/" to the end command destination
                        //Makes it path/
                        strcat(temp2, "/");
                        // Append command name to the end command destination
                        //makes it path/CommandName
                        strcat(temp2, commandTable[curr].commandName);
                    }
                    //sets space for any arguments (i.e. -l -ls -lh etc.)
                    char *commands[commandTable[curr].numArgs + 2];
                    //set first spot in array to path/CommandName
                    commands[0] = temp2;
                    //set rest of space that are not arguemnts to null
                    commands[commandTable[curr].numArgs + 1] = (char *)NULL;

                    int i = 0;

                    for(i; i<commandTable[curr].numArgs; i++) {
                        //add args to commands array
                        commands[i+1] = commandTable[curr].atptr[i];
                    }

                    //if execv fails
                    //execv should look like: execv(path/CommandName, args)
                    if(execv(temp2, commands) == -1) {
                        //fill any null spaces
                        token = strtok(NULL, ":");
                        continue;
                    }
                    else {
                        exit(0);
                        success = 1;
                        break;
                    }
                }
                //if fails
                if(success == -1) {
                    printf("Command not found: %s\n", commandTable[curr].commandName);
                    exit(1);
                }
            }
        }
    }
    //increase command count
    currentCommand += 1;
    //reset
    commandTable[currentCommand].checkExternal = 0;
}



