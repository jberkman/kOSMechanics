{
  local hal is g00_02("p/fd 0f.ks").
  local hohmann is g00_02("p/fd 0e.ks").
  local find is g00_02("p/fd 13.ks").
  g00_01({parameter alt,aop.g00_03("PGM 03 08").
    local t is time:seconds+obt:period/2.
    local nd is Node(t,0,0,hohmann(t,alt)).
    if aop>=0{
      local h is hal().
      h["add"](0.5,{parameter n.return n:obt:argumentOfPeriapsis-aop.}).
      add find(h["solve"]@,nd,List(obt:period/36,0,0,0)).
    }else add nd.
    if nextNode:eta<30 set nextNode:eta to nextNode:eta+obt:period.
    set nextNode:prograde to hohmann(time:seconds+nextNode:eta,alt).
  }).
}