{local h is g00_02("p/fd 06.ks").g00_01({parameter a,i.g00_03("PGM 02 04").function g02_03{return lookDirUp(heading(h(i),0):vector,-up:vector).}lock steering to g02_03().wait until apoapsis>=a or(ship:maxThrust<0.1 and altitude>body:atm:height). wait 5.}).}