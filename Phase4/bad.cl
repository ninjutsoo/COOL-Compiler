(* my bad.cl *)
(************	MohammadAmin Roshani - 610396104	************)


(*******************************************************************)
(********************			CLASSES 		********************)
(*******************************************************************)

(*UNDEFINED_PARENT_NAME*)

    Class A inherits NO_CLASS {};

(*REDEFINE_CLASS*)

    Class A {};
	Class A {};

(*REDEFINE_BASIC_CLASS*)
	
	Class Object {};
	Class IO {};
	Class String {};
	Class Bool {};

(*BAD_CYCLIC_CLASSES*)

    Class A inherits B {};
    Class B inherits C {};
    Class C inherits A {};

(*INHERIT_FROM_INT_STRING_BOOL*)

    Class InheritFromBasic0 inherits Int {};
    Class InheritFromBasic1 inherits String {};
    Class InheritFromBasic2 inherits Bool {};

(*******************************************************************)
(********************			METHODS 		********************)
(*******************************************************************)

(*UNDEFINED_FORMAL_PARAMETER*)

Class A {
    method0 (formal0 : Int, formal1 : X) : Int {0};
};

(*FORMAL_METHOD_SELF*)

Class A {
    method0 (formal0 : Int, self : Int) : Int {0};
};

(*UNDEFINED_RETURN_TYPE*)

Class A {
    method0 (formal0 : Int, formal1 : Int) : X {0};
};

(*REDEFINE_METHOD_NOT_EQUAL_FORMALS_NUMBERS*)

Class X {
    method0 (formal0 : Int) : String {0};
    };
Class Y inherits X {
    method0 (formal0 : Int, formal1 : String) : Int {0};
    };

(*REDEFINE_METHOD_NOT_EQUAL_FORMALS_TYPE*)

Class X {
    method0 (formal0 : Int, formal1 : Int) : Int {0};
    };
Class Y inherits X {
    method0 (formal0 : Int, formal1 : String) : Int {0};
    };

(*METHOD_FORMALS_SAME_NAME*)

Class X {
    method0 (formal0 : Int, formal0 : Int) : Int {0};
    };

(*METHOD_TYPE_DISMATCH*)

Class X {
    method0 (formal0 : Int, formal0 : Int) : String {0};
    };

(*METHOD_SELFTYPE_USE*)

Class X {
    method0 (formal0 : Int, formal0 : SELF_TYPE) : String {0};
    };

(*******************************************************************)
(********************      	ATTRIBUTES 		    ********************)
(*******************************************************************)

(*ASSIGN_SELF_USE*)

Class A {
    self : SELF_TYPE;
    attr1 : SELF_TYPE;
};

(*REDEFINE_ATTRIBUTE*)

Class A {
    A : Int;
    A : String;
};


(*******************************************************************)
(********************      	ASSIGN  		    ********************)
(*******************************************************************)

(*ASSIGN_TO_SELFTYPE*)

Class A {
	a : SELF_TYPE
	a <- 2;
};

(*ASSIGN_TO_SELF*)

Class A {
	self <- 3;
};


(*******************************************************************)
(********************     STATIC_DISPATCH       ********************)
(*******************************************************************)

(*DISMATCH_TYPE_DISPATCH*)

Class A {
    method0 (formal: Int) : String {"0"};
};
Class B inherits A {
    method0 (formal: Int) : Int {5};
    attr1 : Int <- attr0@A.method0(5);
};

(*DISPATCH_TO_UNDEFINED_METHOD*)

Class A {
    method1 (formal: Int) : String {"0"};
};
Class B inherits A {
    method0 (formal: Int) : Int {5};
    attr1 : Int <- attr0@A.method0(5);
};


(*******************************************************************)
(********************         DISPATCH          ********************)
(*******************************************************************)

(*DISPATCH_TO_UNDEFINED_METHOD*)

Class B {
    method0 (formal: Int) : Int {5};
    attr1 : Int <- attr0method0(5);
};

(*******************************************************************)
(********************           COND            ********************)
(*******************************************************************)

(*NOT_BOOL_PRED*)

Class A {
    attr0 : Int;
    attr1 : Object <- if attr0 then attr2 else attr3 fi;
};

(*******************************************************************)
(********************           LOOP            ********************)
(*******************************************************************)

(*NOT_BOOL_PRED*)

Class A {
    attr0 : Int;
    attr1 : Object <- while attr0 loop attr2 pool;
};

(*******************************************************************)
(********************         TYPE_CASE         ********************)
(*******************************************************************)

(*SAME_TYPE_CASES*)

Class A {
    attr1 : Object <- case attr0 of attr1:Int => 5; attr2:Int => 5; esac;

(*SELF_USE*)

Class A {
    attr1 : Object <- case self of attr1:Int => 5; attr2:Int => 5; esac;

(*******************************************************************)
(********************            LET            ********************)
(*******************************************************************)

(*TYPE_EXPT_ERROR*)

Class A {
    attr1 : X <- let attr3: Int in 5;
};

(*******************************************************************)
(********************          ARITH            ********************)
(*******************************************************************)

(*NO_INT_TYPE*)

Class ArtithClass {
    attr0 : Bool;
    attr1 : String;
    attr2 : Int <- attr0 * attr1;
};

(*OTHERS ARE THE SAME*)

(*******************************************************************)
(********************          NEW              ********************)
(*******************************************************************)

(*NEW_TYPE_ERROR*)

Class ArtithClass {
	new X;
};



