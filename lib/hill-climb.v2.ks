// Inspired by Kevin Gisi http://youtube.com/gisikw
{
  function nb{parameter nd,st,ch.
    function it{parameter nd.local x is nd:copy. set x[i]to nd[i]-st[i]. if not ch:hasKey(""+x)rt:add(x).set x to nd:copy. set x[i]to nd[i]+st[i]. if not ch:hasKey(""+x)rt:add(x).}
    local rt is list().local i is 0.until i=nd:length{if st[i]<>0{for j in rt:copy it(j).it(nd).}set i to i+1.}return rt.}
  put({
    local g is list().
    local e is list().
    local f is list().
    return lex(
      "add",{parameter g_,e_,f_.g:add(g_).e:add(e_).f:add(f_).},
      "seek",{parameter nd,st,m is{parameter x.return x.}.
        local n is g:length. local y is list().local ch is lex(""+nd,1).local mx is m(nd).
        local i is 0.until i=n{y:add(abs(f[i](mx)-g[i])).set i to i+1.}
        local dn is 0.until dn{
          set dn to 1.
          for x in nb(nd,st,ch){
            set mx to m(x).local z is list().local i is 0.until i=n{
              local v is abs(f[i](mx)-g[i]).
              if v>e[i]and v>y[i] break.
              if v>e[i]and v<y[i] set dn to 0.
              z:add(v).set i to i+1.
            }
            if z:length=n and not dn{set nd to x. set y to z.}
            set ch[""+x]to 1.
          }
        }
        return nd.
      }
    ).
  }).
}