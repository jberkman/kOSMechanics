g00_01(g00_02("p/fd 07.ks")({parameter seq,ev,next.
  local pgm is g00_02("p/fd 09.ks"):bind(seq,next@).
  local w is 1.
  local m is g00_02("p/fd 08.ks").
  local g is g00_02("p/fd 19.ks"):bind(m).
  local b is Kerbin.
  local hasPeer is m:hasKey("peer").
  local peer is g("peer",0).
  if hasPeer set b to peer:obt:body.
  set b to g("body",b).
  local ecc is g("ecc",0).
  local sma is g("sma",b:radius+b:atm:height+10000).
  local apo is sma*(1+ecc)-b:radius.
  local peri is sma*(1-ecc)-b:radius.
  local aop is g("aop",-1).
  local idle is g("idle",{}).
  local rnd is g00_02("p/06 01.ks"):bind(1,1).
  pgm("p/01 06.ks").
  pgm("p/03 01.ks",List({parameter x.},w)).
  if b=Kerbin{
    if hasPeer{
      pgm("p/03 02.ks",List(peer:obt:periapsis),idle@).
      pgm("p/03 01.ks",List(next@,w)).
      pgm("p/03 03.ks",List(peer:obt:apoapsis),idle@).
      pgm("p/03 01.ks",List(next@,w)).
      pgm("p/03 02.ks",List(peer:obt:periapsis),idle@).
      pgm("p/03 01.ks",List(next@,w)).
      pgm("p/03 0b.ks",List(peer:obt:semiMajorAxis)).
      pgm("p/00 02.ks",List(),{idle().rnd().}).
    }else{
      pgm("p/03 07.ks").
      pgm("p/03 01.ks",List({parameter x.},w)).
      pgm("p/03 03.ks",List(peri)).
      pgm("p/03 01.ks",List(next@,w)).
      pgm("p/03 04.ks").
      pgm("p/03 01.ks",List(next@,w)).
      pgm("p/03 08.ks",List(apo,aop)).
      pgm("p/03 01.ks",List(next@,w)).
      pgm("p/03 02.ks",List(peri)).
      pgm("p/03 01.ks",List(next@,w)).
    }
  }else{
    pgm("p/04 02.ks",List(b),idle@).
    pgm("p/03 01.ks",List({parameter x.},w)).
    local clamp is g00_02("p/fd 04.ks").
    local i is g("inc",0).
    pgm("p/04 03.ks",List(b,apo,i,next:bind(-3)),idle@).
    pgm("p/03 01.ks",List(next@,w)).
    pgm("p/04 04.ks",List(b,w),idle@).
    pgm("p/04 05.ks",List(),idle@).
    pgm("p/03 01.ks",List(next@,w)).
    pgm("p/04 06.ks",List(),idle@).
    pgm("p/03 01.ks",List(next@,w)).
    local l is g("lan",-1).
    pgm("p/03 06.ks",List(clamp(i,0.5,179.5),l),idle@).
    pgm("p/03 01.ks",List(next@,w)).
    pgm("p/03 08.ks",List(peri,aop),idle@).
    pgm("p/03 01.ks",List(next@,w)).
    pgm("p/03 03.ks",List(apo),idle@).
    pgm("p/03 01.ks",List(next@,w)).
  }
  pgm("p/00 02.ks",List(),{idle().rnd().}).
})).