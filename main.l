%option noyywrap
%option yylineno

%top{
    #include"common.h"
}
%{  
    string get_id_cnt(string id){
        map<string,int>::iterator it = words_list.find(id);
        if (it == words_list.end()) {
           return "0";
        }else
           return to_string(it->second);
    }
    void update_words_list(string id_content){
        cout<<"------------id:"<<id_content<<endl;
        map<string,int>::iterator it = words_list.find(id_content);
        cout<<"update_front:it->first:"<<it->first<<",it->second:"<<it->second<<endl;
        if (it == words_list.end()) {
            cout<<"not find"<<endl;
            words_list.insert(make_pair(id_content, 1));
        }else{
            int new_cnt = it->second+1;
            cout<<"new_cnt"<<new_cnt<<endl;
            words_list[id_content] = new_cnt;
        } 
         cout<<"update_back:it->first:"<<it->first<<", it->second:"<<it->second<<endl;
    }
    string oct2dec(string oct_str){
      if(oct_str.length()<=1)
        return oct_str;
      int all=0;
      for(int i=1;i<oct_str.length();i++){//avoid 0
        all=all*8;
        all=all+(oct_str[i]-'0');
      }
      return to_string(all);
    }
    string hex2dec(string hex_str){
      if(hex_str.length()<=2)
        return hex_str;
      int all=0;
      for(int i=2;i<hex_str.length();i++){//avoid 0x
        all=all*16;
        if(isdigit(hex_str[i])){
          all=all+(hex_str[i]-'0');
          }
        else{
          all=all+(hex_str[i]-'A'+10);
        }
      }
      return to_string(all);
    }
   
%}
COMMENT_BEGIN  "/**"|"/*"
COMMENT_ELE  .|\n
COMMENT_END  "*/"
%x COMMENT
LINE_COMMENT  "//".*


EQ  "=="
ASSIGN "="
DIV  "/"
LESS "<"
GREATER  ">"
LEQ  "<="
GEQ  ">="
NEQ  "!="
SEMICOLON  ;


DECI_INT [1-9]{DIGIT}*|DIGIT
OCT_INT  0{DIGIT}+
HEX_INT  0x[0-9A-F]*
SIGNED_INT ("+"|"-")?{DECI_INT}
STR_VAL = \".*\"
CHAR_VAL = \'.\'
BOOL_VAL = "true"|"false"

DIGIT [0-9]
ADD_EQ  "+="
MINUS_EQ  "-="
MUL_EQ  "*="
DIV_EQ  "/="
ADD "+"
MINUS  "-"
MUL  "*"
AND  "&&"
OR  "||"
BIT_AND  "&"
BIT_OR  "|"
BIT_NOT  "!"
MODE  "%"

INT "int"
CHAR_DEF "char"
STR_DEF "string"
BOOL_DEF "bool"
IF "if"
ELSE "else"
WHILE "while"
RETURN  "return"  
FOR "for"
BREAK  "break"
CONTINUE  "continue"

LRBRACE  "{"
RRBRACE  "}"
LPAREN  "("
RPAREN  ")"
LINE    "\n" 
PRINTF  "printf"
SCANF   "scanf"

SPACE  " "*
ID ({CHAR}|_)({CHAR}|_|{DIGIT})*
CHAR .
%%
{COMMENT_BEGIN} {BEGIN COMMENT;}
<COMMENT>{COMMENT_ELE} {}
<COMMENT>{COMMENT_END} {BEGIN INITIAL;}
{LINE_COMMENT}  {}



{ADD}  {return ADD;}
{MINUS}  {return MINUS;}
{MUL}  {return MUL;}
{DIV}  {return DIV;}
{ADD_EQ}  {return ADD_EQ;}
{MINUS_EQ}  {return MINUS_EQ;}
{MUL_EQ}  {return MUL_EQ;}
{DIV_EQ}  {return DIV_EQ;}
{EQ}  {return EQ;}
{LESS}  {return LESS;}
{GREATER}  {return GREATER;}
{LEQ}  {return LEQ;}
{GEQ}  {return GEQ;}
{NEQ}  {return NEQ;}
{AND}  {return AND;}
{OR}  {return OR;}
{BIT_AND}  {return BIT_AND;}
{BIT_OR}  {return BIT_OR;}
{BIT_NOT}  {return BIT_NOT;}
{MODE}  {return MODE;}
{ASSIGN}  {return ASSIGN;}
{SEMICOLON}  {return SEMICOLON;}


{DECI_INT}  {
  //print_format_parse("DECI_INT",yytext,yytext,yylineno);
  node->int_val = atoi(yytext);
  yylval = node;
  return INTEGER;
}
{OCT_INT}  {
  /*八进制计算*/
  //print_format_parse("OCT_INT",yytext,oct2dec(yytext),yylineno);
  tree_node *node = new tree_node(NODE_VAR,yylineno);
  node->int_val = atoi(oct2dec(yytext));
  yylval = node;
  return OCT_INT;
}
{HEX_INT}  {
  /*十六进制计算*/
  //print_format_parse("HEX_INT",yytext,hex2dec(yytext),yylineno);
  tree_node *node = new tree_node(NODE_VAR);
  node->int_val = atoi(hex2dec(yytext));
  yylval = node;
  return HEX_INT;  

}
{STR_VAL} {
  tree_node *node = new tree_node(NODE_VAR,yylineno);
  node->str_value = yytext;
  yylval = node;
  return STR_VAL;
}
{CHAR_VAL} {
  tree_node *node = new tree_node(NODE_VAR,yylineno);
  node->char_val = yytext;
  yylval = node;
  return CHAR_VAL;
}
{BOOL_VAL}  {
  tree_node *node = new tree_node(NODE_VAR,yylineno);
  if(yytext=="true)
    node->bool_val = true;
  else
    node->bool_val=false;
  yylval=node;
  return BOOL_VAL;
}

{CHAR_DEF}  {return CHAR_DEF;}
{STR_DEF}  {return STR_DEF;}
{BOOL_DEF}  {return BOOL_DEF;}
{INT}  {return INT;}

{SIGNED_INT}  {return SIGNED_INT;}
{DIGIT}  {return DIGIT;}
{LRBRACE}  {return LRBRACE;}
{RRBRACE}  {return RRBRACE;}
{LPAREN}  {return LPAREN;}
{RPAREN}  {return RPAREN;}
{PRINTF}  {return PRINTF;}
{SCANF}  {return SCANF;}

{IF}  {return IF;}
{ELSE}  {return ELSE;}
{WHILE}  {return WHILE;}
{RETURN}  {return RETURN;}
{FOR}  {return FOR;}
{BREAK}  {return BREAK;}
{CONTINUE}  {return CONTINUE;}

{SPACE}  {}
{ID}  {
  update_words_list(yytext);
  tree_node *node = new tree_node(NODE_VAR);
    node->var_name = string(yytext);
    yylval = node;
}
{LINE} {}
{CHAR}  {}



%%

int main(){
    cout<<setw(10)<<"符号"<<setw(10)<<"内容"<<setw(10)<<"属性"<<setw(10)<<"行号"<<endl;
    yyFlexLexer lexer;
    lexer.yylex();
    cout<<"------输出符号表------"<<endl;
    map<string, int>::iterator it;
    for (it = words_list.begin(); it != words_list.end(); ++it) {
      cout<<it->first<<"："<<to_string(it->second)<<endl;

    }
    return 0;

}