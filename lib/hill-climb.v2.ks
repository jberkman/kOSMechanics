// Inspired by Kevin Gisi http://youtube.com/gisikw
{
  local enumerate is get("lib/enumerate.ks").
  local map is get("lib/map.ks").
  local reduce is get("lib/reduce.ks").
  put({local g is List(). local e is List(). local f is List().
    return lex(
      "add",{parameter g_,e_,f_.g:add(g_). e:add(e_). f:add(f_).},
      "seek",{parameter p,s,m is{parameter x.return x.},ac is 2.
        local a is list(-ac,-1/ac,0,1/ac,ac).
        local n is g:length.
        function eval{parameter x.return map(enumerate(f),{parameter iv.return abs(iv[1](x)-g[iv[0]]).}).}
        function beats{parameter l,r.
          local x is map(enumerate(l),{parameter x.
            local i is x[0]. local v is x[1].
            if v<r[i]return 1.
            if v=r[i]or v<=e[i]return 0.
            return -1.
          }).
          return 1=reduce(x,0,{parameter v,x.
            if v=-1 or x=-1 return-1.
            if v=1 or x=1 return 1.
            return 0.
          }).
        }
        local score is eval(m(p)).
        until reduce(enumerate(score),1,{parameter v,iv.return v and iv[1]<e[iv[0]].}){
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
            print s.
          }
        }
        return p.
      }
    ).
  }).
}