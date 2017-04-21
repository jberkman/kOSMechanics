g00_01(g00_02("p/fd 07.ks")({parameter seq,ev,next.
  local pgm is g00_02("p/fd 09.ks"):bind(seq,next@).
  local rnd is g00_02("p/06 01.ks"):bind(1,1).
  local w is 1.
  local g is g00_02("p/fd 19.ks"):bind(g00_02("p/fd 08.ks")).
  local b is g("body",Mun).
  local idle is g("idle",{}).
  pgm("p/01 06.ks").
  pgm("p/03 01.ks",List({parameter x.},w)).
  pgm("p/04 02.ks",List(b),idle@).
  pgm("p/03 01.ks",List({parameter x.},w)).
  local clamp is g00_02("p/fd 04.ks").
  local i is g("inc",0).
  pgm("p/04 07.ks",List(b,next:bind(-3)),idle@).
  pgm("p/03 01.ks",List(next@,w)).
  pgm("p/04 04.ks",List(b,w),idle@).
  pgm("p/06 01.ks",List(1)).
  if g("lithobrake",0)=0{
    pgm("p/05 02.ks",List(w),idle@).
    pgm("p/06 01.ks",List(1)).
  }
  pgm("p/00 02.ks",List(),rnd@).
})).