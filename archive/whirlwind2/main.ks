{
  local burn is get("lib/sma-burn.ks").
  local extend is get("lib/extend-antennae.ks").
  local science is get("lib/record-science.ks").
  local steer is get("lib/steer-to-dir").
  local l is get("lib/hlog.ks").
  put(get("lib/fsm.ks")({parameter states, events, next.
    local unwarp is {set warp to 0.wait until kUniverse:timeWarp:isSettled.}.
    local trackSun is {lock steering to lookDirUp(north:vector,-sun:position).}.
    states:add({wait until ship:modulesNamed("kOSProcessor"):length=1.next().}).
    states:add({
      lock steering to lookDirUp(prograde:vector,-up:vector).
      lock throttle to 1.
      wait until apoapsis>=mun:altitude or ship:maxThrust<1.
      lock throttle to 0.
      extend().
      next().
    }).
    states:add({trackSun().wait until altitude>250000.unwarp().wait 5.next().}).
    states:add({science(1).next().}).
    states:add({trackSun().wait until body=mun. unwarp().wait 5.next().}).
    states:add({science(1).next().}).
    states:add({
      lock steering to lookDirUp(retrograde:topVector,-up:vector).
      steer().lock throttle to 1.
      wait until periapsis<30000 or ship:maxThrust<1.
      lock throttle to 0.
      next().
    }).
    states:add({
      lock steering to lookDirUp(prograde:topVector,up:vector).
      steer().lock throttle to 1.
      wait until periapsis>30000 or ship:maxThrust<1.
      lock throttle to 0.
      next().
    }).
    states:add({trackSun().wait until altitude<60000.unwarp().wait 10.next().}).
    states:add({science(1).next().}).
    states:add({trackSun().burn(periapsis,periapsis,{return eta:periapsis.}).next().}).
    states:add({trackSun().wait until not ship:messages:empty.}).
  })).
}