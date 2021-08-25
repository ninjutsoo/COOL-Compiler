(*******************mohammad amin roshani - 610396104**********************)
This was the parser phase for cool compiler. we wrote it with an cpp tool called bison.
our assignment was to build an AST (abstract syntax tree), we will construct this AST using semantic actions of the parser generator. 
Parser is a syntactic analysor, it will get the input and while making AST, it checks that it is correct or not. we tried to make the correct forms using terminals and nonterminals, our start point (node) was program and we go through classes, features, formals, expressions and so on.
we define our types in %union, that means all the types that can be teh resulf of parsing.
then, we define tokens and it's numbers. then we make some types that we need them in this context free grammer. we use this types for non-terminals, such as program, class_list, class, feature_list, feature, formal_list, formal, expression, ... .
in the Precedence part, we define Precedence and Associativity, each rule at bottom, has priority to those which are top. main node is program, then we gon in class_list, that could make multiple classes. then feature_list and feature. the type that we pass to top or use in constructors is important, so, instead of NULL, we use nil_Features, for example, for type features, and single_Features and append_Features so on.
the expressions are the biggest part, for some cases that have (*) or (+), means they multiply, we use an other non-terminal (for example let_list, case_list).
expressions in two rules can be seprated, by ',' and by ';', I used expression_comma_list for first one and the expression_semic_list for other. $$ this is used for the value of node.
the last part is for error handling.
error handling in my code, is based on errors found in class, feature, let binding and an error in expression block ({}).
we know the parser should be recovered after detecting them, so in most parts we left the action part empty ({}).
if we see error, the parser will tell us the line, automatically.
now we have all the tokens from the lexer, our assignment is to build a tree using them and detect the correct and false grammer.
///////////////////////////////////////////
output of bad.cl
///////////////////////////////////////////
"bad.cl", line 11: syntax error at or near OBJECTID = z
"bad.cl", line 19: syntax error at or near OBJECTID = b
"bad.cl", line 23: syntax error at or near OBJECTID = a
"bad.cl", line 29: syntax error at or near TYPEID = BadContent
"bad.cl", line 32: syntax error at or near OBJECTID = nonType
"bad.cl", line 39: syntax error at or near OBJECTID = test
"bad.cl", line 41: syntax error at or near ASSIGN
"bad.cl", line 45: syntax error at or near TYPEID = X
"bad.cl", line 45: syntax error at or near OBJECTID = int
"bad.cl", line 45: syntax error at or near OBJECTID = string
"bad.cl", line 52: syntax error at or near OBJECTID = inherts
"bad.cl", line 57: syntax error at or near ';'
///////////////////////////////////////////



