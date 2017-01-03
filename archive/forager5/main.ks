{
  local circularize is get("lib/circularize.ks").
  local deorbit is get("lib/deorbit.ks").
  local extendAntenna is get("lib/extend-antennae.ks").
  local hlog is get("lib/hlog.ks").
  local steer is get("lib/steer-to-dir.ks").
  put(get("lib/fsm.ks")({parameter seq,ev,next.
    seq:add({
      wait until ship:modulesNamed("kOSProcessor"):length=1.
      wait 0.
      next().
    }).
    seq:add({
      hlog("Circularizing...").
      circularize().
      next().
    }).
    seq:add({
      hlog("Extending antenna...").
      extendAntenna().
      next().
    }).
    seq:add({
      hlog("Tracking Sun...").
      lock steering to lookDirUp(north:vector,-sun:position).
      steer().
      next().
    }).
    seq:add({
      hlog("Preparing for deorbit...").
      deorbit(time:seconds+obt:period).
      next().
    }).
    seq:add({
      hlog("Reorienting for re-entry...").
      lock steering to lookDirUp(srfRetrograde:vector,-up:vector).
      wait until status="LANDED" or status="SPLASHED".
      next().
    }).
  })).
}