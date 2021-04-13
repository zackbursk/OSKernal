all: shell

shell: y.tab.o lex.yy.o
	cc lex.yy.o y.tab.o -o shell

lex.yy.o: lex.yy.c
	cc -c lex.yy.c -w

y.tab.o: y.tab.c
	cc -c y.tab.c

lex.yy.c: lex.l
	lex -d lex.l

y.tab.c: yacc.y
	yacc -d yacc.y

clean:
	rm y.tab.c y.tab.h lex.yy.c shell