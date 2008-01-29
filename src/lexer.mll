{
  open Parser
  open Lexing

  let incrline lexbuf =
    lexbuf.lex_curr_p <- {
        lexbuf.lex_curr_p with
          pos_bol = lexbuf.lex_curr_p.pos_cnum ;
          pos_lnum = 1 + lexbuf.lex_curr_p.pos_lnum }
}

let number = ['0'-'9'] +
let name = ['A' - 'Z' 'a'-'z' '_' '/' '0'-'9' '\'' '?'] +
let blank = ' ' | '\t' | '\r'

rule token = parse
| '%' [^'\n'] * '\n' { incrline lexbuf; token lexbuf }
| blank              { token lexbuf }
| '\n'               { incrline lexbuf; token lexbuf }

| "=>"               { IMP }
| ":-"               { DEF }
| ","                { COMMA }
| "."                { DOT }
| "\\"               { BSLASH }
| "("                { LPAREN }
| ")"                { RPAREN }
| "|-"               { TURN }
| "::"               { CONS }
| "="                { EQ }

| ":"                { COLON }
| "->"               { RARROW }
| "forall"           { FORALL }
| "nabla"            { NABLA }
| "exists"           { EXISTS }
| "*"                { STAR }
| "@"                { AT }
| "Theorem"          { THEOREM }
| "Axiom"            { AXIOM }
| "Def"              { DEF }
| "\\/"              { OR }
| "/\\"              { AND }
| "{"                { LBRACK }
| "}"                { RBRACK }

| "induction"        { IND }
| "apply"            { APPLY }
| "inst"             { INST }
| "cut"              { CUT }
| "case"             { CASE }
| "search"           { SEARCH }
| "to"               { TO }
| "with"             { WITH }
| "on"               { ON }
| "split"            { SPLIT }
| "unfold"           { UNFOLD }
| "intros"           { INTROS }
| "skip"             { SKIP }
| "abort"            { ABORT }
| "undo"             { UNDO }
| "assert"           { ASSERT }
| "keep"             { KEEP }
| "clear"            { CLEAR }

| number as n        { NUM (int_of_string n) }
| name as n          { ID n }

| eof                { EOF }
