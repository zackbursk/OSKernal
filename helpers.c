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