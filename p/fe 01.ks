g00_01(g00_02("p/fd 07.ks")({parameter seq,ev,next.
  local m is g00_02("p/fd 08.ks").
  local pgm is g00_02("p/fd 09.ks"):bind(seq,next@).
  local g is g00_02("p/fd 19.ks"):bind(m).
  local b is g("body",Kerbin).
  local p is g("launch.pitch-rate",0.4).
  local a is 0. local i is 0. local l is 0.
  local w is 1.
  if b=Kerbin{
    set a to g("peri",g("apo",b:atm:height+10000)).
    set i to g("inc",0).
    set l to g("lan",-1).
  }else{
    set a to g("launch.alt",Kerbin:atm:height+10000).
    if b:obt:body=Kerbin{
      set i to b:obt:inclination.
      set l to b:obt:longitudeOfAscendingNode.
    }
  }
  if l>=0 and i>0{
    pgm("p/01 02.ks",List(l)).
    seq:add(g00_02("p/01 03.ks"):bind(l,next@)).
  }
  pgm("p/01 04.ks").
  pgm("p/01 05.ks",List(a)).

  pgm("p/02 01.ks").
  pgm("p/02 02.ks",List(i,p)).
  pgm("p/02 03.ks",List(a)).
  pgm("p/02 04.ks",List(a,i)).
  pgm("p/02 05.ks").
  if g("launch.raise-peri",0){
    pgm("p/02 06.ks",List(a)).
    pgm("p/03 01.ks",List(next@,w)).
  }
  if b<>Kerbin{
    pgm("p/03 04.ks").
    pgm("p/03 01.ks",List(next@,w)).
    pgm("p/04 01.ks",List(b)).
    pgm("p/03 01.ks",List(next@,w)).
  }
  if g("launch.stage",1)pgm("p/02 07.ks").
  if g("launch.deorbit",0)pgm("p/05 01.ks").
  seq:add(pgm("p/00 02.ks")).
})).