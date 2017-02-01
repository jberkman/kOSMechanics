{
  local cn is get("lib/clear-nodes.ks").
  local l2n is get("lib/list-to-node.v2.ks").
  local n2l is get("lib/node-to-list.v2.ks").
  put({parameter hc,nd,st,a is 1.2.
    local x is l2n(hc["seek"](n2l(nd),List(st[0],st[1],st[2],st[3],sqrt(st[1]+st[2]),sqrt(st[2]+st[3]),sqrt(st[3]+st[1]),sqrt(st[1]+st[2]),sqrt(st[2]+st[3]),sqrt(st[3]+st[1])),{parameter x.cn().add l2n(x).wait 0. return nextNode.},a)).
    cn().return x.
  }).
}