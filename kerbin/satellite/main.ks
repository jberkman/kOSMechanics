{
  local exec is get("lib/exec-node.ks").
  local find is get("lib/find-node.ks").
  local fsm is get("lib/fsm.ks").
  local l is get("lib/hlog.ks").
  put({parameter apo,peri,aop,idle.
    fsm({parameter seq,ev,next.
      function progradeNode{
        local a is (obt:semiMajorAxis+apo+body:radius)/2.
        local t is time:seconds+obt:period/2.
        return find(Node(t,0,0,0),List(0,0,0,100),{parameter n.return-abs(apo-n:obt:apoapsis).}).
      }
      function aopNode{
        local pn is progradeNode().
        local st is List(obt:period/10,0,0,0).
        function eval{parameter n.return-abs(aop-n:obt:argumentOfPeriapsis).}
        local nd is find(pn,st,eval@).if nd:eta>300 return nd.
        set pn:eta to pn:eta+obt:period. return find(pn,st,eval@).
      }
      seq:add({wait until ship:modulesNamed("kOSProcessor"):length=1 and altitude>body:atm:height. wait 10. next().}).
      seq:add({
        if apoapsis<0.99*peri and periapsis<body:atm:height{
          l("Boosting into stable orbit.").idle().
          exec(find(Node(time:seconds+eta:apoapsis,0,0,100),List(0,0,0,100),{parameter n.return-abs(n:obt:periapsis-body:atm:height-1000).})).
        }
        next().
      }).
      seq:add({
        if apoapsis<0.99*peri{
          l("Boosting into transfer orbit.").idle().
          exec(find(Node(time:seconds+eta:periapsis,0,0,100),List(0,0,0,100),{parameter n.return-abs(n:obt:apoapsis-peri).})).
        }
        next().
      }).
      seq:add({
        l("Boosting into parking orbit.").idle().
        exec(find(Node(time:seconds+eta:apoapsis,0,0,100),List(0,0,0,100),{parameter n.return-abs(n:obt:semiMajorAxis-peri-body:radius).})).
        next().
      }).
      seq:add({
        l("Boosting into final orbit.").idle().
        exec(aopNode()).next().
      }).
      seq:add({idle().wait until not ship:messages:empty.}).
    })().
  }).
}