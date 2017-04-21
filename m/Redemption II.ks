{local s2d is g00_02("p/fd 1e.ks").local scan is g00_02("p/06 02.ks").g00_01(Lex(
"body",Minmus,
"launch.alt",100000,
"inc",87.5,
//"ecc",0.12913994987570568,
"sma",460000,
//"lan",200.2302538045823,
//"aop",247.77803605784555,
"idle",{lock steering to lookDirUp(-up:vector,prograde:vector).s2d().scan().}
)).}