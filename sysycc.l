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
    void print_format_parse(string a,string b,int c){
      cout<<setw(10)<<a<<setw(10)<<b<<setw(10)<<""<<setw(10)<<to_string(c)<<endl;
    }
    void print_format_parse(string a,string b,string val,int c){
      cout<<setw(10)<<a<<setw(10)<<b<<setw(10)<<val<<setw(10)<<to_string(c)<<endl;
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

SPACE  " "*
ID ({CHAR}|_)({CHAR}|_|{DIGIT})*
CHAR [a-zA-Z]
%%
{COMMENT_BEGIN} {BEGIN COMMENT;}
<COMMENT>{COMMENT_ELE} {}
<COMMENT>{COMMENT_END} {BEGIN INITIAL;}
{LINE_COMMENT}  {}



{ADD}  {print_format_parse("ADD",yytext,yylineno);}
{MINUS}  {print_format_parse("MINUS",yytext,yylineno);}
{MUL}  {print_format_parse("MUL",yytext,yylineno);}
{DIV}  {print_format_parse("DIV",yytext,yylineno);}
{ADD_EQ}  {print_format_parse("ADD_EQ",yytext,yylineno);}
{MINUS_EQ}  {print_format_parse("MINUS_EQ",yytext,yylineno);}
{MUL_EQ}  {print_format_parse("MUL_EQ",yytext,yylineno);}
{DIV_EQ}  {print_format_parse("DIV_EQ",yytext,yylineno);}
{EQ}  {print_format_parse("EQ",yytext,yylineno);}
{LESS}  {print_format_parse("LESS",yytext,yylineno);}
{GREATER}  {print_format_parse("GREATER",yytext,yylineno);}
{LEQ}  {print_format_parse("LEQ",yytext,yylineno);}
{GEQ}  {print_format_parse("GEQ",yytext,yylineno);}
{NEQ}  {print_format_parse("NEQ",yytext,yylineno);}
{AND}  {print_format_parse("AND",yytext,yylineno);}
{OR}  {print_format_parse("OR",yytext,yylineno);}
{BIT_AND}  {print_format_parse("BIT_AND",yytext,yylineno);}
{BIT_OR}  {print_format_parse("BIT_OR",yytext,yylineno);}
{BIT_NOT}  {print_format_parse("BIT_NOT",yytext,yylineno);}
{MODE}  {print_format_parse("MODE",yytext,yylineno);}

{ASSIGN}   {print_format_parse("ASSIGN",yytext,yylineno);}
{SEMICOLON}  {print_format_parse("SEMICOLON",yytext,yylineno);}
{DECI_INT}  {print_format_parse("DECI_INT",yytext,yytext,yylineno);}
{OCT_INT}  {print_format_parse("OCT_INT",yytext,oct2dec(yytext),yylineno);}
{HEX_INT}  {print_format_parse("HEX_INT",yytext,hex2dec(yytext),yylineno);}
{INT}  {print_format_parse("INT",yytext,yylineno);}
{SIGNED_INT}  {print_format_parse("SIGNED_INT",yytext,yytext,yylineno);}
{DIGIT}  {print_format_parse("DIGIT",yytext,yylineno);}
{LRBRACE}  {print_format_parse("LRBRACE",yytext,yylineno);}
{RRBRACE}  {print_format_parse("RRBRACE",yytext,yylineno);}
{LPAREN}  {print_format_parse("LPAREN",yytext,yylineno);}
{RPAREN}  {print_format_parse("RPAREN",yytext,yylineno);}

{IF}  {print_format_parse("IF",yytext,yylineno);}
{ELSE}  {print_format_parse("ELSE",yytext,yylineno);}
{WHILE}  {print_format_parse("WHILE",yytext,yylineno);}
{RETURN}  {print_format_parse("RETURN",yytext,yylineno);}
{FOR}  {print_format_parse("FOR",yytext,yylineno);}
{BREAK}  {print_format_parse("BREAK",yytext,yylineno);}
{CONTINUE}  {print_format_parse("CONTINUE",yytext,yylineno);}

{SPACE}  {}
{ID}  {
  update_words_list(yytext);
  print_format_parse("ID",yytext,get_id_cnt(yytext),yylineno);
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