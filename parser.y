%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ast.h"    //  AST header
#include "symbol.h" // Symbol Table header
 


int yy_scan_string(const char *str);
extern int yylex(); // Lexical analyzer function
void yyerror(const char *s); // Error function

ASTNode *createIfElseNode(ASTNode *condition, ASTNode *thenBranch, ASTNode *elseBranch) {
    ASTNode *node = createBinaryNode("if_else", condition, thenBranch);
    node->right = elseBranch; // Link the else branch
    return node;
}

ASTNode *root; // Global variabe AST root
%}

%union {
    int num;
    char *id;
    struct ASTNode *ast;
}

%token <num> NUMBER
%token <id> IDENTIFIER
%token IF ELSE
%token EQ NE GE LE
%type <ast> expression term factor assignment statement conditional program /* block statement_list*/

%left '+' '-'
%left '*' '/'
%nonassoc UMINUS
%nonassoc '>' 
//%nonassoc '<' EQ NE GE LE
%nonassoc ELSE

%% // Grammar Rules

program:
    statement ';' {
        root = $1; 
    }/*
    | program statement ';' {
        $$ = root;
        root = createBinaryNode("sequence", root, $2);
    }*/
;

statement:
    expression {
        $$ = $1; 
    }
    | assignment {
        $$ = $1; 
    }
    | conditional {
        $$ = $1; 
    }/*
    | block {
        $$ = $1;
    }*/
;

assignment:
    IDENTIFIER '=' expression {
	insertSymbol($1, "int", 0);
        $$ = createBinaryNode("assign", createIdentifierNode($1), $3);
    }
    | IDENTIFIER '[' expression ']' '=' expression {
        insertSymbol($1, "int", 1);
        $$ = createBinaryNode("array_assign", createIdentifierNode($1), createBinaryNode("index", $3, $6));
    }
;

conditional:
    IF '(' expression ')' statement /* %prec ELSE */ {
        $$ = createIfElseNode($3, $5, NULL);
    }
    | IF '(' expression ')' statement ELSE statement {
        $$ = createIfElseNode($3, $5, $7);
    }
;
/*
block:
    '{' statement_list '}' {
          $$ = $2;
     }
;

statement_list:
    statement ';' {
        $$ = $1;
    }
    | statement_list statement ';' {
        $$ = createBinaryNode("sequence", $1, $2);
    }
;
*/
expression:
    expression '+' term {
        $$ = createBinaryNode("add", $1, $3);
    }
    | expression '-' term {
        $$ = createBinaryNode("sub", $1, $3);
    }
    | expression '*' term {
        $$ = createBinaryNode("mul", $1, $3);
    }
    | expression '/' term {
        $$ = createBinaryNode("div", $1, $3);
    }
    | expression '>' term {
        $$ = createBinaryNode("gt", $1, $3);
    }/*
    | expression '<' term {
        $$ = createBinaryNode("lt", $1, $3);
    }
    | expression EQ term {
        $$ = createBinaryNode("eq", $1, $3);
    }
    | expression NE term {
        $$ = createBinaryNode("ne", $1, $3);
    }
    | expression GE term {
        $$ = createBinaryNode("ge", $1, $3);
    }
    | expression LE term {
        $$ = createBinaryNode("le", $1, $3);
    }*/
    | term {
        $$ = $1;
    }
;


term:
    term '*' factor {
        $$ = createBinaryNode("mul", $1, $3);
    }
    | term '/' factor {
        $$ = createBinaryNode("div", $1, $3);
    }
    | factor {
        $$ = $1;
    }
;

factor:
    NUMBER {
        $$ = createTerminalNode("number", $1);
    }
    | IDENTIFIER {
        $$ = createIdentifierNode($1);
    }
    | '(' expression ')' {
        $$ = $2;
    }
    /*
    | IDENTIFIER '[' expression ']' {
        $$ = createBinaryNode("array_access", createIdentifierNode($1), $3);
    }
    | '-' factor %prec UMINUS {
        $$ = createUnaryNode("neg", $2);
    }*/
;

%% // Error Handling

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    printf("\nEnter your expressions (end with ; and type 'exit' to quit):\n");
    while (1) {
        char input[256];
        printf(">> ");
        if (fgets(input, sizeof(input), stdin) == NULL) {
            break; // Handle end of input
        }
        if (strcmp(input, "exit\n") == 0) {
            break; // Exit condition
        }
        yy_scan_string(input); // Pass the input to the lexer
        if (yyparse() == 0) {  // Call the parser
	 printSymbolTable();
            if (root != NULL) {
                printAST(root, 0); // Print the AST
            } else {
                printf("Error: syntax error\n");
            }
        }
    }
    return 0;
}

