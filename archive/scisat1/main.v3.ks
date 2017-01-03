{
  local burn is get("lib/sma-burn.v2.ks").
  local l is get("lib/hlog.ks").
  local steer is get("lib/steer-to-dir.ks").
  put(get("lib/fsm.ks")({parameter states, events, next.
    states:add({l("Tracking Sun...").lock steering to lookDirUp(north:vector,-sun:position).steer().next().}).
    states:add({l("Adjusting orbit...").
      local a is (169742+apoapsis)/2+body:radius.
      local t is time:seconds+eta:apoapsis.
      burn(t,a).
      next().
    }).
    states:add({l("Tracking Sun...").lock steering to lookDirUp(north:vector,-sun:position).wait until not ship:messages:empty.}).
  })).
}