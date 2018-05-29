{
  local _0106 is g00_02("p/01 06.ks").
  local _fd1e is g00_02("p/fd 1e.ks").
  local idl is{lock steering to lookDirUp(kerbin:position,prograde:vector)._fd1e().}.
  g00_01(Lex(
    "capsule",List(
      Lex(
        "cmd","nop",
        "idl",_0106@
      ),Lex(
        "cmd","tm4",
        "obt",Lex("bdy",Eve),
        "idl",idl@
      )
    )
  )).
}