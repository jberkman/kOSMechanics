{
  local burn is get("lib/sma-burn.v2.ks").
  local extend is get("lib/extend-antennae.ks").
  local steer is get("lib/steer-to-dir.ks").
  local l is get("lib/hlog.ks").
  put(get("lib/fsm.ks")({parameter seq, ev, next.
    function trackSun{lock steering to lookDirUp(north:vector,-sun:position).steer().}
    seq:add({
      wait until ship:modulesNamed("kOSProcessor"):length=1.
      wait 10.
      extend().
      next().
    }).
    seq:add({trackSun().next().}).
    seq:add({
      local a is (apoapsis+4055773)/2+body:radius.
      local t is time:seconds+eta:apoapsis.
      burn(t,a).
      next().
    }).
    seq:add({trackSun().next().}).
    seq:add({
      local a is (apoapsis+4235048)/2+body:radius.
      local t is time:seconds+eta:apoapsis.
      burn(t,a).
      next().
    }).
    seq:add({trackSun().wait until not ship:messages:empty.}).
  })).
}