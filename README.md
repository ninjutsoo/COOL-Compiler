# Compiler-Projects
## Phase 1
#### These are 3 set of assignments meant to be an introduction to COOL programming language.
## Phase 2
### lexer
this was the lexer phase for cool compiler.
lexer works az an scanner and tokenizer, that will recogonize each part.
we will start with the my defenitions part, I have an boolean named wrong_str
that it was for the first time I finished the project for changing the flag
when I see errors in the strings but I handled it with a conditon named "ESC".
i begin this condition when I see errors like null or too long screen so we 
will not come out until we see an \n (new-line) or ".
i have defined "rem_str" for my remaining room to store strings in string_buf.
at first as we know it is equal to MAX_STR_CONST (1025).
curr_lineno is a counter that increases with each newline, so we can show the 
line for tokens and errors.
i defined a function (write_str) that writes the string in the string_buf
using strncpy.each time that we write, we will but a null character "\0" end 
of that so the string table and parser know where is the end of it.
we also have a part to realize "too long string" error but it is built 
other where, this was for first time programing this and is not used.
next part we define regular expressions for keywords and identifiers, so 
we work with them in the next section properly.
we have 3 conditions, the purpose behind them is clean code and easily know 
where you are(it will work like a flag for each positon), in the comments
or strigns or code(body). the default for code(body) is INITIAL and the ESC
as I said in the comment is for when we see a null or too long error and we 
will escape from that just with /n or *. it is used not to lexing other part
of that.
we started with comments. first part of second section is for comments, and it's errors like EOF.
we have two kind of comments, first, ((**)) second, (--). secod part is for strings and it's the most important one cause of multiple  errors that it has. EOF, NULL, TOO LONG AND UNTERMINATED are their (brief :)) errors.
we have some exceptions for (backslash) such as \n or \f or ..., but for \(other characters) we ignore \.
after them we go for other patterns, most important one are objectid and typeid that the difference is at first index of them. every character that we didn't defined will show as an error.
## Phase 3
### parser
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
## Phase 4
### semantic analyzer

#### Why_Semantic_Analysis :
Semantic analysis is the task of ensuring that the declarations and statements of a program are semantically correct, i.e,
that their meaning is clear and consistent with the way in which control structures and data types are supposed to be used.

#### Main_Purpose:
1: Type inferring:
	going into AST and find the nodes and inferr the proper type to them, and then build up the type for parent nodes,
	(it's called bottom_up algorithm)
2: Type checking:
	it's the same algorithm (bottom_up algorithm), because each type for example for expression "e" is from the types of its
	subexpressions.

#### Code_Sections:
Install basic classes:
	it was handled by default and is including Object_class, IO_class, Int_class, Bool_class, Str_class.
Install classes:
	at the top of the code we defined a map(dictionary) for saving Classes by their name, named classTable.
	while we add them, also we look for Redefinition of self type, Redefinition of a class and inheritance from Int, Str, 
	Bool, SELF_TYPE.
Install methods:
	like classes (classTable), we define methodTable to collect all the attributes of a class by the name of class as the key.
	we also check for method multiple definition.
Get inheritance:
	we have 2 function in this name for returning the chain of ancestors of an class (from class to object).
	one will start searching with the name of class and one with the class.
Conform
	this is used to show if one type is subtype of another type, or not. if we find type2 in inheritance chain of type1, so
	type1 is subtype of type2.
LCA
	it's called LeastCommonAncestor, and like the name it is used to find the least common ancestor(i couldn't find a better 
	way to describe that :)). it is mostly used in COND and TYPECASE.
Check inheritance
	in this part we go through each class's ancestors to find if they're inherited from a non-existed parent or we have CYCLE.
	what we mean by that is that it should be a TREE and so a DAG, and we should show an error if we find a class in it's parents.
Check main
	to check whether we have class and attribute main defined.
Check methods
	to check method scope and attribute scope and the rule for Redefinition. (as it's complicated for methods)
Method check_type
	to check rules for "self" and the multiple definitoin of formal parameters and the type of return type.
Assign check_type
	we have to find the type definition of identifier in it's or outer scoops using lookup at Environment.
Static_dispatch check_type
	check the expression type and going through ancestors of T to find the method f and check for the conformation of types.
	expression type should be subtype of method type. and also actual parameters of method should be the subtype of formal.
Dispatch check_type
	almost like Static_dispatch but will start finding ancestors from type of expr.
Cond check_type
	the pred should be in type bool and also the return type is lca of then_exp and else_exp.
TypeCase check_type
	we should have distinct type definitions in cases, so we can use a vector to check that. and also the return type is lca 
	of all those cases.
Branch_class check_type
	as we enter a branch, we enter a new scope(like class, method, ...).
Let check_type
	in that init_type should be subtype of type_decl.
Some arithmatic check_type
	EASY.
Program_class
	main part of our program, where we call other functions like install methods. and we finally check for errors if they're greater
	than 0. to say "Compilation halted doe semantic errors.".

#### Extra:
- all of the types are subtype of object, so when we have type error and we want to continue the program we define the type as object.
- we type check all of the program in a recursive way, as we build up the leafs.

#### About good.cl and bad.cl:
as we have done most of the errors (main ones), so some of them will go in shadow of others, so for better results, it's better to comment
all the errors and just use the part that we want to check.

#### Why Design is good:
we have multiple passes and in each pass we handle some of the errors, so in each step we know where we are and what we do. the design is 
compatible with structures in cool-tree.h and we used them alot. 
## Phase 5
### code generation
Code generation is the last and final phase of a compiler. The objective of this phase is to allocate storage and generate relocatable machine code. It also allocates memory locations for the variable. On previous phases, we've done pretty big processes based on some rules. Lexer with Regular expressions, Parser with Context free grammers and Semantic based on Typing rules. Now we want to do and explain Code generation with help of Operational Semantic to avoid complexity.
For some basic forms we have Stack machine with accumulator.
Accumulator: $a0: holds result of last expression evaluation. $s0 holds a stored copy of “self”. $sp points to next location in stack (so $sp+4 is the top of the stack) $t0, $t1, ... are temporary registers.

#### Here we talk about some design decisions used in my code briefly

1. First we decide to generate code for strings, ints and booleans.

2. Start writing .data segment. The .data section is used to declare the memory region, where data elements are stored for the program. ( we also need tags in this part )

3. Start writing .text segment. This defines an area in memory that stores the instruction codes. This is also a fixed area. ( also to define global variables )

4. -code_preprocessing : We decide which class should get which tag, i.e., we let Object have tag 0, Int 2, Bool 3, Str 4, etc. The important invariant we must maintain in doing so is that, all of class A's offspring (children, grandchildren, etc) have a class tag greater than class A, and that non-ancestor has a class tag that's greater than A's, but less than any of A's ancestors.

5. -code_nametab : it makes class_nameTab with some properties mentioned in cool-runtime.pdf

6. -code_objTab : it makes class_objTab with some properties mentioned in cool-tuntime.pdf

7. -code_dispatch : to make a table for methods

8. We fill in the class object table, class dispatches sections, class prototypes sections, and object initializers as described in the runtime manual. For each of them, we simply iterate through the classes in order of their class tags and fill the appropiate sections. For fillign dispatch section for a given class, we recursivelly build off it's ancestors dispatch tables. Likewise for initializer sections.

9. -code_methods, ... : we start class initialization and store FP and SELF and with RA we try to go through ancestors for checking methods, ... . we fill in the code for all the methods of all the classes (except of course object, int, str, boolean, and io). This is straight forward if looked at recursively. We begin each method with a label, pushing fp, s0, ra to the stack, copying the a0 (self) to s0, then recursively generating the code for the body, popping back off the fp, s0, and ra from the stack, then popping off the passed in arguments from the stack, and lastly add a return statement.

#### for computing the code for the actual body expressions, the general idea based on operational semantic

1. For +, -, /, * operators, we comute the each side expression, copy one of the integer objects that resulted, modify it's value to the result of the appropriate operation, and keep this resulting object in $a0.

2. String, boolean, and int constants simply load the appropiate constant to $a0.

#### the instruction of Activation Record for Cgen

-	Return address
-	Old frame pointer
-	n arguments
-	NT(e) temporary locations

#### some data structures for this phase

-	class_method_offset : to save method offset for each class
-	class_attr_typeoffset : it saves both type and offset for each attribute
-	<Symbol, int> objectsize : it saves both class names and their number of attributes
