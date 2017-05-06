{
  local _0301 is g00_02("p/03 01.ks").
  local _0402 is g00_02("p/04 02.ks").
  local _0403 is g00_02("p/04 03.ks").
  local _0404 is g00_02("p/04 04.ks").
  local _0405 is g00_02("p/04 05.ks").
  local _0406 is g00_02("p/04 06.ks").
  local _fd07 is g00_02("p/fd 07.ks").
  local _fd19 is g00_02("p/fd 19.ks").
  local _fd27 is g00_02("p/fd 27.ks").
  g00_01({parameter m.
    _fd07({parameter seq,ev,next.
      g00_03("PGM 07 42").
      local pgm is _fd27:bind(seq,next@).
      local w is 1.
      local g is _fd19:bind(m).
      local o is _fd19:bind(g("obt",Lex())).
      local b is o("bdy",Kerbin).
      local ecc is o("ecc",0).
      local sma is o("sma",b:radius+b:atm:height+10000).
      local apo is sma*(1+ecc)-b:radius.
      local idle is g("idl",{}).
      pgm(_0301@,List({parameter x.},w)).
      pgm(_0402@,List(b),idle@).
      pgm(_0301@,List({parameter x.},w)).
      local i is o("inc",0).
      pgm(_0403@,List(b,apo,i,next:bind(-3)),idle@).
      pgm(_0301@,List(next@,w)).
      pgm(_0404@,List(b,w),idle@).
      pgm(_0405@,List(),idle@).
      pgm(_0301@,List(next@,w)).
      pgm(_0406@,List(),idle@).
      pgm(_0301@,List(next@,w)).
    })().
  }).
}