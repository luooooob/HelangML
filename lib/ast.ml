(** The type of binary operators. *)
type bop = 
  | Add
  | Minus
  | Mult

type arr = int list

(** The type of the abstract syntax tree (AST). *)
type expr =
  | Var of string
  | Num of int
  | Arr of int list
  | Binop of bop * expr * expr
  | Mut of string * expr
  | MutA of string * expr * expr
  | U8 of string * expr
  | Print of expr
