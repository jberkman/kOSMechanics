{
  local altAt is get("lib/altitude-at.ks").
  local exec is get("lib/exec-node.ks").
  local find is get("lib/find-node.v2.ks").
  local findXfer is get("lib/finders.v2/closest-approach.ks").
  local fsm is get("lib/fsm.ks").
  local gss is get("lib/golden-section-search.ks").
  local l is get("lib/hlog.ks").
  local seek is get("lib/hill-climb.v2.ks").
  local unwarp is get("lib/kill-warp.ks").
  local x2 is get("lib/transfers-to.ks").
  local xferMap is get("lib/finders.v2/transfer-map.ks").
  local xferETA is get("lib/transfer-eta.ks").
  put({parameter dst,apo,peri,inc,aop,lan,idle.
    set inc to max(0.5,min(179.5,inc)).
    function mcb{
      local t is xferETA(obt,dst).
      local h is obt:periapsis/2.
      if altitude>dst:altitude set h to obt:apoapsis/2.
      set h to h+dst:altitude/2.
      return Node(gss(time:seconds,time:seconds+t,60,{parameter t.return abs(altAt(t)-h).}),0,0,0).
    }
    fsm({parameter seq,ev,next.
      local lock tApo to time:seconds+eta:apoapsis.
      local lock tPeri to time:seconds+eta:periapsis.
      seq:add({wait until ship:modulesNamed("kOSProcessor"):length=1 and altitude>body:atm:height. wait 10. next().}).
      seq:add({
        if x2(obt,dst){next().return.}
        l("Performing transfer correction burn").idle().
        local hc is seek().
        hc["add"](dst:radius*0.9,0,findXfer(dst)).
        exec(find(hc,Node(time:seconds+180,0,0,0),List(0,10,10,10)),1).
        next().
      }).
      seq:add({
        if altitude>dst:altitude/2{next().return.}
        l("Plotting mid-course correction").idle().
        local nd is mcb().if nd:eta<0 next().
        set hc to seek().
        hc["add"](inc,30,xferMap(dst,{parameter o.return o:inclination.})).
        set nd to find(hc,nd,List(0,10,10,10)).
        hc["add"](apo,0.01*apo,xferMap(dst,{parameter o.return o:periapsis.})).
        set nd to find(hc,nd,List(0,10,10,10)).
        hc["add"](90,0.5,xferMap(dst,{parameter o.return abs(mod(o:argumentOfPeriapsis,180)-90).})).
        exec(find(hc,nd,List(0,10,10,10)),1).
        next().
      }).
      seq:add({
        l("Coasting to SOI change").idle().
        if 1 warpTo(time:seconds+xferETA(obt,dst)-30).
        wait until body=dst.
        unwarp().next().
      }).
      seq:add({
        l("Adjusting intercept").idle().
        local hc is seek().
        hc["add"](inc,30,{parameter n.return n:obt:inclination.}).
        local nd is find(hc,Node(time:seconds+180,0,0,0),List(0,10,10,0)).
        hc["add"](apo,0.01*apo,{parameter n.return n:obt:periapsis.}).
        set nd to find(hc,nd,List(0,10,10,0)).
        hc["add"](90,0.5,xferMap(dst,{parameter o.return abs(mod(o:argumentOfPeriapsis,180)-90).})).
        exec(find(hc,nd,List(0,10,10,0)),1).
        next().
      }).
      seq:add({
        l("Capturing").idle().
        local hc is seek().
        hc["add"](0,0.001,{parameter n.return n:obt:eccentricity.}).
        local v is velocityAt(ship,time:seconds+eta:periapsis):orbit:mag.
        local nd is find(hc,Node(time:seconds+eta:periapsis,0,0,-v/10),List(0,0,0,v/10)).
        local i is 0. if inc>90 set i to 180.
        hc["add"](i,0,{parameter n.return n:obt:inclination.}).
        exec(find(hc,nd,List(0,10,100,10)),1).
        next().
      }).
      seq:add({
        l("Performing inclination change").idle().
        local hc is seek().
        hc["add"](lan,0.5,{parameter n.return n:obt:longitudeOfAscendingNode.}).
        local nd is find(hc,Node(time:seconds+obt:period/2,0,obt:velocity:orbit:mag/2,0),List(obt:period/36,0,0,0)).
        hc["add"](inc,0,{parameter n.return n:obt:inclination.}).
        hc["add"](0,0.001,{parameter n.return n:obt:eccentricity.}).
        set nd:normal to 0.
        set nd to find(hc,nd,List(0,10,10,10)).
        if nd:eta<30 set nd:eta to nd:eta+obt:period.
        exec(nd,1).
        next().
      }).
      seq:add({
        l("Performing final adjustment").idle().
        local hc is seek().
        hc["add"](aop,0.5,{parameter n.return n:obt:argumentOfPeriapsis.}).
        local nd is find(hc,Node(time:seconds+obt:period/2,0,0,-obt:velocity:orbit:mag/2),List(obt:period/36,0,0,0)).
        hc["add"](peri,0.005*peri,{parameter n.return n:obt:periapsis.}).
        set nd:prograde to 0.
        set nd to find(hc,nd,List(0,0,0,10)).
        if nd:eta<30 set nd:eta to nd:eta+obt:period.
        exec(nd,1).
        next().
      }).
      seq:add({idle().wait until not ship:messages:empty.}).
    })().
  }).
}