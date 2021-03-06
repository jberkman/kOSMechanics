{
  local hal is g00_02("p/fd 0f.ks").
  local find is g00_02("p/fd 13.ks").
  local gss is g00_02("p/fd 14.ks").
  local x2 is g00_02("p/fd 15.ks").
  local altAt is g00_02("p/fd 1a.ks").
  local xferETA is g00_02("p/fd 1b.ks").
  local xferMap is g00_02("p/fd 1c.ks").
  g00_01({parameter b,e.
    g00_03("PGM 04 07").
    if not x2(obt,b){e().return.}
    //if altitude>b:altitude/2{s().return.}
    set target to b.
    local nd is 0.
    {
      local t is xferETA(obt,b).
      local h is obt:periapsis/2.
      if altitude>b:altitude set h to obt:apoapsis/2.
      set h to h+b:altitude/2.
      set nd to Node(gss(time:seconds,time:seconds+t,60,{parameter t.return abs(altAt(t)-h).}),0,0,0).
    }
    //if nd:eta<0{s().return.}
    local h is hal().
    set nd to find(h["solve"]@,nd,List(0,1,1,1)).
    h["add"](b:radius/2,xferMap(b,{parameter o.return o:periapsis+b:radius.})).
    add find(h["solve"]@,nd,List(0,0.5,0.5,0.5)).
  }).
}