{
  local hal is g00_02("p/fd 0f.ks").
  local find is g00_02("p/fd 13.ks").
  local xferMap is g00_02("p/fd 1c.ks").
  g00_01({g00_03("PGM 04 05").
    local h is hal().
    local f is{parameter n.return abs(n:obt:argumentOfPeriapsis-180).}.
    if latitude<0 set f to{parameter n.
      local p is n:obt:argumentOfPeriapsis.
      if p<180 return p. else return 360-p.
    }.
    h["add"](0.1,f@).
    until 0{
      add find(h["solve"]@,Node(time:seconds+180,0,0,0),List(0,0,1,0)).
      if nextNode:eta>10 break.
    }
  }).
}