{
  local ex is get("lib/exec-node.ks").
  local sk is get("lib/find-node.ks").
  put({parameter t,a.
    function mknd{parameter n.return Node(t,0,0,n[0]).}
    function eval{parameter n.return -abs(n:obt:semiMajorAxis-a).}
    local nd is sk(list(0),mknd@,eval@).
    add nd. ex().
  }).
}