{
  local exec is get("lib/exec-node.ks").
  local find is get("lib/find-node.v2.ks").
  local findAlt is get("lib/finders.v2/altitude.ks").
  local fsm is get("lib/fsm.ks").
  local l is get("lib/hlog.ks").
  local seek is get("lib/hill-climb.v2.ks").
  local unwarp is get("lib/kill-warp.ks").
  local xferMap is get("lib/finders.v2/transfer-map.ks").
  local xferObt is get("lib/transfer-obt.ks").
  put({parameter dst,apo,peri,inc,aop,an,idle.
    fsm({parameter seq,ev,next.
      local lock tApo to time:seconds+eta:apoapsis.
      local lock tPeri to time:seconds+eta:periapsis.
      seq:add({wait until ship:modulesNamed("kOSProcessor"):length=1 and altitude>body:atm:height. wait 10. next().}).
      seq:add({
        if altitude>dst:altitude/2 next().
        l("Plotting mid-course correction").idle().
        local hc is seek().
        hc["add"](dst:altitude/2,0,findAlt@).
        local nd is find(hc,Node(time:seconds+obt:nextPatchETA/2,0,0,0),List(obt:nextPatchETA/4,0,0,0)).
        set hc to seek().
        hc["add"](apo,500,xferMap(dst,{parameter o.if o:apoapsis>0 return o:apoapsis. return 2^32.})).
        hc["add"](180,0.1,xferMap(dst,{parameter o.return o:argumentOfPeriapsis.})).
        exec(find(hc,nd,List(0,1,1,1))).
        next().
      }).
      seq:add({
        l("Coasting to SOI change").idle().
        wait until body=dst.
        unwarp().next().
      }).
      seq:add({
        l("Adjusting intercept").idle().
        local gAOP is 0.
        if inc>60 and inc<120 set gAOP to 90.
        else if obt:argumentOfPeriapsis>90 set gAOP to 180.
        exec(find(Node(time:seconds+60,0,0,0),List(0,10,10,10),findAOP(gAOP))).
        next().
      }).
      seq:add({
        l("Capturing").idle().
        add find(Node(tPeri,0,0,-100),List(0,0,0,100),findEcc()).
      }).
      seq:add({idle().wait until not ship:messages:empty.}).
    })().
  }).
}