put(get("lib/fsm.ks")({parameter seq,ev,next.
  local l is get("lib/hlog.ks").
  local m is get("lib/mission.ks").
  function v{parameter m,k,d.if m:hasKey(k)return m[k].return d.}
  local b is v(m,"body",Kerbin).
  local apo is v(m,"apo",b:atm:height+10000).
  local peri is v(m,"peri",apo).
  local inc is max(0.5,min(179.5,v(m,"inc",0))).
  local lan is v(m,"lan",-1).
  local aop is v(m,"aop",-1).
  local idle is v(m,"idle",{}).
  local lock tApo to time:seconds+eta:apoapsis.
  local lock tPeri to time:seconds+eta:periapsis.
  local exec is get("lib/exec-node.ks").
  local find is get("lib/find-node.v2.ks").
  local seek is get("lib/hill-climb.v2.ks").
  seq:add({l("Ready to launch").wait until ship:modulesNamed("kOSProcessor"):length=1 and altitude>body:atm:height. wait 10. next().}).
  if b=Kerbin{
    seq:add({
      if abs(apoapsis-peri)<0.005*peri{next().return.}
      l("Raising periapsis").
      local hc is seek().
      hc["add"](b:atm:height+10000,0,{parameter n.return n:obt:periapsis.}).
      exec(find(hc,Node(time:seconds+eta:apoapsis,0,0,100),List(0,0,0,100)),1).
      next().
    }).
    seq:add({
      if abs(apoapsis-peri)<0.005*peri{next().return.}
      l("Raising apoapsis").
      local hc is seek().
      hc["add"](peri,0,{parameter n.return n:obt:apoapsis.}).
      exec(find(hc,Node(time:seconds+eta:periapsis,0,0,100),List(0,0,0,100)),1).
      next().
    }).
    seq:add({
      l("Circularizing to parking orbit").
      local hc is seek().
      hc["add"](0,0,{parameter n.return n:obt:eccentricity.}).
      exec(find(hc,Node(time:seconds+eta:apoapsis,0,0,100),List(0,0,0,100)),1).
      next().
    }).
  }else{
    local findXfer is get("lib/finders.v2/closest-approach.ks").
    local x2 is get("lib/transfers-to.ks").
    seq:add({
      if x2(obt,b){next().return.}
      l("Performing transfer correction burn").idle().
      local hc is seek().
      hc["add"](b:radius*0.9,10000,findXfer(b)).
      exec(find(hc,Node(time:seconds+180,0,0,0),List(0,10,10,10)),1).
      next().
    }).
    local altAt is get("lib/altitude-at.ks").
    local gss is get("lib/golden-section-search.ks").
    local xferETA is get("lib/transfer-eta.ks").
    seq:add({
      if altitude>b:altitude/2{next().return.}
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
      set hc to seek().
      hc["add"](inc,30,xferMap(b,{parameter o.return o:inclination.})).
      set nd to find(hc,nd,List(0,10,10,10)).
      hc["add"](apo,0.01*apo,xferMap(b,{parameter o.return o:periapsis.})).
      set nd to find(hc,nd,List(0,10,10,10)).
      hc["add"](90,0.5,xferMap(b,{parameter o.return abs(mod(o:argumentOfPeriapsis,180)-90).})).
      exec(find(hc,nd,List(0,10,10,10)),1).
      next().
    }).
    local unwarp is get("lib/kill-warp.ks").
    seq:add({
      l("Coasting to SOI change").idle().
      if 1 warpTo(time:seconds+xferETA(obt,b)-30).
      wait until body=b.
      unwarp().next().
    }).
    local xferMap is get("lib/finders.v2/transfer-map.ks").
    seq:add({
      l("Adjusting intercept").idle().
      local hc is seek().
      hc["add"](inc,30,{parameter n.return n:obt:inclination.}).
      local nd is find(hc,Node(time:seconds+180,0,0,0),List(0,10,10,0)).
      hc["add"](apo,0.01*apo,{parameter n.return n:obt:periapsis.}).
      set nd to find(hc,nd,List(0,10,10,0)).
      hc["add"](90,0.5,xferMap(b,{parameter o.return abs(mod(o:argumentOfPeriapsis,180)-90).})).
      exec(find(hc,nd,List(0,10,10,0)),1).
      next().
    }).
    seq:add({
      l("Capturing").idle().
      local hc is seek().
      hc["add"](0,0.001,{parameter n.return n:obt:eccentricity.}).
      local v2 is velocityAt(ship,time:seconds+eta:periapsis):orbit:mag.
      local nd is find(hc,Node(time:seconds+eta:periapsis,0,0,-v2/10),List(0,0,0,v2/10)).
      local i is 0. if inc>90 set i to 180.
      hc["add"](i,0.05,{parameter n.return n:obt:inclination.}).
      exec(find(hc,nd,List(0,10,100,10)),1).
      next().
    }).
    seq:add({
      l("Performing inclination change").idle().
      local hc is seek().
      hc["add"](lan,0.5,{parameter n.return n:obt:longitudeOfAscendingNode.}).
      local nd is find(hc,Node(time:seconds+obt:period/2,0,obt:velocity:orbit:mag/2,0),List(obt:period/36,0,0,0)).
      hc["add"](inc,0.05,{parameter n.return n:obt:inclination.}).
      hc["add"](0,0.02,{parameter n.return n:obt:eccentricity.}).
      set nd:normal to 0.
      set nd to find(hc,nd,List(0,0.1,10,10)).
      if nd:eta<30 set nd:eta to nd:eta+obt:period.
      exec(nd,1).
      next().
    }).
  }
  seq:add({
    l("Performing final adjustment").idle().
    local hc is seek().
    local nd is Node(time:seconds+obt:period/2,0,0,0).
    if aop>=0{
      set nd:prograde to obt:velocity:orbit:mag/2.
      if b<>Kerbin set nd:prograde to-nd:prograde.
      hc["add"](aop,0.05,{parameter n.return n:obt:argumentOfPeriapsis.}).
      set nd to find(hc,nd,List(obt:period/36,0,0,0)).
      set nd:prograde to 0.
    }
    if b=Kerbin hc["add"](apo,0.005*apo,{parameter n.return n:obt:apoapsis.}).
    else hc["add"](peri,0.005*peri,{parameter n.return n:obt:periapsis.}).
    set nd to find(hc,nd,List(0,0.1,0.1,10)).
    if nd:eta<30 set nd:eta to nd:eta+obt:period.
    exec(nd,1).
    next().
  }).
  seq:add({idle().wait until not ship:messages:empty.}).
})).