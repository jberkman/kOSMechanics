{
  local _0301 is g00_02("p/03 01.ks").
  local _0307 is g00_02("p/03 07.ks").
  local _fd07 is g00_02("p/fd 07.ks").
  local _fd19 is g00_02("p/fd 19.ks").
  local _fd27 is g00_02("p/fd 27.ks").
  g00_01({parameter m.
    _fd07({parameter seq,ev,next.
      g00_03("PGM 07 22").
      local pgm is _fd27:bind(seq,next@).
      pgm(_0307@,List(),_fd19(m,"idl",{})).
      pgm(_0301@,List({parameter x.},_fd19(m,"wrp",1))).
    })().
  }).
}