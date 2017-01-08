{
  local ex is get("lib/exec-node.ks").
  local sk is get("lib/find-node.ks").
  put({parameter t is time:seconds+min(eta:periapsis,eta:apoapsis).
    function mknd{parameter n.return Node(t,0,0,n[0]).}
    function eval{parameter n.return -n:obt:eccentricity.}
    local nd is sk(list(0),mknd@,eval@).
    add nd. ex().
  }).
}