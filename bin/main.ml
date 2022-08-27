open Libhelang

let _ = Sys.argv.(1) 
  |> open_in 
  |> Interpreter.eval_channel
