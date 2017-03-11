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
  local hohmann is get("lib/hohmann.v2.ks").
  local incdv is get("lib/inclination.v1.ks").
  seq:add({l("Ready to launch").wait until ship:modulesNamed("kOSProcessor"):length=1 and altitude>body:atm:height. wait 10. next().}).
  seq:add({if hasNode exec().else next().}).
  if b=Kerbin{
    seq:add({
      if periapsis>body:atm:height or abs(apoapsis-peri)<0.005*peri{next().next().return.}
      l("Raising periapsis").
      local h is b:atm:height+10000.
      local t is time:seconds+eta:apoapsis.
      add Node(t,0,0,hohmann(t,h)).
      next().
    }).
    seq:add(exec@).
    seq:add({
      if abs(apoapsis-peri)<0.005*peri{next().next().return.}
      l("Raising apoapsis").
      local t is time:seconds+eta:periapsis.
      add Node(t,0,0,hohmann(t,peri)).
      next().
    }).
    seq:add(exec@).
    seq:add({
      l("Circularizing to parking orbit").
      local t is time:seconds+eta:apoapsis.
      add Node(t,0,0,hohmann(t,peri)).
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
      //set nd to find(hal,nd,List(0,5,5,0)).
      //set hal to hal9k().
      hal["add"](1000,xferMap(b,{parameter o.return o:periapsis-apo.})).
      //set nd to find(hal,nd,List(0,5,5,0)).
      //hal["add"](1,xferMap(b,{parameter o.
      //  local a is abs(o:inclination-goalInc). if a<1 return a.
      //  return abs(mod(o:argumentOfPeriapsis,180)-90)-90.
      //})).
      add find(hal,nd,List(0,5,5,0)).
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
    seq:add({
      local hal is hal9k().
      hal["add"](0.5,xferMap(b,{parameter o.return abs(mod(o:argumentOfPeriapsis,180)-90)-90.})).
      l("Adjusting intercept").idle().
      until 0{
        add find(hal,Node(time:seconds+180,0,0,0),List(0,0,1,0)).
        if nextNode:eta>10 break.
      }next().if nextNode:deltaV:mag<0.1 next().
    }).
    seq:add(exec@).
    seq:add({
      l("Capturing").idle().
      local hal is hal9k().
      hal["add"](0.1,{parameter n. return n:obt:eccentricity.}).
      local i is 0. if inc>90 set i to 180.
      hal["add"](1.5,{parameter n.return n:obt:inclination-i.}).
      local t is time:seconds+eta:periapsis.
      local dv is hohmann(t,periapsis).
      add find(hal,Node(t,0,0,dv),List(0,0,0.05*dv,0.05*dv)).
      next().
    }).
    seq:add(exec@).
    seq:add({
      l("Circularizing").idle().
      local t is time:seconds+eta:periapsis.
      local nd is Node(t,0,0,hohmann(t,periapsis)).
      if nd:eta<30 set nd:eta to nd:eta+obt:period.
      add nd.
      next().
    }).
    seq:add(exec@).
    seq:add({
      l("Performing inclination change").idle().
      local hal is hal9k().
      local i is incdv(abs(obt:inclination-inc)).
      hal["add"](0.5,{parameter n.return n:obt:longitudeOfAscendingNode-lan.}).
      local nd is find(hal,Node(time:seconds+obt:period/2,0,i[0],i[1]),List(obt:period/36,0,0,0)).
      hal["add"](0.5,{parameter n.return n:obt:inclination-inc.}).
      hal["add"](0.01,{parameter n.return n:obt:eccentricity.}).
      add find(hal,nd,List(30,0,1,1)).
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
    if nd:eta<30 set nd:eta to nd:eta+obt:period.
    local t is time:seconds+nd:eta.
    if b=Kerbin set nd:prograde to hohmann(t,apo).
    else set nd:prograde to hohmann(t,peri).
    add nd.
    next().
  }).
  seq:add(exec@).
  seq:add({
    l("Performing final adjustment").idle().
    local nd is Node(0,0,0,0).
    if b=Kerbin{
      set nd:eta to eta:apoapsis.
      set nd:prograde to hohmann(time:seconds+nd:eta,peri).
    }else{
      set nd:eta to eta:periapsis.
      set nd:prograde to hohmann(time:seconds+nd:eta,apo).
    }
    if nd:eta<30 set nd:eta to nd:eta+obt:period.
    add nd.
    next().
  }).
  seq:add(exec@).
  seq:add({idle().wait until not ship:messages:empty.}).
})).