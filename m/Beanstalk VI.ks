{local rnd is g00_02("p/06 01.ks"):bind(1,1).local s2d is g00_02("p/fd 1e.ks").g00_01(Lex(
"body",Minmus,
"launch.alt",100000,
"idle",{lock steering to lookDirUp(sun:position,prograde:vector).rnd().s2d().}
)).}