module CALLCC-SYNTAX
  imports DOMAINS-SYNTAX

  syntax Val ::= Int | Bool
  syntax Exp ::= Val
// Basic lambda-calculus syntax
               | Id
               | "lambda" Id "." Exp
               | Exp Exp              [strict, left]
               | "(" Exp ")"          [bracket]
// Arithmetic
               > "-" Int
               | Exp "*" Exp          [strict, left]
               | Exp "/" Exp          [strict]
               > Exp "+" Exp          [strict, left]
               > Exp "<=" Exp         [strict]
// Other functional constructs
  syntax Exp ::= "if" Exp "then" Exp "else" Exp  [strict(1)] // Conditional
               | "let" Id "=" Exp "in" Exp [macro]           // Let binder
               | "letrec" Id Id "=" Exp "in" Exp [macro]     // Letrec
               | "mu" Id "." Exp                             // Mu
               | "callcc" Exp  [strict]                      // Callcc


  syntax Id ::= "$exit" [token]
              | "$dummy" [token]
              | "$f" [token]
              | "$k" [token]

  syntax Exp ::= "callCC" Exp [macro]

  rule callCC E:Exp =>
    let $f = E in
      callcc (lambda $k .
        ($exit (lambda $dummy . ($f $k))))

endmodule


module CALLCC
  imports CALLCC-SYNTAX
  imports DOMAINS

  syntax KResult ::= Val

  configuration <T color="yellow">
                  <k color="green">
                    (callcc (lambda $exit .
                      (lambda $dummy . $PGM:Exp))) 0
                  </k>
                  <env color="blue"> .Map </env>
                  <store color="red"> .Map </store>
                </T>

  syntax Val ::= closure(Map,Id,Exp)

  rule <k> lambda X:Id . E => closure(Rho,X,E) ...</k>
       <env> Rho </env>
  rule <k> closure(Rho,X,E) V:Val => E ~> Rho' ...</k>
       <env> Rho' => Rho[X <- !N] </env>
       <store>... .Map => (!N:Int |-> V) ...</store>
  rule <k> X => V ...</k>
       <env>... X |-> N ...</env>
       <store>... N |-> V ...</store>

  rule <k> _:Val ~> (Rho => .K) ...</k> <env> _ => Rho </env>

  rule - I => 0 -Int I
  rule I1 * I2 => I1 *Int I2
  rule I1 / I2 => I1 /Int I2
  rule I1 + I2 => I1 +Int I2
  rule I1 <= I2 => I1 <=Int I2

  rule if true  then E else _ => E
  rule if false then _ else E => E

  rule let X = E in E':Exp => (lambda X . E') E

  rule letrec F:Id X = E in E' => let F = mu F . lambda X . E in E'

  syntax Exp ::= muclosure(Map,Exp)
  rule <k> mu X . E => muclosure(Rho[X <- !N], E) ...</k>
       <env> Rho </env>
       <store>... .Map => (!N:Int |-> muclosure(Rho[X <- !N], E)) ...</store>
  rule <k> muclosure(Rho,E) => E ~> Rho' ...</k>
       <env> Rho' => Rho </env>

  syntax Val ::= cc(Map,K)
  rule <k> (callcc V:Val => V cc(Rho,K)) ~> K </k> <env> Rho </env>
  rule <k> cc(Rho,K) V:Val ~> _ =>  V ~> K </k> <env> _ => Rho </env>
endmodule
