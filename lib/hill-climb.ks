// Inspired by Kevin Gisi http://youtube.com/gisikw
{
  function nb{parameter nd,st.
    local rt is list().local i is 0.until i=nd:length{
      local x is nd:copy. set x[i]to nd[i]-st. rt:add(x).
      set x to nd:copy. set x[i]to nd[i]+st. rt:add(x).
      set i to i+1.
    }
    return rt.
  }
  put({parameter nd,ev,st is 1.
    local sc is ev(nd).local dn is 0.until dn{
      set dn to 1.for n in nb(nd,st){
        local new is ev(n).
        if new>sc{set nd to n. set sc to new. set dn to 0.}
      }
    }
    return nd.
  }).
}