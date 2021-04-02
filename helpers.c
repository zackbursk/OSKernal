#include "helpers.h"
#include <stdlib.h>
#include <stdio.h>


int addalias(char *name , char * word){
    int i = 0;
    //find open spot
    while(aTable[i][0] != NULL){
        //check if name/word is used
        if(strcmp(name , aTable[i][0]) == 0){
            printf("Error: name \"%s\" already assigned\n", name);
            return 1;
        }
        if(strcmp(word,aTable[i][1]) == 0){
            printf("Error: word \"%s\" already assigned\n", word);
            return 1;
        }
        i++;
    }
    //potentially change?
    if(i >= MAX_ALIASES){
        printf("\t Error: Alias table is full.\n");
        return 1;
    }
    //add to table
    else{
        aTable[i][0] = name;
        aTable[i][1] = word;
    }
    return 0;
}

int unalias(char * name){
    int i = 0;
    int found = 0;

    while(aTable[i][0]!=NULL) {
        //check if name exists
        if (strcmp(name, aTable[i][0]) == 0) {
            //once found remove
            aTable[i][0] = 0;
            aTable[i][1] = 0;
            i++;
            found = 1;
            return 1;
        }
        i++;
    }
    if(found == 0){
        printf("\"%s\" was not found.\n" , name);
        return 1;
    }
    return 0;

}

int listalias(){
    //iterate through table printing all values
    int i = 0;
    while(aTable[i][0]){
        printf("%s\t", aTable[i][0]);
        printf("%s\n", aTable[i++][1]);
    }
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