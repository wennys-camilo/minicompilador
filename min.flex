%{
#include "min.tab.h"
#include <string.h>
int linha = 1;
int coluna = 1;

%}

LETRA [a-zA-Z_]
DIGITO [0-9]

%%
[\n]                                {linha++; coluna = 1;}
"int"                               { //printf("(%i, %i): <INT, %s\n>",linha,coluna, yytext); 
                                    coluna += yyleng;
                                    return INT;
                                    }
"main"                              { //printf("(%i, %i): <MAIN, %s\n>",linha,coluna, yytext); 
                                    coluna += yyleng;
                                    return MAIN;
                                    }
"return"                            { //printf("(%i, %i): <RETURN, %s\n>",linha,coluna, yytext); 
                                    coluna += yyleng;
                                    return RETURN;
                                    }
"("                                 { //printf("(%i, %i): <ABRE_PARENTESES, %s\n>",linha,coluna, yytext); 
                                    coluna += yyleng;
                                    return ABRE_PARENTESES;
                                    }
")"                                 { //printf("(%i, %i): <FECHA_PARENTESES, %s\n>",linha,coluna, yytext); 
                                    coluna += yyleng;
                                    return FECHA_PARENTESES;
                                    }
"{"                                 { //printf("(%i, %i): <ABRE_CHAVES, %s\n>",linha,coluna, yytext); 
                                    coluna += yyleng;
                                    return ABRE_CHAVES;
                                    }
"}"                                 { //printf("(%i, %i): <FECHA_CHAVES, %s\n>",linha,coluna, yytext); 
                                    coluna += yyleng;
                                    return FECHA_CHAVES;
                                    }
";"                                 {// printf("(%i, %i): <PONTO_E_VIRGULA, %s\n>",linha,coluna, yytext); 
                                    coluna += yyleng;
                                    return PONTO_E_VIRGULA;
                                    }

"+"                                 {coluna += yyleng;  return '+';}
"-"                                 {coluna += yyleng; return '-';}
"="                                 {coluna += yyleng; return '=';}
{DIGITO}+                           {
                                    coluna += yyleng;
                                    yylval.num = atoi(yytext); 
                                    return NUM;
                                    }

{LETRA}({LETRA}|{DIGITO})* 		    {
                                    coluna += yyleng;
                                    yylval.id = (char *)strdup(yytext);
                                    return ID;
                                    }

.                                   {coluna += yyleng;}

%%


