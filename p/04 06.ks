{
  local hal is g00_02("p/fd 0f.ks").
  local hohmann is g00_02("p/fd 0e.ks").
  local find is g00_02("p/fd 13.ks").
  g00_01({g00_03("PGM 04 06").
    local h is hal().
    h["add"](0.1,{parameter n. return n:obt:eccentricity.}).
    local i is 0. if obt:inclination>90 set i to 180.
    h["add"](1.5,{parameter n.return n:obt:inclination-i.}).
    local t is time:seconds+eta:periapsis.
    local dv is hohmann(t,periapsis).
    add find(h["solve"]@,Node(t,0,0,dv),List(0,0,0.05*dv,0.05*dv)).
  }).
}