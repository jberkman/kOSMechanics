{
  local exec is get("lib/exec-node.ks").
  local find is get("lib/find-node.v2.ks").
  local findAlt is get("lib/finders.v2/altitude.ks").
  local fsm is get("lib/fsm.ks").
  local l is get("lib/hlog.ks").
  local seek is get("lib/hill-climb.v2.ks").
  local unwarp is get("lib/kill-warp.ks").
  local xferMap is get("lib/finders.v2/transfer-map.ks").
  local xferETA is get("lib/transfer-eta.ks").
  local xferObt is get("lib/transfer-obt.ks").
  put({parameter dst,apo,peri,inc,aop,an,idle.
    function mcb{
      local t is xferETA(obt,dst).
      local h is obt:periapsis.
      if altitude>dst:altitude set h to obt:apoapsis.
      local hc is seek().
      hc["add"](h+dst:altitude/2,0,findAlt@).
      return find(hc,Node(time:seconds+t,0,0,0),List(t/4,0,0,0)).
    }
    function intAOP{parameter y1,y2.
      local p is 0. if y1<y2 set p to 1.
      local q is 0. if inc>90 set q to 1.
      if mod(p+q,2)return 180.
      return 0.
    }
    fsm({parameter seq,ev,next.
      local lock tApo to time:seconds+eta:apoapsis.
      local lock tPeri to time:seconds+eta:periapsis.
      seq:add({wait until ship:modulesNamed("kOSProcessor"):length=1 and altitude>body:atm:height. wait 10. next().}).
      seq:add({
        if altitude>dst:altitude/2 next().
        l("Plotting mid-course correction").idle().
        local nd is mcb().if nd:eta>0{
          set hc to seek().

          hc["add"](inc,30,xferMap(dst,{parameter o.return o:inclination.})).
          set nd to find(hc,nd,List(0,1,1,1)).

          hc["add"](apo,500,xferMap(dst,{parameter o.if o:apoapsis>0 return o:apoapsis. return 2^32.})).
          local y1 is positionAt(ship,time:seconds+nd:eta):y.
          local y2 is positionAt(dst,time:seconds+xferETA(obt,dst)):y.   
          print "y1: "+round(y1/1000)+" y2: "+round(y2/1000).
          hc["add"](intAOP(y1,y2),0.5,xferMap(dst,{parameter o.return o:argumentOfPeriapsis.})).
          set nd to find(hc,nd,List(0,1,1,1)).
          exec(find(hc,nd,List(0,1,1,1))).
        }
        next().
      }).
      seq:add({
        l("Coasting to SOI change").idle().
        wait until body=dst.
        unwarp().next().
      }).
      seq:add({
        l("Adjusting intercept").idle().
        set hc to seek().
        hc["add"](inc,45,{parameter n.return n:inclination.}).
        hc["add"](apo,500,{parameter n.return n:apoapsis.}).
        hc["add"](intAOP(ship:position:y,dst:position:y),0.1,xferMap(dst,{parameter o.return o:argumentOfPeriapsis.})).
        exec(find(hc,nd,List(0,1,1,1))).
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