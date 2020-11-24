#include"common.h"
tree_node *root=nullptr;
int main ()
{
    yyparse();
    if(root){
        root->create_node_id();
        root->print_tree_from_curr_node();
    }
}
int yyerror(char const* message)
{
  cout << message << endl;
  return -1;
}