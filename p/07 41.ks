{
  local _0301 is g00_02("p/03 01.ks").
  local _030a is g00_02("p/03 0a.ks").
  local _fd07 is g00_02("p/fd 07.ks").
  local _fd19 is g00_02("p/fd 19.ks").
  local _fd27 is g00_02("p/fd 27.ks").
  g00_01({parameter m.
    _fd07({parameter seq,ev,next.
      g00_03("PGM 07 41").
      local pgm is _fd27:bind(seq,next@).
      local g is _fd19:bind(m).
      local o is _fd19:bind(g("obt",Lex())).
      local b is o("bdy",Kerbin).
      pgm(_030a,List(b,0),g("idl",{})).
      pgm(_0301,List(next@,1)).
    })().
  }).
}