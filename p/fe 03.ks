g00_01(g00_02("p/fd 07.ks")({parameter seq,ev,next.
  local pgm is g00_02("p/fd 09.ks"):bind(seq,next@).
  local g is g00_02("p/fd 19.ks"):bind(g00_02("p/fd 08.ks")).
  local idle is g("idle",{}).
  local obts is g("obts",-1).
  local w is 1.
  pgm("p/01 06.ks").
  pgm("p/03 04.ks",List(),idle@).
  pgm("p/03 01.ks",List(next@,w)).
  seq:add({wait until gear. next().}).
  pgm("p/05 01.ks").
  pgm("p/03 01.ks",List(next@,w)).
  seq:add({wait 10. stage.}).
})).