{
  local cn is get("lib/clear-nodes.ks").
  local l2n is get("lib/list-to-node.ks").
  local n2l is get("lib/node-to-list.ks").
  put({parameter hc,nd,st,i is 4.
    local x is n2l(nd).set st to st:copy.
    until i=0{
      set x to hc["seek"](x,st,{parameter x.cn().add l2n(x).wait 0. return nextNode.}).
      local j is 0.until j=st:length{set st[j]to st[j]/10. set j to j+1.}
      set i to i-1.
    }
    cn().return l2n(x).
  }).
}