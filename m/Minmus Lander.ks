{local s2d is g00_02("p/fd 1e.ks").g00_01(List(
  Lex(
    "body",Minmus,
    "launch.alt",100000,
    "idle",{lock steering to lookDirUp(sun:position,prograde:vector).s2d().}
  )
)).}