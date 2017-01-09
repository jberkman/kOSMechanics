{
  local exec is get("lib/exec-node.ks").
  local find is get("lib/find-node.ks").
  local findEcc is get("lib/finders/eccentricity.ks").
  local findPeri is get("lib/finders/periapsis.ks").
  local fsm is get("lib/fsm.ks").
  local l is get("lib/hlog.ks").
  local killWarp is get("lib/kill-warp.ks").
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
        exec(find(Node(time:seconds+eta:apoapsis,0,0,0),List(0,0,0,100),findEcc())).
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
        killWarp().
        wait until ship:crewCapacity=ship:crew():length+emptySeats.
        l("Scheduling deorbit burn in 120 seconds.").
        exec(find(Node(time:seconds+120,0,0,-100),List(0,0,0,10),findPeri(30000))).
        next().
      }).
      seq:add({wait 10. stage. next().}).
    })().
  }).
}