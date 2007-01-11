%{
  let strip_brackets str =
    String.sub str 1 ((String.length str) - 2)
    
  let parse_term str =
    let str = strip_brackets str in
      Parser.term Lexer.token (Lexing.from_string str)
%}

%token COMMA DOT RARROW FORALL STAR AT THEOREM
%token <string> ID
%token <string> TERM
%token EOF

%start lppterm top_command
%type <Lppterm.lppterm> lppterm
%type <Prover.top_command> top_command

%%

lppterm:
  | FORALL binding_list COMMA lppterm { Lppterm.forall $2 $4 }
  | object_term RARROW lppterm        { Lppterm.arrow $1 $3 }
  | object_term                       { $1 }

binding_list:
  | binding binding_list              { $1::$2 }
  | binding                           { [$1] }

binding:
  | ID                                { $1 }

object_term:
  | TERM                              { Lppterm.obj (parse_term $1) }
  | TERM stars                        { Lppterm.active_obj
                                          (parse_term $1) $2 }
  | TERM ats                          { Lppterm.inactive_obj
                                          (parse_term $1) $2 }

stars:
  | stars STAR                        { $1 + 1 }
  | STAR                              { 1 }

ats:
  | ats AT                            { $1 + 1 }
  | AT                                { 1 }
      
top_command:
  | THEOREM lppterm DOT               { Prover.Theorem($2) }