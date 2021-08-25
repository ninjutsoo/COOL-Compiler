
(*
 *  execute "coolc bad.cl" to see the error messages that the coolc parser
 *  generates
 *
 *  execute "myparser bad.cl" to see the error messages that your parser
 *  generates
 *)

(* error:  z is not a type identifier *)
class z {
};

(* no error *)
class A {
};

(* error:  b is not a type identifier *)
Class b inherits A {
};

(* error:  a is not a type identifier *)
Class C inherits a {
};

(* some errors in features *)
class D inherItS A{
  meth_1 () : String {
    BadContent
  };
  pro2 : Int;
  pr : nonType;
  propaim : String <- "";

  (* some errors in block *)
  feature_main_method () : Object {
    {
      1 + 2;
      isvoi test;
      force;
      37 <- 38;
      power <- 42;

      (* some errors in let *)
      let X : Int <- 1, y : Int <- 2, z : int <- 3, w : String <- "", v : string in w + 3;
    }
  };

};

(* error:  keyword inherits is misspelled *)
Class E inherts A {
};

(* error:  closing brace is missing *)
Class F inherits A {
;
