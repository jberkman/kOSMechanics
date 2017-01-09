{
  local cn is get("lib/clear-nodes.ks").
  local hc is get("lib/hill-climb.ks").
  local l2n is get("lib/list-to-node.ks").
  local n2l is get("lib/node-to-list.ks").
  put({parameter nd,st,ev,i is 4.
    local x is n2l(nd).set st to st:copy.
    until i=0{
      set x to hc(x,st,{parameter x.
        cn().local nd is l2n(x).add nd. wait 0.
        local y is ev(nd).remove nd. wait 0.
        return y.
      }).
      local j is 0.until j=st:length{set st[j]to st[j]/10. set j to j+1.}
      set i to i-1.
    }
    return l2n(x).
  }).
}