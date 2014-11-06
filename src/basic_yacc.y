%{
	#include<stdio.h>
	#include<string.h>
	#include<stdlib.h>
	int yylex(void);
	FILE *fPtr;
	int tempCounter=0;
	int labelCounter=0;
	char tVar[12];
	int labelIndex;
	int genTempIndex();
	int genLabelIndex();
%}

%start Program
%union{int ival; double dval; char str[120];}

/*Keywords*/
%token PRINT END LET INPUT
%token DO LOOP

/*Data type tokens*/
%token <ival> INTEGER
%token <dval> DOUBLE
%token <str> STRING_LITERAL
%token <str> VARIABLE
%token <str> NUM_VAR STR_VAR


/*Grammar's Variable(Non-terminal) types*/
%type <str> ArithmExpr

/*Operator Associativity and Precedence*/
%left	'-' '+'
%left	'*' '/'
%left	NEGATION
%right	'^'

%%

Program
	: Statements End {fprintf(fPtr,"exit\n");}
	
End
	: END
	| Empty

Statements
	: Statement Statements
	| Statement

Statement	
	: PRINT Output				{fprintf(fPtr,"PRINT \"\\n\"\n");}
	| LET Assignment
	| Assignment
	| INPUT NUM_VAR				{fprintf(fPtr,"SCAN %s\n",$2);}
	| INPUT STR_VAR				{fprintf(fPtr,"SCAN %s\n",$2);}
	| Loop
	



/*PRINTING SECTION BEGIN*/
Output
	: Output2 ArithmExpr		{fprintf(fPtr,"PRINT %s\n",$2);tempCounter=0;}
	| Output2 STRING_LITERAL	{fprintf(fPtr,"PRINT %s\n",$2);}
	| Output2 STR_VAR			{fprintf(fPtr,"PRINT %s\n",$2);}
	
Output2
	: Output ','				
	| Empty	
/*PRINTING SECTION END*/
	
/*VARIABLE SECTION BEGIN*/
Assignment
	: NUM_VAR '=' ArithmExpr		{fprintf(fPtr,"%s = %s\n",$1,$3);tempCounter=0;}
	| STR_VAR '=' STRING_LITERAL	{fprintf(fPtr,"%s = %s\n",$1,$3);}
/*VARIABLE SECTION BEGIN*/


/*ARITHMETIC SECTION BEGIN*/
ArithmExpr
	: ArithmExpr '^' ArithmExpr	{sprintf(tVar,"t%d",genTempIndex());strcpy($$,tVar);fprintf(fPtr,"%s=getNewTemp()\n",$$);fprintf(fPtr,"%s=%s^%s\n",$$,$1,$3);}
	| ArithmExpr '*' ArithmExpr	{sprintf(tVar,"t%d",genTempIndex());strcpy($$,tVar);fprintf(fPtr,"%s=getNewTemp()\n",$$);fprintf(fPtr,"%s=%s*%s\n",$$,$1,$3);}
	| ArithmExpr '/' ArithmExpr	{sprintf(tVar,"t%d",genTempIndex());strcpy($$,tVar);fprintf(fPtr,"%s=getNewTemp()\n",$$);fprintf(fPtr,"%s=%s/%s\n",$$,$1,$3);}
	| ArithmExpr '+' ArithmExpr	{sprintf(tVar,"t%d",genTempIndex());strcpy($$,tVar);fprintf(fPtr,"%s=getNewTemp()\n",$$);fprintf(fPtr,"%s=%s+%s\n",$$,$1,$3);}
	| ArithmExpr '-' ArithmExpr	{sprintf(tVar,"t%d",genTempIndex());strcpy($$,tVar);fprintf(fPtr,"%s=getNewTemp()\n",$$);fprintf(fPtr,"%s=%s-%s\n",$$,$1,$3);}
	| '-' ArithmExpr %prec NEGATION {sprintf(tVar,"t%d",genTempIndex());strcpy($$,tVar);fprintf(fPtr,"%s=getNewTemp()\n",$$);fprintf(fPtr,"%s=-1*%s\n",$$,$2);}
	| INTEGER					{sprintf($$,"%d",$1);}
	| NUM_VAR 				    {strcpy($$,$1);}
	| '(' ArithmExpr ')'		{strcpy($$,$2);}
/*ARITHMETIC SECTION END*/

/*RELATIONAL SECTION BEGIN*/

/*RELATIONAL SECTION END*/

/*LOOP CONSTRUCTS BEGIN */
Loop
	: DO{labelIndex=genLabelIndex();fprintf(fPtr,"l%d: ",labelIndex);}Statements LOOP	{fprintf(fPtr,"goto l%d\n",labelIndex);labelIndex--;}
/*LOOP CONSTRUCTS END*/

Empty:	; /*EPSILON*/

%%
int genTempIndex() {
	tempCounter++;
	return tempCounter;
}

int genLabelIndex() {
	labelCounter++;
	return labelCounter;
}

void yyerror (char const *s) {
	fprintf (stderr, "%s\n", s);
}

int main() {
	fPtr=stdout;
	yyparse();
	return 0;
}
