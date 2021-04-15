# Simple Makefile

CC=/usr/bin/cc

all:  bison-config flex-config nutshell

bison-config:
	bison -d yacc.y

flex-config:
	flex lex.l

nutshell: 
	$(CC) yacc.tab.c lex.yy.c -o nutshell.o

clean:
	rm yacc.tab.c yacc.tab.h lex.yy.c