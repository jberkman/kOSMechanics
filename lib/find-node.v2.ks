{
  local cn is get("lib/clear-nodes.ks").
  local l2n is get("lib/list-to-node.ks").
  local n2l is get("lib/node-to-list.ks").
  put({parameter hc,nd,st,a is 1.2.
    local x is l2n(hc["seek"](n2l(nd),st,{parameter x.cn().add l2n(x).wait 0. return nextNode.},a)).
    cn().return x.
  }).
}