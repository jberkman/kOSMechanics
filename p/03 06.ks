{
  local hal is g00_02("p/fd 0f.ks").
  local inc is g00_02("p/fd 1d.ks").
  local find is g00_02("p/fd 13.ks").
  g00_01({parameter i,l.g00_03("PGM 03 06").
    local h is hal().
    local dv is inc(abs(obt:inclination-i)).
    h["add"](0.75,{parameter n.return n:obt:longitudeOfAscendingNode-l.}).
    local nd is find(h["solve"]@,Node(time:seconds+obt:period/2,0,dv[0],dv[1]),List(obt:period/36,0,0,0)).
    h["add"](0.75,{parameter n.return n:obt:inclination-i.}).
    h["add"](0.01,{parameter n.return n:obt:eccentricity.}).
    add find(h["solve"]@,nd,List(30,0,1,1)).
    until nextNode:eta>30 set nextNode:eta to nextNode:eta+obt:period.
  }).
}