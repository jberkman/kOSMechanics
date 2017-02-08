{
  local cn is get("lib/clear-nodes.ks").
  local l2n is get("lib/list-to-node.v2.ks").
  local n2l is get("lib/node-to-list.v2.ks").
  put({parameter hc,nd,st,a is 1.2.
    local s is List(st[0],st[1],st[2],st[3],0,0,0,0,0,0).
    if st[1]and st[2]set s[4]to sqrt(st[1]+st[2]).
    if st[2]and st[3]set s[5]to sqrt(st[2]+st[3]).
    if st[1]and st[3]set s[6]to sqrt(st[1]+st[3]).
    set s[7]to s[4].
    set s[8]to s[5].
    set s[9]to s[6].
    local x is l2n(hc["seek"](n2l(nd),s,{parameter x.cn().add l2n(x).wait 0. return nextNode.},a)).
    cn().return x.
  }).
}