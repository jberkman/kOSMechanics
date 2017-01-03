{
  local TGT_APO is 4870762.
  local TGT_PERI is 4295135.
  local TGT_AOP is 228.6.
  local ex is get("lib/exec-node.ks").
  local sk is get("lib/find-node.ks").
  local burn is get("lib/sma-burn.v2.ks").
  local steer is get("lib/steer-to-dir.ks").
  local l is get("lib/hlog.ks").
  put(get("lib/fsm.ks")({parameter seq, ev, next.
    function trackSun{lock steering to lookDirUp(north:vector,-sun:position).steer().}
    function progradeNode{
      local a is (obt:semiMajorAxis+TGT_APO+body:radius)/2.
      local t is time:seconds+obt:period/2.
      function mknd{parameter n.return Node(t,0,0,n[0]).}
      function eval{parameter n.return -abs(TGT_APO-n:obt:apoapsis).}
      return sk(list(0),mknd@,eval@).
    }
    function aopNode{
      local nd is progradeNode().
      function mknd{parameter n.return Node(n[0],0,0,nd:prograde).}
      function eval{parameter n.return -abs(TGT_AOP-n:obt:argumentOfPeriapsis).}
      return sk(list(time:seconds+nd:eta),mknd@,eval@).
    }
    seq:add({wait until ship:modulesNamed("kOSProcessor"):length=1 and altitude>body:atm:height. wait 10. next().}).
    seq:add({
      trackSun().
      local a is apoapsis+body:radius.
      local t is time:seconds+eta:apoapsis.
      burn(t,a).
      next().
    }).
    seq:add({
      trackSun().
      local nd is aopNode().
      add nd.
      wait 0.
      ex().
      next().
    }).
    seq:add({
      trackSun().
      local a is (apoapsis+TGT_PERI)/2+body:radius.
      local t is time:seconds+eta:apoapsis.
      burn(t,a).
      next().
    }).
    seq:add({trackSun().wait until not ship:messages:empty.}).
  })).
}