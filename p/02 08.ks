{local h is g00_02("p/fd 06.ks").local p is g00_02("p/fd 20.ks").g00_01({parameter a,i.g00_03("PGM 02 04").function g02_03{return lookDirUp(heading(h(i),max(0,p(ship,ship:velocity:orbit))):vector,-up:vector).}lock steering to g02_03().wait until apoapsis>=a or altitude>body:atm:height.}).}