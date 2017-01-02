{
  local ex is get("lib/exec-node.ks").
  local sk is get("lib/find-node.ks").
  put({parameter h.
    local a is h+periapsis+2*body:radius.
    function mknd{parameter n.return Node(time:seconds+eta:periapsis,0,0,n).}
    function eval{parameter n.return -abs(n:obt:semiMajorAxis-a).}
    local nd is sk(list(0),mknd@,eval@).
    add nd. ex().
  }).
}