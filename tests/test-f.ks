{
  local foo is 0.
  global put is {parameter f.set foo to f.}.
  runPath("0:/lib/mission-value.ks").
  print foo(lex(),"foo",Kerbin).
  print foo(lex(),"foo",0).
}