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
    //"inc",153.95784979900768,
    "inc",27.95784979900768,
    "ecc",0.12913994987570568,
    "sma",417940.86524960113,
    "lan",200.2302538045823,
    "aop",247.77803605784555
  ).
  local idl is{lock steering to lookDirUp(sun:position,prograde:vector)._fd1e().}.
  local idl2 is{if hasNode lock steering to lookDirUp(nextNode:deltaV:ma,-up:vector).else lock steering to lookDirUp(prograde:vector,-up:vector)._fd1e().}.
  g00_01(Lex(
    "upper stage",List(
      Lex(
        "cmd","lch",
        "obt",prkObt
      ),Lex(
        "cmd","om1",
        "idl",idl2@
      ),Lex(
        "cmd","tm1",
        "idl",idl2@,
        "obt",tgtObt
      ),Lex(
        "cmd","stg"
      ),Lex(
        "cmd","tm3",
        "wrp",0,
        "obt",tgtObt
      ),Lex(
        "cmd","typ",
        "typ","Debris"
      ),Lex(
        "cmd","vsl",
        "vsl","Mission2 Probe"
      )
    ),
    "payload",List(
      Lex(
        "cmd","nop",
        "idl",_0106@
      ),Lex(
        "cmd","tm2",
        "obt",tgtObt,
        "idl",idl@
      ),
      Lex(
        "cmd","om4",
        "obt",tgtObt,
        "idl",idl@
      ),
      Lex(
        "cmd","om3",
        "obt",tgtObt,
        "idl",idl@
      )
    )
  )).
}