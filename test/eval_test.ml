open OUnit2
open Libhelang

let eval s = 
  let (_, v)  = Interpreter.eval_string s in 
  Interpreter.string_of_he_value v

let make_eval_cases name expected_output input =
  name >:: fun _ ->
  assert_equal expected_output (eval input) ~printer: (fun a ->a)

let tests =
  [
    make_eval_cases "int" "22" "22;";
    make_eval_cases "add" "22" "11+11;";
    make_eval_cases "adds" "22" "(10+1)+(5+6);";
    make_eval_cases "mul1" "22" "2*11;";
    make_eval_cases "mul2" "22" "2+2*10;";
    make_eval_cases "mul3" "14" "2*2+10;";
    make_eval_cases "mul4" "40" "2*2*10;";
    make_eval_cases "arr1" "1 | 1 | 4 | 5 | 1 | 4" "1 | 1 | 4 | 5 | 1 | 4;";
    make_eval_cases "arr2" "9 | 9 | 12 | 13 | 9 | 12" "1 | 1 | 4 | 5 | 1 | 4 + 8;";
    make_eval_cases "arr3" "1 | 1 | 7 | 5 | 1 | 4" "u8 x = 1 | 1 | 4 | 5 | 1 | 4;
    x[2] = 7;
    x;";
    make_eval_cases "arr4" "1 | 1 | 7 | 7 | 7 | 4" "u8 x = 1 | 1 | 4 | 5 | 1 | 4;
    x[2] = 7;
    x[ 2 | 3 | 4 ] = 7;
    x;";
    make_eval_cases "arr5" "9 | 10 | 11 | 12 | 13" "u8 y = 1 | 2 | 3 | 4 | 5 ;
    u8 z = y + 8;
    z;";
  ]

let _ = run_test_tt_main ("suite" >::: tests)