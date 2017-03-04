put(get("lib/fsm.ks")({parameter seq,ev,next.
  local l is get("lib/hlog.ks").
  local m is get("lib/mission.ks").
  function v{parameter m,k,d.if m:hasKey(k)return m[k].return d.}
  local b is v(m,"body",Kerbin).
  print "body:"+b.
  local apo is v(m,"apo",b:atm:height+10000).
  local peri is v(m,"peri",apo).
  local inc is max(0.5,min(179.5,v(m,"inc",0))).
  local lan is v(m,"lan",-1).
  local aop is v(m,"aop",-1).
  local idle is v(m,"idle",{}).
  local lock tApo to time:seconds+eta:apoapsis.
  local lock tPeri to time:seconds+eta:periapsis.
  local exec is get("lib/exec-node-state.ks"):bind(next,1).
  local find is get("lib/find-node.v4.ks").
  local hal9k is get("lib/hal.v1.ks").
  seq:add({l("Ready to launch").wait until ship:modulesNamed("kOSProcessor"):length=1 and altitude>body:atm:height. wait 10. next().}).
  if b=Kerbin{
    seq:add({
      if periapsis>body:atm:height or abs(apoapsis-peri)<0.005*peri{next().next().return.}
      l("Raising periapsis").
      local hal is hal9k().
      hal["add"](1000,{parameter n.return n:obt:periapsis-b:atm:height-10000.}).
      add find(hal,Node(time:seconds+eta:apoapsis,0,0,100),List(0,0,0,100)).
      next().
    }).
    seq:add(exec@).
    seq:add({
      if abs(apoapsis-peri)<0.005*peri{next().next().return.}
      l("Raising apoapsis").
      local hal is hal9k().
      hal["add"](1000,{parameter n.return n:obt:apoapsis-peri.}).
      add find(hal,Node(time:seconds+eta:periapsis,0,0,100),List(0,0,0,100)).
      next().
    }).
    seq:add(exec@).
    seq:add({
      l("Circularizing to parking orbit").
      local hal is hal9k().
      hal["add"](0.005,{parameter n.return n:obt:eccentricity.}).
      add find(hal,Node(time:seconds+eta:apoapsis,0,0,100),List(0,0,0,100)).
      next().
    }).
    seq:add(exec@).
  }else{
    local findXfer is get("lib/finders.v2/closest-approach.ks").
    local x2 is get("lib/transfers-to.ks").
    seq:add({
      if x2(obt,b){next().next().return.}
      l("Performing transfer correction burn").idle().
      local hal is hal9k().
      hal["add"](b:SOIRadius/4,findXfer(b)).
      add find(hal,Node(time:seconds+180,0,0,0),List(0,10,10,10)).
      next().
    }).
    seq:add(exec@).
    local altAt is get("lib/altitude-at.ks").
    local gss is get("lib/golden-section-search.ks").
    local xferETA is get("lib/transfer-eta.ks").
    seq:add({
      if not x2(obt,b){next(-2).return.}
      if altitude>b:altitude/2{next().next().return.}
      l("Plotting mid-course correction").idle().
      local nd is 0.
      {
        local t is xferETA(obt,b).
        local h is obt:periapsis/2.
        if altitude>b:altitude set h to obt:apoapsis/2.
        set h to h+b:altitude/2.
        set nd to Node(gss(time:seconds,time:seconds+t,60,{parameter t.return abs(altAt(t)-h).}),0,0,0).
      }
      if nd:eta<0 next().
      local hal is hal9k().
      local goalInc is 0.
      if inc>90 set goalInc to 180.
      hal["add"](30,xferMap(b,{parameter o.return o:inclination-goalInc.})).
      hal["add"](1000,xferMap(b,{parameter o.return o:periapsis-apo.})).
      hal["add"](5,xferMap(b,{parameter o.local r is abs(mod(o:argumentOfPeriapsis,180)-90). return r-90.})).
      add find(hal,nd,List(0,5,5,5)).
      next().
    }).
    seq:add(exec@).
    local unwarp is get("lib/kill-warp.ks").
    seq:add({
      l("Coasting to SOI change").idle().
      if 1 warpTo(time:seconds+xferETA(obt,b)-30).
      wait until body=b.
      unwarp().next().
    }).
    local xferMap is get("lib/finders.v2/transfer-map.ks").
    seq:add({until 0{
      l("Adjusting intercept").idle().
      local hal is hal9k().
      local goalInc is 0.
      if inc>90 set goalInc to 180.
      local goalEps is 15.
      if abs(obt:inclination-goalInc)<2 set goalEps to 2.
      hal["add"](goalEps,{parameter n.return n:obt:inclination-goalInc.}).
      hal["add"](500,{parameter n.return n:obt:periapsis-apo.}).
      if abs(obt:inclination-goalInc)>2{
        hal["add"](1,xferMap(b,{parameter o.return abs(mod(o:argumentOfPeriapsis,180)-90)-90.})).
      }
      add find(hal,Node(time:seconds+180,0,0,0),List(0,10,10,1)).
      if nextNode:eta>30 break.
      }next().if nextNode:deltaV:mag<0.1 next().
    }).
    seq:add(exec@).
    seq:add({
      l("Capturing").idle().
      local hal is hal9k().
      hal["add"](0.01,{parameter n.
        //print round(n:obt:eccentricity,4).
        return n:obt:eccentricity.}).
      //hal["add"](1000,{parameter n.return n:obt:apoapsis-n:obt:periapsis.}).
      local v2 is velocityAt(ship,time:seconds+eta:periapsis):orbit:mag.
      local nd is find(hal,Node(time:seconds+eta:periapsis,0,0,-v2/10),List(0,0,0,100)).
      local i is 0. if inc>90 set i to 180.
      hal["add"](1.5,{parameter n.
        //print round(n:obt:inclination,4).
        return n:obt:inclination-i.}).
      add find(hal,nd,List(0,0,25,25)).
      next().
    }).
    seq:add(exec@).
    seq:add({
      l("Performing inclination change").idle().
      local hal is hal9k().
      hal["add"](0.5,{parameter n.return n:obt:longitudeOfAscendingNode-lan.}).
      local nd is find(hal,Node(time:seconds+obt:period/2,0,obt:velocity:orbit:mag/10,0),List(obt:period/36,0,0,0)).
      hal["add"](0.5,{parameter n.return n:obt:inclination-inc.}).
      hal["add"](0.01,{parameter n.return n:obt:eccentricity.}).
      add find(hal,nd,List(30,0,50,10)).
      until nextNode:eta>30 set nextNode:eta to nextNode:eta+obt:period.
      next().
    }).
    seq:add(exec@).
  }
  seq:add({
    l("Adjusting argument of periapsis").idle().
    local hal is hal9k().
    local nd is Node(time:seconds+obt:period/2,0,0,0).
    if aop>=0{
      set nd:prograde to obt:velocity:orbit:mag/10.
      if b<>Kerbin set nd:prograde to-nd:prograde.
      hal["add"](0.5,{parameter n.return n:obt:argumentOfPeriapsis-aop.}).
      set nd to find(hal,nd,List(obt:period/36,0,0,0)).
      set hal to hal9k().
    }
    if b=Kerbin hal["add"](0.5,{parameter n.return n:obt:apoapsis-apo.}).
    else hal["add"](0.5,{parameter n.return n:obt:periapsis-peri.}).
    add find(hal,nd,List(0,0,0,10)).
    if nextNode:eta<30 set nextNode:eta to nextNode:eta+obt:period.
    next().
  }).
  seq:add(exec@).
  seq:add({
    l("Performing final adjustment").idle().
    local hal is hal9k().
    local nd is Node(0,0,0,0).
    if b=Kerbin{
      set nd:eta to eta:apoapsis.
      hal["add"](0.5,{parameter n.return n:obt:periapsis-peri.}).
    }else{
      set nd:eta to eta:periapsis.
      hal["add"](0.5,{parameter n.return n:obt:apoapsis-apo.}).
    }
    add find(hal,nd,List(0,0,0,10)).
    if nextNode:eta<30 set nextNode:eta to nextNode:eta+obt:period.
    next().
  }).
  seq:add(exec@).
  seq:add({idle().wait until not ship:messages:empty.}).
})).