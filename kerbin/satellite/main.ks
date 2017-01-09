{
  local exec is get("lib/exec-node.ks").
  local find is get("lib/find-node.ks").
  local fsm is get("lib/fsm.ks").
  local l is get("lib/hlog.ks").
  local findAN is get("lib/finders/ascending-node.ks").
  local findAOP is get("lib/finders/aop.ks").
  local findApo is get("lib/finders/apoapsis.ks").
  local findEcc is get("lib/finders/eccentricity.ks").
  local findInc is get("lib/finders/inclination.ks").
  local findPeri is get("lib/finders/periapsis.ks").
  put({parameter apo,peri,inc,aop,idle.
    fsm({parameter seq,ev,next.
      function aopNode{
        return nd.
      }
      local lock tApo to time:seconds+eta:apoapsis.
      local lock tPeri to time:seconds+eta:periapsis.
      seq:add({wait until ship:modulesNamed("kOSProcessor"):length=1 and altitude>body:atm:height. wait 10. next().}).
      seq:add({
        if periapsis<body:atm:height and apoapsis<0.99*peri{
          l("Boosting into stable orbit.").idle().
          exec(find(Node(tApo,0,0,100),List(0,0,0,100),findPeri(body:atm:height+10000))).
        }
        next().
      }).
      seq:add({
        if apoapsis<0.99*peri{
          l("Boosting into transfer orbit.").idle().
          exec(find(Node(tPeri,0,0,100),List(0,0,0,100),findApo(peri))).
        }
        next().
      }).
      seq:add({
        l("Boosting into parking orbit.").idle().
        exec(find(Node(tApo,0,0,100),List(0,0,0,100),findEcc())).
        next().
      }).
      seq:add({
        l("Adjusting inclination.").idle().
        local nd is Node(time:seconds+obt:period/2,0,100,0).
        set nd to find(nd,List(obt:period/20,0,0,0),findAN@).
        set nd:normal to 0.
        set nd to find(nd,List(0,0,100,0),findInc(inc)).
        if nd:eta<300 set nd:eta to nd:eta+obt:period.
        exec(nd).next().
      }).
      seq:add({
        l("Boosting into final orbit.").idle().
        local nd is Node(time:seconds+obt:period/2,0,0,100).
        set nd to find(nd,List(obt:period/20,0,0,0),findAOP(aop)).
        set nd to find(nd,List(0,0,0,100),findApo(apo)).
        if nd:eta<300 set nd:eta to nd:eta+obt:period.
        exec(nd).next().
      }).
      seq:add({idle().wait until not ship:messages:empty.}).
    })().
  }).
}