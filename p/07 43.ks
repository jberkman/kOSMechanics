{
  local _0301 is g00_02("p/03 01.ks").
  local _0408 is g00_02("p/04 08.ks").
  local _fd07 is g00_02("p/fd 07.ks").
  local _fd19 is g00_02("p/fd 19.ks").
  local _fd27 is g00_02("p/fd 27.ks").
  g00_01({parameter m.
    _fd07({parameter seq,ev,next.
      g00_03("PGM 07 43").
      local pgm is _fd27:bind(seq,next@).
      local g is _fd19:bind(m).
      local o is _fd19:bind(g("obt",Lex())).
      pgm(_0408@,List(o("bdy",Kerbin)),g("idl",{})).
      pgm(_0301@,List({parameter x.},g("wrp",1))).
    })().
  }).
}