{
  local _0301 is g00_02("p/03 01.ks").
  local _0306 is g00_02("p/03 06.ks").
  local _fd04 is g00_02("p/fd 04.ks").
  local _fd07 is g00_02("p/fd 07.ks").
  local _fd19 is g00_02("p/fd 19.ks").
  local _fd27 is g00_02("p/fd 27.ks").
  g00_01({parameter m.
    _fd07({parameter seq,ev,next.
      g00_03("PGM 07 24").
      local pgm is _fd27:bind(seq,next@).
      local g is _fd19:bind(m).
      local o is _fd19:bind(g("obt",Lex())).
      pgm(_0306@,List(_fd04(o("inc",0),0.5,179.5),o("lan",-1)),g("idl",{})).
      pgm(_0301@,List(next@,1)).
    })().
  }).
}