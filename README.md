# minicompilador
Instituto Federal Goiano - Campus Rio Verde

Bacharelado em Ciência da Computação - Rio Verde - Compiladores

Integrantes: Wennys Camilo da Silva Oliveira e Conrado Costa Nunes

Mini compilador - Trabalho final de Compiladores



bison -d min.y

flex min.flex

gcc min.tab.c lex.yy.c -lfl -o min

./min < entrada.c

## Gerar out

cat out.s

as out.s -o out.o

ld out.o -o out

./out

echo $?

# (1) Cálculo de expressões com números constantes (adição e subtração); ex: return 10 + 20 – 4;
# (2) Declaração de variáveis inteiras; ex: int x; int y;
# (3) Uso de variáveis – atribuição e cálculo em expressões (declaração antes do uso); ex: x = 10; y = x; z = z + t -1;



