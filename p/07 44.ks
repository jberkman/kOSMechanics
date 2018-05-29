{
  local _0301 is g00_02("p/03 01.ks").
  local _030c is g00_02("p/03 0c.ks").
  local _fd07 is g00_02("p/fd 07.ks").
  local _fd19 is g00_02("p/fd 19.ks").
  local _fd27 is g00_02("p/fd 27.ks").
  g00_01({parameter m.
    _fd07({parameter seq,ev,next.
      g00_03("PGM 07 44").
      local pgm is _fd27:bind(seq,next@).
      local g is _fd19:bind(m).
      local o is _fd19:bind(g("obt",Lex())).
      local b is o("bdy",Kerbin).
      pgm(_030c,List(b),g("idl",{})).
      pgm(_0301,List(next@,g("wrp",1))).
    })().
  }).
}