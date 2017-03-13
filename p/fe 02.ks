g00_01(g00_02("p/fd 07.ks")({parameter seq,ev,next.
  local pgm is g00_02("p/fd 09.ks"):bind(seq,next@).
  pgm("p/01 06.ks").
  local w is 1.
  pgm("p/03 01.ks",List({parameter x.},w)).
  local g is g00_02("p/fd 19.ks"):bind(g00_02("p/fd 08.ks")).
  local b is g("body",Kerbin).
  local apo is g("apo",b:atm:height+10000).
  if b=Kerbin{
    pgm("p/03 07.ks").
    pgm("p/03 01.ks",List({parameter x.},w)).
    pgm("p/03 03.ks",List(peri)).
    pgm("p/03 01.ks",List(next@,w)).
    pgm("p/03 05.ks").
    pgm("p/03 01.ks",List(next@,w)).
  }else{
    pgm("p/04 02.ks",List(b)).
    pgm("p/03 01.ks",List({parameter x.},w)).
    local clamp is g00_02("p/fd 04.ks").
    local i is clamp(g("inc",0),0.5,179.5).
    pgm("p/04 03.ks",List(b,apo,i,next:bind(-3))).
    pgm("p/03 01.ks",List(next@,w)).
  }
  seq:add(pgm("p/00 02.ks")).
})).