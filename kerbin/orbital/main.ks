{
  local c is get("lib/circularize.ks").
  local d is get("lib/deorbit.ks").
  local fsm is get("lib/fsm.ks").
  local l is get("lib/hlog.ks").
  local u is get("lib/kill-warp.ks").
  put({parameter orbits,emptySeats is 0.
    fsm({parameter seq,ev,next.
      seq:add({
        l("Waiting for capsule to be deployed...").
        wait until ship:modulesNamed("kOSProcessor"):length=1 and altitude>body:atm:height.
        wait 10.
        next().
      }).
      seq:add({
        l("Circularizing...").
        c().
        next().
      }).
      local i is 0. until i=orbits{seq:add({
        l("Completing orbit #"+i+"...").
        local t is time:seconds+obt:period.
        wait until time:seconds>t.
        next().}).
        set i to i+1.
      }
      seq:add({
        l("Please return onboard for deorbiting.").
        u().
        wait until ship:crewCapacity=ship:crew():length+emptySeats.
        l("Scheduling deorbit burn in 120 seconds.").
        d(time:seconds+120).
        next().
      }).
      seq:add({wait 10. stage. next().}).
    })().
  }).
}