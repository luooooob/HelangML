%{
open Ast
%}

%token <int> INT
%token <string> ID
%token SEMI 
%token VBAR 
%token U8 
%token TIMES 
%token PLUS 
%token MINUS
%token LPAREN 
%token RPAREN 
%token LSQB 
%token RSQB 
%token EQUALS 
%token PRINT 
%token EOF

%right PRINT
%left EQUALS
%left MINUS PLUS
%left TIMES 

%type <Ast.arr> arr
%type <Ast.expr list> main
%type <Ast.expr list> seq
%type <Ast.expr> expr

%start main

%%

main:
  | seq EOF                        { $1 }
  | EOF                            { [] }

seq: 
  |expr SEMI seq                   { $1 :: $3 }
  | expr SEMI                      { [$1] }

expr:
	| ID                             { Var($1) }
	| INT                            { Num($1) }
	| arr                            { Arr(List.rev $1) }
	| expr MINUS expr                { Binop (Minus, $1, $3) } 
	| expr PLUS expr                 { Binop (Add, $1, $3) }
	| expr TIMES expr                { Binop (Mult, $1, $3) } 
	| ID EQUALS expr                 { Mut($1, $3) }
	| ID LSQB expr RSQB EQUALS expr  { MutA($1, $3, $6) }
	| U8 ID EQUALS expr              { U8($2, $4) }
	| PRINT expr                     { Print($2) }
	| LPAREN expr RPAREN             { $2 }

arr:
  | INT VBAR INT                   { $3::[$1] }
	| arr VBAR INT                   { $3::$1 }