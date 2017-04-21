g00_01(g00_02("p/fd 07.ks")({parameter seq,ev,next.
  local pgm is g00_02("p/fd 09.ks"):bind(seq,next@).
  local m is g00_02("p/fd 08.ks").
  local g is g00_02("p/fd 19.ks"):bind(m).
  local b is Kerbin.
  local hasPeer is m:hasKey("peer").
  local peer is g("peer",0).
  if hasPeer set b to peer:obt:body.
  set b to g("body",b).
  local p is g("launch.pitch-rate",0.4).
  local a is 0. local i is 0. local l is 0.
  local w is 1.
  if b=Kerbin and hasPeer=0{
    local ecc is g("ecc",0).
    local sma is g("sma",b:radius+b:atm:height+10000).
    set a to sma*(1-ecc)-b:radius.
    set i to g("inc",0).
    set l to g("lan",-1).
  }else{
    set a to g("launch.alt",Kerbin:atm:height+10000).
    if b:obt:body=Kerbin{
      set i to b:obt:inclination.
      set l to b:obt:longitudeOfAscendingNode.
    }else if hasPeer{
      set i to peer:obt:inclination.
      set l to peer:obt:longitudeOfAscendingNode.
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
  pgm("p/02 08.ks",List(a,i)).
  pgm("p/02 04.ks",List(a,i)).
  pgm("p/02 05.ks").
  if g("launch.raise-peri",0){
    pgm("p/02 06.ks",List(a)).
    pgm("p/03 01.ks",List(next@,w)).
  }
  if b<>Kerbin or hasPeer{
    local s2d is g00_02("p/fd 1e.ks").
    local idle is{lock steering to lookDirUp(prograde:vector,-up:vector).s2d().}.
    pgm("p/03 04.ks",List(),idle@).
    pgm("p/03 01.ks",List(next@,w)).
    if b<>Kerbin{
      pgm("p/04 01.ks",List(b),idle@).
    }else{
      pgm("p/03 0a.ks",List(peer,g("phase",60)),idle@).
    }
    pgm("p/03 01.ks",List(next@,w)).
  }
  if g("launch.stage",1)pgm("p/02 07.ks").
  if g("launch.deorbit",0)pgm("p/05 01.ks").
  pgm("p/00 02.ks").
})).