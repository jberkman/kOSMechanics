{
  local _fd0f is g00_02("p/fd 0f.ks").
  local _fd10 is g00_02("p/fd 10.ks").
  local _fd13 is g00_02("p/fd 13.ks").
  local _fd15 is g00_02("p/fd 15.ks").
  local _fd16 is g00_02("p/fd 16.ks").
  local _fd17 is g00_02("p/fd 17.ks").
  local _fd1c is g00_02("p/fd 1c.ks").
  g00_01({parameter b.
    g00_03("PGM 04 07").
    _fd10().
    set target to b.
    if _fd15(obt,b)and _fd16(obt,b):periapsis<0 return. 
    local h is _fd0f().
    h["add"](b:radius/2,_fd1c(b,{parameter o.
      //print "peri: "+o:periapsis+" ("+(o:periapsis+b:radius)+")".
      return o:periapsis+b:radius.
    })).
    until hasNode and nextNode:eta>30 and _fd15(nextNode:obt,b) and _fd16(nextNode:obt,b):periapsis<0{
      add _fd13(h["solve"]@,Node(time:seconds+180,0,0,0),List(0,0.5,0.5,0.5)).
      wait 0.
    }
  }).
}
