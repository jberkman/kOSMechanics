{
  local exec is get("lib/exec-node.ks").
  local find is get("lib/find-node.ks").
  put({parameter t is time:seconds+30.
    local nd is find(Node(t,0,0,-100),list(0,0,0,100),{parameter n.return-abs(n:orbit:periapsis-30000).}).
    add nd. exec().
  }).
}