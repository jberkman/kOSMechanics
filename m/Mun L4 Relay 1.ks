{local s2d is g00_02("p/fd 1e.ks").g00_01(Lex(
"launch.alt",100000,
"peer",Mun,
"phase",-60,
"idle",{lock steering to lookDirUp(kerbin:position:normalized+mun:position:normalized,vcrs(prograde:vector,up:vector)).s2d().}
)).}
