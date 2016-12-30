{
  local b is get("lib/sma-burn.ks").
  local e is get("lib/extend-antennae.ks").
  local l is get("lib/hlog.ks").
  put(get("lib/fsm.ks")({parameter states, events, next.
    states:add({l("Waiting for burn...").b(169568,periapsis,{return eta:periapsis.}).next().}).
    states:add({l("Waiting for burn #2...").b(99413,apoapsis,{return eta:apoapsis.}).next().}).
    states:add({l("Tracking Sun...").lock steering to lookDirUp(north:vector,-sun:position).wait until not ship:messages:empty.}).
  })).
}