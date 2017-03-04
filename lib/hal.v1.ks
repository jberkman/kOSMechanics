{
  local map is get("lib/map.ks").
  put({
    local ef is List().//[[e,f],...]
    function cmp{parameter l,r.
      local x is 0.
      local i is 0.until i=l:length{
        if l[i]>ef[i][0]or r[i]>ef[i][0]{
          if l[i]<r[i] set x to x-1.
          else if l[i]>r[i] set x to x+1.
        }
        set i to i+1.
      }
      return x.
    }
    function contains{parameter l,f.for i in l if f(i)return 1.return 0.}
    function eval{parameter x.
      local values is List().
      local i is 0.until i=ef:length{
        values:add(abs(ef[i][1](x))).
        set i to i+1.
      }
      return values.
    }
    function filterFront{parameter x,lex.
      for k in lex:keys{
        if cmp(x,lex[k][1])<0{
          //print "Removing: "+k.
          lex:remove(k).
        }
      }
    }
    function key{parameter l.return l:join(",").}
    function neighbors{parameter steps.
      local n is List(map(steps,{parameter x.return 0.})).{
        local i is 0.until i=steps:length{
          if steps[i]<>0{
            for j in n:copy{
              local k is j:copy.
              set k[i]to steps[i].
              n:add(k:copy).
              set k[i]to-steps[i].
              n:add(k).
            }
          }
          set i to i+1.
        }
        n:remove(0).
        return n.
      }
    }
    function solves{parameter x.
      local i is 0.until i=ef:length{
        if x[i]>ef[i][0] return 0.
        set i to i+1.
      }
      return 1.
    }
    function vadd{parameter l,r.
      local s is List().
      local i is 0.until i=l:length{
        s:add(l[i]+r[i]).
        set i to i+1.
      }
      return s.
    }
    function smult{parameter v,s.
      local p is List().
      local i is 0.until i=v:length{
        p:add(v[i]*s).
        set i to i+1.
      }
      return p.
    }
    function hc{parameter x,score,steps,g.
      local nb is neighbors(steps).
      until 0{
        local next is-1.
        local found is 0.
        for neighbor in nb{
          set neighbor to vadd(neighbor,x).
          local tmp is eval(g(neighbor)).
          if solves(tmp) return neighbor.
          if cmp(tmp,score)<0{
            set score to tmp.
            set next to neighbor.
            set found to 1.
          }
        }
        if found set x to next.
        else{
          set steps to smult(steps,0.5).
          set nb to neighbors(steps).
        }
      }
    }
    function moo{parameter x,score,steps,g.
      local inbox is Lex(key(x),List(x,score)).
      local outbox is Lex().
      until 0{
        local nb is neighbors(steps).
        until inbox:length=0{
          local ik is inbox:keys[0].
          local incoming is inbox[ik].
          inbox:remove(ik).
          set outbox[ik] to incoming.
          print "Inbox: "+inbox:length+" Outbox: "+outbox:length+" nb: "+nb:length.
          for neighbor in nb{
            set neighbor to vadd(neighbor,incoming[0]).
            local nk is key(neighbor).
            if not inbox:hasKey(nk) and not outbox:hasKey(nk){
              local score is eval(g(neighbor)).
              //print "    neighbor: "+nk+" "+score:join(", ").
              if solves(score)return neighbor.
              function cb{parameter x.return cmp(score,x[1])>0.}
              if cmp(score,incoming[1])<=0 and not contains(outbox:values,cb@) and not contains(inbox:values,cb@){
                filterFront(score,inbox).
                filterFront(score,outbox).
                set inbox[nk] to List(neighbor,score).
                print "    Inbox: "+inbox:length+" Outbox: "+outbox:length.
              }
            }
          }
        }
        set inbox to outbox.
        set outbox to Lex().
        set steps to smult(steps,0.5).
      }
    }
    return Lex(
      "add",{parameter e,f.ef:add(List(e,f)).},
      "solve",{parameter x,steps,g is{parameter x.return x.}.
        local score is eval(g(x)).
        if solves(score)return x.
        if ef:length>1 return moo(x,score,steps,g).
        return hc(x,score,steps,g).
      }
    ).
  }).
}