g00_01(g00_02("p/fd 07.ks")({parameter seq,ev,next.
  local pgm is g00_02("p/fd 09.ks"):bind(seq,next@).
  pgm("p/01 06.ks").
  local w is 1.
  pgm("p/03 01.ks",List({parameter x.},w)).
  local g is g00_02("p/fd 19.ks"):bind(g00_02("p/fd 08.ks")).
  local b is g("body",Kerbin).
  local apo is g("apo",b:atm:height+10000).
  local peri is g("peri",b:atm:height+10000).
  local aop is g("aop",-1).
  local idle is g("idle",{}).
  if b=Kerbin{
    pgm("p/03 07.ks").
    pgm("p/03 01.ks",List({parameter x.},w)).
    pgm("p/03 03.ks",List(peri)).
    pgm("p/03 01.ks",List(next@,w)).
    pgm("p/03 05.ks").
    pgm("p/03 01.ks",List(next@,w)).
    pgm("p/03 08.ks",List(apo,aop)).
    pgm("p/03 01.ks",List(next@,w)).
    pgm("p/03 02.ks",List(peri)).
    pgm("p/03 01.ks",List(next@,w)).
  }else{
    pgm("p/04 02.ks",List(b),idle@).
    pgm("p/03 01.ks",List({parameter x.},w)).
    local clamp is g00_02("p/fd 04.ks").
    local i is clamp(g("inc",0),0.5,179.5).
    pgm("p/04 03.ks",List(b,apo,i,next:bind(-3)),idle@).
    pgm("p/03 01.ks",List(next@,w)).
    pgm("p/04 04.ks",List(b,w),idle@).
    pgm("p/04 05.ks",List(),idle@).
    pgm("p/03 01.ks",List(next@,w)).
    pgm("p/04 06.ks",List(),idle@).
    pgm("p/03 01.ks",List(next@,w)).
    pgm("p/03 05.ks",List(),idle@).
    pgm("p/03 01.ks",List(next@,w)).
    local l is g("lan",-1).
    pgm("p/03 06.ks",List(i,l),idle@).
    pgm("p/03 01.ks",List(next@,w)).
    pgm("p/03 08.ks",List(peri,aop),idle@).
    pgm("p/03 01.ks",List(next@,w)).
    pgm("p/03 03.ks",List(apo),idle@).
    pgm("p/03 01.ks",List(next@,w)).
  }
  seq:add(pgm("p/00 02.ks",List(),idle@)).
})).