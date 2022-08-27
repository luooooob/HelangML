{
open Parser
}

let white = ['\n' '\t' '\r' ' ']+
let digit = ['0'-'9']
let int = '-'? digit+
let letter = ['a'-'z' 'A'-'Z']
let id = letter+

rule read = 
  parse
  | white { read lexbuf }
  | ";" { SEMI }
  | '|' { VBAR }
  | "u8" { U8 }
  | "*" { TIMES }
  | "+" { PLUS }
  | "-" { MINUS }
  | "(" { LPAREN }
  | ")" { RPAREN }
  | '[' { LSQB }
  | ']' { RSQB }
  | "=" { EQUALS }
  | "print" {PRINT}
  | id { ID (Lexing.lexeme lexbuf) }
  | int { INT (int_of_string (Lexing.lexeme lexbuf)) }
  | eof { EOF }
