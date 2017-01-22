// Inspired by Kevin Gisi http://youtube.com/gisikw
{
  local map is get("lib/map.ks").
  local reduce is get("lib/reduce.ks").
  local zip2 is get("lib/zip2.ks").
  local zip3 is get("lib/zip3.ks").
  put({local gef is List().
    return lex(
      "add",{parameter g,e,f.gef:add(List(g,e,f)).},
      "seek",{parameter p,s,m is{parameter x.return x.},ac is 2.
        local a is list(-ac,-1/ac,0,1/ac,ac).
        local n is gef:length.
        function eval{parameter x.return map(gef,{parameter gef.return abs(gef[2](x)-gef[0]).}).}
        function beats{parameter l,r.
          local x is map(zip3(l,r,gef),{parameter x.
            if x[0]<x[1]return 1.
            if x[0]=x[1]or x[0]<=x[2][1]return 0.
            return -1.
          }).
          return 1=reduce(x,0,{parameter v,x.
            if v=-1 or x=-1 return-1.
            if v=1 or x=1 return 1.
            return 0.
          }).
        }
        until 0{
          local score is eval(m(p)).
          local i is 0.until i=p:length{if s[i]<>0{
            local best is-1.
            local j is 0.until j=5{
              local t is p[i].
              set p[i]to p[i]+s[i]*a[j].
              local cur is eval(m(p)).
              set p[i]to t.
              if beats(cur,score){
                set best to j.
                set score to cur.
              }
              set j to j+1.
            }
            if best<0 or a[best]=0 set s[i]to s[i]/ac.
            else{
              set s[i]to s[i]*a[best].
              set p[i]to p[i]+s[i].
            }
            }set i to i+1.
          }
          if reduce(zip2(score,gef),1,{parameter v,x.return v and x[0]<x[1][1].})return p.
        }
      }
    ).
  }).
}