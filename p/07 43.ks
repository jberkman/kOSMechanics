{
  local _0106 is g00_02("p/01 06.ks").
  local _0301 is g00_02("p/03 01.ks").
  local _0302 is g00_02("p/03 02.ks").
  local _0303 is g00_02("p/03 03.ks").
  local _0304 is g00_02("p/03 04.ks").
  local _0306 is g00_02("p/03 06.ks").
  local _0307 is g00_02("p/03 07.ks").
  local _0308 is g00_02("p/03 08.ks").
  local _030b is g00_02("p/03 0b.ks").
  local _0401 is g00_02("p/04 02.ks").
  local _0403 is g00_02("p/04 03.ks").
  local _0404 is g00_02("p/04 04.ks").
  local _0405 is g00_02("p/04 05.ks").
  local _0406 is g00_02("p/04 06.ks").
  local _fd04 is g00_02("p/fd 04.ks").
  local _fd07 is g00_02("p/fd 07.ks").
  local _fd09 is g00_02("p/fd 09.ks").
  local _fd19 is g00_02("p/fd 19.ks").
  g00_01({parameter m.
    _fd07({parameter seq,ev,next.
      g00_03("PGM 07 43").
      local pgm is _fd09:bind(seq,next@).
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
      pgm(_0301@,List({parameter x.},w)).
      if b=Kerbin{
        if hasPeer{
          pgm(_0302@,List(peer:obt:periapsis),idle@).
          pgm(_0301@,List(next@,w)).
          pgm(_0303@,List(peer:obt:apoapsis),idle@).
          pgm(_0301@,List(next@,w)).
          pgm(_0302@,List(peer:obt:periapsis),idle@).
          pgm(_0301@,List(next@,w)).
          pgm(_030b@,List(peer:obt:semiMajorAxis)).
        }else{
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
        }
      }else{
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
        local l is o("lan",-1).
        pgm(_0306@,List(_fd04(i,0.5,179.5),l),idle@).
        pgm(_0301@,List(next@,w)).
        pgm(_0308@,List(peri,aop),idle@).
        pgm(_0301@,List(next@,w)).
        pgm(_0303@,List(apo),idle@).
        pgm(_0301@,List(next@,w)).
      }
    })().
  }).
}