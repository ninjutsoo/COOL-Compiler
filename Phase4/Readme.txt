(* ReadMe *)
(************	MohammadAmin Roshani - 610396104	************)

Phase : 
	Compiler / semantic analyzer

Why_Semantic_Analysis :
	Semantic analysis is the task of ensuring that the declarations and statements of a program are semantically correct, i.e,
 	that their meaning is clear and consistent with the way in which control structures and data types are supposed to be used.

Main_Purpose:
	1: Type inferring:
		going into AST and find the nodes and inferr the proper type to them, and then build up the type for parent nodes,
		(it's called bottom_up algorithm)
	2: Type checking:
		it's the same algorithm (bottom_up algorithm), because each type for example for expression "e" is from the types of its
		subexpressions.

Code_Sections:
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

Extra:
	- all of the types are subtype of object, so when we have type error and we want to continue the program we define the type as object.
	- we type check all of the program in a recursive way, as we build up the leafs.

About good.cl and bad.cl:
	as we have done most of the errors (main ones), so some of them will go in shadow of others, so for better results, it's better to comment
	all the errors and just use the part that we want to check.

Why Design is good:
	we have multiple passes and in each pass we handle some of the errors, so in each step we know where we are and what we do. the design is 
	compatible with structures in cool-tree.h and we used them alot. 

(********** bad.cl output **********)
mybad.cl:1: Class A was previously defined.
mybad.cl:1: Class A was previously defined.
mybad.cl:1: Class Object was previously defined.
mybad.cl:1: Class IO was previously defined.
mybad.cl:1: Class String was previously defined.
mybad.cl:1: Class Bool was previously defined.
mybad.cl:1: Class A was previously defined.
mybad.cl:1: Class InheritFromBasic0 cannot inherit class Int.
mybad.cl:1: Class InheritFromBasic1 cannot inherit class String.
mybad.cl:1: Class InheritFromBasic2 cannot inherit class Bool.
mybad.cl:1: Class A was previously defined.
mybad.cl:1: Class A was previously defined.
mybad.cl:1: Class A was previously defined.
mybad.cl:1: Class X was previously defined.
mybad.cl:1: Class Y was previously defined.
mybad.cl:1: Class X was previously defined.
mybad.cl:1: Class X was previously defined.
mybad.cl:1: Class X was previously defined.
mybad.cl:1: Class A was previously defined.
mybad.cl:1: Class A was previously defined.
mybad.cl:1: Class A was previously defined.
mybad.cl:1: Class A was previously defined.
mybad.cl:1: Class B was previously defined.
mybad.cl:1: Class A was previously defined.
mybad.cl:1: Class B was previously defined.
mybad.cl:1: Class B was previously defined.
mybad.cl:1: Class A was previously defined.
mybad.cl:1: Class A was previously defined.
mybad.cl:1: Class A was previously defined.
mybad.cl:1: Class A was previously defined.
mybad.cl:1: Class A was previously defined.
mybad.cl:1: Class ArtithClass was previously defined.
mybad.cl:1: Class A inherits from an undefined class NO_CLASS.
Compilation halted due to static semantic errors.

(********** good.cl output **********)
#1
_program
  #1
  _class
    Main
    IO
    "good.cl"
    (
    #1
    _method
      main
      SELF_TYPE
      #1
      _let
        c
        Complex
        #1
        _dispatch
          #1
          _new
            Complex
          : Complex
          init
          (
          #1
          _int
            1
          : Int
          #1
          _int
            1
          : Int
          )
        : Complex
        #1
        _cond
          #1
          _eq
            #1
            _dispatch
              #1
              _dispatch
                #1
                _object
                  c
                : Complex
                reflect_X
                (
                )
              : Complex
              reflect_Y
              (
              )
            : Complex
            #1
            _dispatch
              #1
              _object
                c
              : Complex
              reflect_0
              (
              )
            : Complex
          : Bool
          #1
          _dispatch
            #1
            _object
              self
            : SELF_TYPE
            out_string
            (
            #1
            _string
              "=)\n"
            : String
            )
          : SELF_TYPE
          #1
          _dispatch
            #1
            _object
              self
            : SELF_TYPE
            out_string
            (
            #1
            _string
              "=(\n"
            : String
            )
          : SELF_TYPE
        : SELF_TYPE
      : SELF_TYPE
    )
  #1
  _class
    Complex
    IO
    "good.cl"
    (
    #1
    _attr
      x
      Int
      #1
      _no_expr
      : _no_type
    #1
    _attr
      y
      Int
      #1
      _no_expr
      : _no_type
    #1
    _method
      init
      #1
      _formal
        a
        Int
      #1
      _formal
        b
        Int
      Complex
      #1
      _block
        #1
        _eq
          #1
          _object
            x
          : Int
          #1
          _object
            a
          : Int
        : Bool
        #1
        _eq
          #1
          _object
            y
          : Int
          #1
          _object
            b
          : Int
        : Bool
        #1
        _object
          self
        : SELF_TYPE
      : SELF_TYPE
    #1
    _method
      print
      Object
      #1
      _cond
        #1
        _eq
          #1
          _object
            y
          : Int
          #1
          _int
            0
          : Int
        : Bool
        #1
        _dispatch
          #1
          _object
            self
          : SELF_TYPE
          out_int
          (
          #1
          _object
            x
          : Int
          )
        : SELF_TYPE
        #1
        _dispatch
          #1
          _dispatch
            #1
            _dispatch
              #1
              _dispatch
                #1
                _object
                  self
                : SELF_TYPE
                out_int
                (
                #1
                _object
                  x
                : Int
                )
              : SELF_TYPE
              out_string
              (
              #1
              _string
                "+"
              : String
              )
            : SELF_TYPE
            out_int
            (
            #1
            _object
              y
            : Int
            )
          : SELF_TYPE
          out_string
          (
          #1
          _string
            "I"
          : String
          )
        : SELF_TYPE
      : SELF_TYPE
    #1
    _method
      reflect_0
      Complex
      #1
      _block
        #1
        _eq
          #1
          _object
            x
          : Int
          #1
          _neg
            #1
            _object
              x
            : Int
          : Int
        : Bool
        #1
        _eq
          #1
          _object
            y
          : Int
          #1
          _neg
            #1
            _object
              y
            : Int
          : Int
        : Bool
        #1
        _object
          self
        : SELF_TYPE
      : SELF_TYPE
    #1
    _method
      reflect_X
      Complex
      #1
      _block
        #1
        _eq
          #1
          _object
            y
          : Int
          #1
          _neg
            #1
            _object
              y
            : Int
          : Int
        : Bool
        #1
        _object
          self
        : SELF_TYPE
      : SELF_TYPE
    #1
    _method
      reflect_Y
      Complex
      #1
      _block
        #1
        _eq
          #1
          _object
            x
          : Int
          #1
          _neg
            #1
            _object
              x
            : Int
          : Int
        : Bool
        #1
        _object
          self
        : SELF_TYPE
      : SELF_TYPE
    )
