{
  local burn is get("lib/sma-burn.v2.ks").
  local ex is get("lib/exec-node.ks").
  local fsm is get("lib/fsm.ks").
  local sk is get("lib/find-node.ks").
  put({parameter apo,peri,aop,idle.
    fsm({parameter seq,ev,next.
      function progradeNode{
        local a is (obt:semiMajorAxis+apo+body:radius)/2.
        local t is time:seconds+obt:period/2.
        function mknd{parameter n.return Node(t,0,0,n[0]).}
        function eval{parameter n.return -abs(apo-n:obt:apoapsis).}
        return sk(list(0),mknd@,eval@).
      }
      function aopNode{
        local nd is progradeNode().
        function mknd{parameter n.return Node(n[0],0,0,nd:prograde).}
        function eval{parameter n.return -abs(aop-n:obt:argumentOfPeriapsis).}
        local nd is sk(list(time:seconds+nd:eta),mknd@,eval@).
        if nd:eta>60 return nd.
        return sk(list(time:seconds+nd:eta+obt:period),mknd@,eval@).
      }
      seq:add({wait until ship:modulesNamed("kOSProcessor"):length=1 and altitude>body:atm:height. wait 10. next().}).
      if aop<0 seq:add({idle().burn(time:seconds+eta:apoapsis,(apoapsis+apo)/2+body:radius).next().}).
      else{
        seq:add({idle().burn(time:seconds+eta:apoapsis,apoapsis+body:radius).next().}).
        seq:add({idle().local nd is aopNode().add nd. wait 0. ex().next().}).
      }
      seq:add({idle().burn(time:seconds+eta:apoapsis,(apoapsis+peri)/2+body:radius).next().}).
      seq:add({idle().wait until not ship:messages:empty.}).
    })().
  }).
}