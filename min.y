%{
#include <stdio.h>     			/* C */
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

int extern linha;
int extern coluna;

int extern yyleng;
char extern *yytext;
FILE *f;

int yylex(void);

int yyerror(char *error_msg){
	printf("%s (%i, %i) = %s\n",error_msg,linha,coluna-yyleng,yytext);
	exit(1);
	} 

struct tabeladesimolos
{
  char *nome;             
  struct tabeladesimolos *prox;    
};

typedef struct tabeladesimolos tabeladesimolos;
tabeladesimolos *t_simbolos = (tabeladesimolos *)0;

tabeladesimolos *inserir_simbolo();
tabeladesimolos *inicio_da_tabela();

tabeladesimolos * inserir_simbolo ( char *simbolo_nome ){
  tabeladesimolos *ptr;
  ptr = (tabeladesimolos *)malloc(sizeof(tabeladesimolos));
  ptr->nome = (char *)malloc(strlen(simbolo_nome)+1);
  strcpy (ptr->nome,simbolo_nome);
  ptr->prox = (struct tabeladesimolos *)t_simbolos;
  t_simbolos = ptr;
  printf("Declaração %s, Inteiro\n",simbolo_nome);
  return ptr;
 
}

tabeladesimolos * inicio_da_tabela ( char *simbolo_nome ){
  tabeladesimolos *ptr;
  for (ptr = t_simbolos; ptr != (tabeladesimolos *) 0;
       ptr = (tabeladesimolos *)ptr->prox)
    if (strcmp(ptr->nome,simbolo_nome) == 0)
      return ptr;
  return 0;

}
void imprimir_lista(struct tabeladesimolos *simbolos){
  
  while(simbolos != NULL){
    printf("%s\n",simbolos->nome);
    simbolos = simbolos->prox;
  }
}

void verifica_simbolo(char *simbolo_nome){  
  tabeladesimolos *s;
   s = inicio_da_tabela(simbolo_nome);
   if (s == 0){
        s = inserir_simbolo(simbolo_nome);
   }else { 
          printf("redeclaracao de '%s'\n",simbolo_nome );
		  yyerror(simbolo_nome);
   }
 //imprimir_lista(s);
}


void existe_simbolo(char *simbolo_nome ){ 
  if (inicio_da_tabela(simbolo_nome) == 0){
    printf("não declarado(a) a variavel "); 
     yyerror(simbolo_nome); 
  }
}

   //#### CODIGO PARA TRADUÇÃO DIRIGIDA PELA SINTAXE
    void montar_codigo_inicial(){
	    f = fopen("out.s","w+");
	    fprintf(f, ".text\n");
	    fprintf(f, "    .global _start\n\n");
      fprintf(f, "_start:\n\n");
    }

    void montar_codigo_final(){
	    fclose(f);
	    printf("Arquivo \"out.s\" gerado.\n\n");
    }

    void montar_codigo_retorno(){
       
	    fprintf(f, "    popq    %%rbx\n");
	    fprintf(f, "    movq    $1, %%rax\n");
	    fprintf(f, "    int     $0x80\n\n");
    }

     void montar_codigo_empilhamento(int num){
        fprintf(f, "# Codigo para empilhar o número %i\n", num);
	    fprintf(f, "    pushq   $%i\n\n", num);
	   
    }

    void montar_codigo_operacao(char op){
        fprintf(f, "# Codigo para operação de %c\n",op);
        fprintf(f, "    popq    %%rax\n");
        fprintf(f, "    popq    %%rbx\n");
        if(op == '+')
        fprintf(f, "    addq    %%rax, %%rbx\n");
        if(op == '-')
        fprintf(f, "    subq    %%rax, %%rbx\n");
        fprintf(f, "    pushq     %%rbx\n\n");
    }

%}

%union {
	int num; char *id;
	}
	

%token INT MAIN RETURN ABRE_PARENTESES FECHA_PARENTESES ABRE_CHAVES FECHA_CHAVES PONTO_E_VIRGULA

%token <num> NUM
%token <id> ID


%left '+' '-'



%%

programa : INT MAIN ABRE_PARENTESES FECHA_PARENTESES 
            ABRE_CHAVES { montar_codigo_inicial(); }
            corpo
            FECHA_CHAVES { montar_codigo_final(); }
            ;

corpo:  	 INT ID PONTO_E_VIRGULA {verifica_simbolo($2);} corpo	
          |ID '=' NUM PONTO_E_VIRGULA    {existe_simbolo($1);} corpo
        	|RETURN expr PONTO_E_VIRGULA {montar_codigo_retorno();} corpo
        	| 
        	;

expr: 	expr '+' expr 	        {montar_codigo_operacao('+');    }
	|	    expr '-' expr 	        {montar_codigo_operacao('-');    }
	| 	  NUM 			        {montar_codigo_empilhamento($1); }
	;


%%           
int main () {

	yyparse();
	printf("Entrada Reconhecida \n");
	return 0;
	
}