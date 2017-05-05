{
  local _0106 is g00_02("p/01 06.ks").
  local _fd1e is g00_02("p/fd 1e.ks").
  local bdy is Minmus.
  local prkObt is Lex(
    "inc",bdy:obt:inclination,
    "lan",bdy:obt:longitudeOfAscendingNode,
    "sma",Kerbin:radius+100000
  ).
  local tstObt is Lex(
    "sma",3463330
  ).
  local tgtObt is Lex(
    "bdy",bdy,
    "inc",0,
    "ecc",0.21778922849617696,
    "sma",607236.108608967393,
    "lan",231.44898106851809,
    "aop",79.614952113553571
  ).
  local idl is {lock steering to lookDirUp(sun:position,prograde:vector)._fd1e().}.
  //local idl2 is {g00_03("BLAH BLAH")._0106().g00_03("BLAH BLAH").}.
  g00_01(Lex(
    "upper stage",List(
      Lex(
        "cmd","lch",
        "obt",tstObt
//      ),Lex(
//        "cmd","tm1",
//        "obt",tgtObt
      ),Lex(
        "cmd","stg"
//      ),
//      Lex(
//        "cmd","atv"
//      ),
//      Lex(
//        "cmd","tm3",
//        "obt",tgtObt
      )
    ),
    "payload",List(
      Lex(
        "cmd","nop",
        "idl",_0106@
      ),
//      Lex(
//        "cmd","tm2",
//        "obt",tgtObt,
//        "idl",idl@
//      ),
//      Lex(
//        "cmd","om2",
//        "obt",tgtObt,
 //       "idl",idl@
 //     ),
      Lex(
        "cmd","om1",
 //       "obt",tgtObt,
        "obt",tstObt,
        "idl",idl@
      )
    )
  )).
}