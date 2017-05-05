{
  local _0301 is g00_02("p/03 01.ks").
  local _0302 is g00_02("p/03 02.ks").
  local _0303 is g00_02("p/03 03.ks").
  local _0304 is g00_02("p/03 04.ks").
  local _0307 is g00_02("p/03 07.ks").
  local _0308 is g00_02("p/03 08.ks").
  local _fd07 is g00_02("p/fd 07.ks").
  local _fd19 is g00_02("p/fd 19.ks").
  local _fd27 is g00_02("p/fd 27.ks").
  g00_01({parameter m.
    _fd07({parameter seq,ev,next.
      g00_03("PGM 07 21").
      local pgm is _fd27:bind(seq,next@).
      local w is 1.
      local g is _fd19:bind(m).
      local b is Kerbin.
      local hasPeer is m:hasKey("per").
      local peer is g("per",0).
      if hasPeer set b to peer:obt:body.
      local o is _fd19:bind(g("obt",Lex())).
      set b to o("bdy",b).
      local ecc is o("ecc",0).
      local sma is o("sma",b:radius+b:atm:height+10000).
      local apo is sma*(1+ecc)-b:radius.
      local peri is sma*(1-ecc)-b:radius.
      local aop is o("aop",-1).
      local idle is g("idl",{}).
      pgm(_0307@).
      pgm(_0301@,List({parameter x.},w)).
      pgm(_0303@,List(peri)).
      pgm(_0301@,List(next@,w)).
      pgm(_0304@).
      pgm(_0301@,List(next@,w)).
      pgm(_0308@,List(apo,aop)).
      pgm(_0301@,List(next@,w)).
      pgm(_0302@,List(peri)).
      pgm(_0301@,List(next@,w)).
    })().
  }).
}