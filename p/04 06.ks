{
  local cn is g00_02("p/fd 10.ks").
  local ov is g00_02("p/fd 0d.ks").
  local incDV is g00_02("p/fd 1d.ks").
  g00_01({g00_03("PGM 04 06").
    cn().wait 0.
    local i is 0. if obt:inclination>90 set i to 180.
    local t is time:seconds+eta:periapsis.
    local dv is incDV(abs(obt:inclination-i),velocityAt(ship,t):orbit:mag,ov(obt,periapsis,periapsis+body:radius)).
    if(i>90 and obt:argumentOfPeriapsis>90 and obt:argumentOfPeriapsis<270)or(i<90 and(obt:argumentOfPeriapsis<90 or obt:argumentOfPeriapsis>270))set dv[0]to-dv[0].
    add Node(t,0,dv[0],dv[1]).
  }).
}