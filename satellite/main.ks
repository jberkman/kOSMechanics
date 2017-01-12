{
  local exec is get("lib/exec-node.ks").
  local find is get("lib/find-node.ks").
  local fsm is get("lib/fsm.ks").
  local l is get("lib/hlog.ks").
  local findAlt is get("lib/finders/altitude.ks").
  local findInt is get("lib/finders/intercept.ks").
  local findAN is get("lib/finders/ascending-node.ks").
  local findAOP is get("lib/finders/aop.ks").
  local findApo is get("lib/finders/apoapsis.ks").
  local findEcc is get("lib/finders/eccentricity.ks").
  local findInc is get("lib/finders/inclination.ks").
  local findPeri is get("lib/finders/periapsis.ks").
  local findXferAOP is get("lib/finders/transfer-aop.ks").
  local findXferInc is get("lib/finders/transfer-inclination.ks").
  local findXferPeri is get("lib/finders/transfer-periapsis.ks").
  local unwarp is get("lib/kill-warp.ks").
  local xferObt is get("lib/transfer-obt.ks").
  put({parameter dst,apo,peri,inc,aop,an,idle.
    fsm({parameter seq,ev,next.
      local lock tApo to time:seconds+eta:apoapsis.
      local lock tPeri to time:seconds+eta:periapsis.
      seq:add({wait until ship:modulesNamed("kOSProcessor"):length=1 and altitude>body:atm:height. wait 10. next().}).
      seq:add({
        if altitude>dst:altitude/2 next().
        l("Plotting mid-course correction").idle().
        local xo is xferObt(obt,dst).
        local gAOP is 0.
        if inc>60 and inc<120 set gAOP to 90.
        else if xo:argumentOfPeriapsis>90 set gAOP to 180.
        local nd is find(Node(time:seconds+obt:nextPatchETA/2,0,0,0),List(obt:nextPatchETA/4,0,0,0),findAlt(dst:altitude/2)).
        set xo to xferObt(obt,dst).
        if xo:inclination<90 and inc>90{
          set nd to find(nd,List(0,1,1,1),findXferInc(dst,180-xo:inclination)).
        }
        exec(find(nd,List(0,1,1,1),findXferAOP(dst,gAOP))).
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