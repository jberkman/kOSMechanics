{
  local cn is g00_02("p/fd 10.ks").
  local hal is g00_02("p/fd 0f.ks").
  local find is g00_02("p/fd 13.ks").
  local gss is g00_02("p/fd 14.ks").
  local xfer is g00_02("p/fd 15.ks").
  local xo is g00_02("p/fd 16.ks").
  local approach is g00_02("p/fd 17.ks").
  local dv is g00_02("p/fd 0e.ks").
  g00_01({parameter pr.
    g00_03("PGM 03 0C").
    set target to pr.
    local h is hal().
    local vEsc is velocity:orbit:mag*(sqrt(2)-0.99).
    local pro is pr:obt:semiMajorAxis>body:obt:semiMajorAxis.
    {
      local t is time:seconds+obt:period/4.
      local tEsc is gss(time:seconds,time:seconds+obt:period,15,{parameter t.
        cn().
        add Node(t,0,0,vEsc).
        wait 1.
        local ret is 2^64.
        if xfer(nextNode:obt,body:obt:body){
          local o is xo(nextNode:obt,body:obt:body).
          if pro set ret to-o:apoapsis.
          else set ret to o:periapsis.
        }
        cn().
        print"ret: "+round(ret/100000)+" t: "+round((t-time:seconds)/60).
        return ret.
      }).
      add Node(tEsc,0,0,vEsc).
      print 1/0.
    }
    cn().
    local t is time:seconds+obt:period.
    add find(h["solve"]@,Node(t,0,0,dv(t,pr:altitude)),List(obt:period/12,0,0,0)).
    wait 0.
  }).
}