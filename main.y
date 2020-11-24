%{
    #include"common.h"
    #define YYSTYPE tree_node *
    tree_node * root;
    extern int line_no;
    
    int yylex();
    int yyerror( char const * );
%}
%defines

%start program

%token ID DECI_INT OCT_INT HEX_INT SIGNED_INT STR_VAL CHAR_VAL BOOL_VAL SPACE CHAR
%token INT CHAR_DEF STR_DEF BOOL_DEF IF ELSE WHILE RETURN FOR BREAK CONTINUE 
%token LRBRACE RRBRACE LPAREN RPAREN LINE SEMICOLON
%token EQ ASSIGN DIV LESS GREATER LEQ GEQ NEQ 
%token DIGIT ADD_EQ MINUS_EQ MUL_EQ DIV_EQ ADD MINUS MUL AND OR BIT_AND BIT_OR BIT_NOT MODE 
%token PRINTF SCANF
%token COMMENT_BEGIN COMMENT_ELE COMMENT_END LINE_COMMENT 

%right NOT
%left ADD
%left EQUAL
%right ASSIGN
%nonassoc LOWER_THEN_ELSE
%nonassoc ELSE 
%%
program
    : statements {root=new tree_node(NODE_PROG);root->add_child_node($1);}
    ;
statements
    : statement {$$=$1;}
    | statements statement{$$=$1;$$->add_sibling_node($2);}
    ;
statement
    : instruction {$$=$1;}
    | if_else {$$=$1;}
    | while {$$=$1;}
    | LBRACE statements RBRACE {$$=$2;}
    ;
if_else
    : IF bool_statment statement %prec LOWER_THEN_ELSE {
        tree_node *node=new tree_node(NODE_STMT);
        node->stp=STMT_IF;
        node->add_child_node($2);
        node->add_child_node($3);
        $$=node;
    }
    | IF bool_statment statement ELSE statement {
        tree_node *node=new tree_node(NODE_STMT);
        node->stp=STMT_IF;
        node->add_child_node($2);
        node->add_child_node($3);
        node->add_child_node($5);
        $$=node;
    }
    ;
while
    : WHILE bool_statment statement {
        tree_node *node=new tree_node(NODE_STMT);
        node->stp=STMT_WHILE;
        node->add_child_node($2);
        node->add_child_node($3);
        $$=node;
    }
    ;
bool_statment
    : LPAREN bool_expr RPAREN {$$=$2;}
    ;
instruction
    : type ID ASSIGN expr SEMICOLON {
        tree_node *node=new tree_node(NODE_STMT);
        node->stp=STMT_DECL;
        node->add_child_node($1);
        node->add_child_node($2);
        node->add_child_node($4);
        $$=node;
    }
    | ID ASSIGN expr SEMICOLON {
        tree_node *node=new tree_node(NODE_STMT);
        node->stp=STMT_ASSIGN;
        node->add_child_node($1);
        node->add_child_node($3);
        $$=node;  
    }
    | printf SEMICOLON {$$=$1;}
    | scanf SEMICOLON {$$=$1;}
    ;
printf
    : PRINTF LPAREN expr RPAREN {
        tree_node *node=new tree_node(NODE_STMT);
        node->stp=STMT_PRINTF;
        node->add_child_node($3);
        $$=node;
    }
    ;
scanf
    : SCANF LPAREN expr RPAREN {
        tree_node *node=new tree_node(NODE_STMT);
        node->stp=STMT_SCANF;
        node->add_child_node($3);
        $$=node;
    }
    ;
bool_expr
    : TRUE {$$=$1;}
    | FALSE {$$=$1;}
    | expr EQUAL expr {
        tree_node *node=new tree_node(NODE_OP);
        node->opt=OP_EQUAL;
        node->add_child_node($1);
        node->add_child_node($3);
        $$=node;
    }
    | NOT bool_expr {
        tree_node *node=new tree_node(NODE_OP);
        node->opt=OP_NOT;
        node->add_child_node($2);
        $$=node;        
    }
    ;
expr
    : ID {$$=$1;}
    | INTEGER {$$=$1;}
    | expr ADD expr {
        tree_node *node=new tree_node(NODE_OP);
        node->opt=OP_ADD;
        node->add_child_node($1);
        node->add_child_node($3);
        $$=node;   
    }
    ;
type
    : INT {
        tree_node *node=new tree_node(NODE_TYPE);
        node->varType=VAR_INTEGER;
        $$=node; 
    }
    | VOID {
        tree_node *node=new tree_node(NODE_TYPE);
        node->varType=VAR_VOID;
        $$=node;         
    }
    ;

%%