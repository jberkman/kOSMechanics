{
  local burn is get("lib/sma-burn.v2.ks").
  local ex is get("lib/exec-node.ks").
  local fsm is get("lib/fsm.ks").
  local l is get("lib/hlog.ks").
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
      seq:add({
        if apoapsis<0.99*peri and periapsis<body:atm:height{
          l("Boosting into stable orbit.").idle().
          burn(time:seconds+eta:apoapsis,(apoapsis+body:atm:height+10000)/2+body:radius).
        }
        next().
      }).
      seq:add({
        if apoapsis<0.99*peri{
          l("Boosting into transfer orbit.").idle().
          burn(time:seconds+eta:periapsis,(periapsis+peri)/2+body:radius).
        }
        next().
      }).
      seq:add({
        l("Boosting into parking orbit.").idle().
        burn(time:seconds+eta:apoapsis,apoapsis+body:radius).
        next().
      }).
      seq:add({
        l("Boosting into final orbit.").idle().
        local nd is aopNode().add nd. wait 0. ex().next().}).
      }
      seq:add({idle().wait until not ship:messages:empty.}).
    })().
  }).
}