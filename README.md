# minicompilador
mini compilador - Trabalho final de Compiladores

bison -d min.y 
flex min.flex
gcc min.tab.c lex.yy.c -lfl -o min
./min < entrada.c

//gerar out.s

cat out.s          //mostrar o que gerou 
as out.s -o out.o
ld out.o -o out 
./out 
echo $?
