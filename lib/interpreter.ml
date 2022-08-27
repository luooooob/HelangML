open Ast

exception UnboundValueException
exception UnsupportedOperationException
exception MutationSyntaxErrorException
(* exception IfGuardErrException *)

module Context = struct
  type 'a t = (string * 'a) list

  let empty = []
  let lookup = List.assoc_opt
  let extend k v t = (k, v) :: t
end

type value =
  | HLV_Num of int
  | HLV_Arr of int list
  | HLV_Unit of value Context.t

let string_of_he_value = function
  | HLV_Arr(l) -> l |> List.map string_of_int |> String.concat " | "
  | HLV_Num(n) -> n |> string_of_int
  | HLV_Unit(_) -> "<Nil>"

let string_of_ast_type = function 
| Num(_) -> "num"
| Arr(_) -> "arr"
| Var(_) -> "var"
| Binop(_, _, _) -> "binop"
| U8 (_, _) -> "u8"
| Print(_) -> "print"
| Mut(_, _) -> "mut"
| MutA(_,_,_) -> "mutA"
(* open Ast *)

let eval_expr env e = 
  let calc  = function
    | Add, HLV_Arr l1, HLV_Num n2 -> HLV_Arr (List.map (fun (l1x) -> l1x + n2) l1)
    | Minus, HLV_Arr l1, HLV_Num n2 -> HLV_Arr (List.map (fun (l1x) -> l1x - n2) l1)
    | Mult, HLV_Arr l1, HLV_Num n2 -> HLV_Arr (List.map (fun (l1x) -> l1x * n2) l1)
    | Add, HLV_Num n1, HLV_Num n2 -> HLV_Num (n1 + n2)
    | Minus, HLV_Num n1, HLV_Num n2 -> HLV_Num (n1 - n2)
    | Mult, HLV_Num n1, HLV_Num n2 -> HLV_Num (n1 * n2)
    | _, _, _ -> raise UnsupportedOperationException
  in
  let rec eval_expr_aux env = function
  | Num a -> HLV_Num a
  | Arr a -> HLV_Arr a
  | Var x -> (match Context.lookup x env with 
    | Some(v) -> v
    | None -> raise UnboundValueException)
  | Binop (bop, e1, e2) -> 
      let v1 = eval_expr_aux env e1 in
      let v2 = eval_expr_aux env e2 in
      calc (bop, v1, v2)
  | U8 (x, e) ->
      let v = eval_expr_aux env e in
      HLV_Unit(Context.extend x v env)
  | Print(e) -> e |>eval_expr_aux env |> string_of_he_value |> print_endline; HLV_Unit(env)
  | Mut(x, e) -> 
    let v = eval_expr_aux env e in
    HLV_Unit(Context.extend x v env)
  | MutA(x, e1, e2) -> 
      let cv = match Context.lookup x env with 
        | Some(cv) -> cv
        | None -> raise UnboundValueException 
      in
      let v1 = eval_expr_aux env e1 in
      let v2 = eval_expr_aux env e2 in
      (match(cv, v2) with 
      | (HLV_Arr(cv), HLV_Num(n)) -> 
        let is = (match v1 with 
          | HLV_Arr(is) -> is
          | HLV_Num(i) -> [i]
          | _ -> raise MutationSyntaxErrorException)
        in
        let arr_v = Array.of_list cv in 
        let _ = List.map (fun x -> Array.set arr_v x n) is in
        let v2 = HLV_Arr(Array.to_list arr_v) in
        HLV_Unit(Context.extend x v2  env)
        (* let mutv = List.map (fun x -> list.map ) in *)
      | (_, _)-> raise MutationSyntaxErrorException)
    in
    eval_expr_aux env e

let eval prog =
  let eval_aux (env, _) e = match(eval_expr env e) with 
    | HLV_Unit(uenv) as v -> (uenv, v)
    | v -> (env, v)
  in
  List.fold_left eval_aux (Context.empty, HLV_Unit(Context.empty)) prog

let eval_string s = s 
  |> Lexing.from_string
  |> (Parser.main @@ Lexer.read) 
  |> eval 

let eval_channel s = s 
  |> Lexing.from_channel
  |> (Parser.main @@ Lexer.read)
  |> eval  