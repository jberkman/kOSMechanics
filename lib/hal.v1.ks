{
  local map is get("lib/map.ks").
  put({
    local ef is List().//[[e,f],...]
    function dominates{parameter l,r.
      local d is 0.
      local i is 0.until i=l:length{
        //print "    ["+i+"]    "+l[i]+"    "+r[i].
        if l[i]>r[i]return 0.
        if l[i]<r[i]set d to 1.
        set i to i+1.
      }
      //print "    ===>    "+d.
      return d.
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
        if dominates(x,lex[k][1]){
          print "Removing: "+lex[k][1]:join("    ").
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
      local e is ef[0][0].
      local f is ef[0][1].
      set score to score[0].
      local nb is neighbors(steps).
      until 0{
        local next is-1.
        local found is 0.
        for neighbor in nb{
          set neighbor to vadd(neighbor,x).
          local tmp is abs(f(g(neighbor))).
          if tmp<=e return neighbor.
          if tmp<score{
            set score to tmp.
            set next to neighbor.
            set found to 1.
          }
        }
        if found set x to next.
        else{
          set steps to smult(steps,0.5).
          print steps.
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
          print "Inbox: "+inbox:length+" Outbox: "+outbox:length.
          for neighbor in nb{
            set neighbor to vadd(neighbor,incoming[0]).
            local nk is key(neighbor).
            if not inbox:hasKey(nk) and not outbox:hasKey(nk){
              local score is eval(g(neighbor)).
              //print "    neighbor: "+nk+" "+score:join(", ").
              if solves(score)return neighbor.
              function cb{parameter x.return dominates(x[1],score).}
              if not dominates(incoming[1],score) and not contains(outbox:values,cb@) and not contains(inbox:values,cb@){
                filterFront(score,inbox).
                filterFront(score,outbox).
                set inbox[nk] to List(neighbor,score).
                print "    "+score:join(", ").
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