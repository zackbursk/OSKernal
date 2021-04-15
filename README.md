# Nutshell Project

# Features Not Implemented
* Using Pipes with Non-built-in Commands
* Wildcard Matching
* Running Non-built-in Commands in Background
* Using both Pipes and I/O Redirection, combined, with Non-built-in Commands
* Redirecting I/O with Non-built-in Commands
* File Name Completion (Extra Credit)

# Features Implemented
* Built-in Commands
    *  setenv variable word 
    *  printenv 
    *  unsetenv variable 
    *  cd 
    *  alias name word 
    *  unalias name 
    *  alias 
    *  bye 
    *  infinite loop alias-expansion detection
* Non-built-in Commands
    * Any non-built in command found in the path works (with and without arguments) 
* Environment Variable Expansion
* Alias Expansion
* Tilde Expansion (Extra Credit)

# Declaration of What Each Team Member Did
**Zack Bursk**: 
Completed the following built in commands:
*  cd 
*  alias name word 
*  unalias name 
*  alias 
*  bye 
*  infinite loop alias-expansion detection

Completed the execute_other function which allows for **alias expansion** as well **all non-built in commands (ls,mkdir,ping,etc.)** to be executed through excev.
Completed **Environment Variable Expansion** and **Tilde Expansion (Extra Credit)**.

**Joshua Morin**:
Completed the following built in commands:
*  setenv
*  printenv
*  unsetenv


### Testing
```sh
$ make
$ ./nutshell
```


## Resources Used
The following resources were used to better understand certain complex functions and how they are to be properly used.  They are commented out at their designated spots within the code.
http://westes.github.io/flex/manual/Multiple-Input-Buffers.html#Scanning-Strings
https://www.mkssoftware.com/docs/man5/struct_passwd.5.asp
https://wiki.sei.cmu.edu/confluence/pages/viewpage.action?pageId=87152063
https://overiq.com/c-programming-101/array-of-structures-in-c/
