{
  local exec is get("lib/exec-node.ks").
  local find is get("lib/find-node.ks").
  put({parameter t is time:seconds+min(eta:periapsis,eta:apoapsis).
    local nd is find(Node(t,0,0,100),list(0,0,0,100),{parameter n.return-n:orbit:eccentricity.}).
    add nd. exec().
  }).
}