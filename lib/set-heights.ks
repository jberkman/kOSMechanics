{
  local ex is get("lib/exec-node.ks").
  local fi is get("lib/find-node.v2.ks").
  local sk is get("lib/hill-climb.v2.ks").
  put({parameter t,apo,peri,w.
    local hc is sk().
    hc["add"](apo,max(500,0.001*apo),{parameter n.return n:obt:apoapsis.}).
    hc["add"](peri,max(500,0.001*peri),{parameter n.return n:obt:periapsis.}).
    ex(fi(hc,Node(t,0,0,0),List(0,1,0,10)),w).
  }).
}