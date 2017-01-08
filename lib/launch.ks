{
  local countdown is get("lib/countdown.ks").
  local clamp is get("lib/clamp.ks").
  local vecHdg is get("lib/compass-for-vec.ks").
  local hlog is get("lib/hlog.ks").
  put({parameter a is body:atm:height+10000, i is 0, pr is 0.6.
    local z is arcsin(clamp(cos(i)/cos(latitude),-1,1)).
    sas on.
    if status="prelaunch"{countdown("T - ",30).stage.}
    hlog("Ignition!").
    lock throttle to 1-(0.999*apoapsis/(a+body:radius)).
    local timeout is time:seconds+3.
    wait until verticalSpeed>1 or time:seconds>timeout.
    if verticalSpeed<1 stage.
    hlog("Liftoff!").
    local rollAt is alt:radar.
    until alt:radar>rollAt+60.
    sas off.

    if body:atm:exists{
      global launchPC to time:seconds.
      hlog("Go for roll and pitch.").
      lock lookAt to heading(z,90-pr*(time:seconds-launchPC)):vector.
      lock lookUp to heading(z,-45):vector.
      lock steering to lookDirUp(lookAt, lookUp).
      local mq is ship:q.
      until mq>ship:q or ship:q>0.2 set mq to max(mq,ship:q).

      hlog("Following prograde vector").
      lock lookAt to ship:velocity:surface.
      lock lookUp to -up:vector.
      wait until ship:q<0.02 or apoapsis>=a.

      hlog("Transitioning to horizontal flight.").
      lock lookAt to heading(vecHdg(ship,ship:velocity:orbit),0):vector.
    }else{
      lock lookAt to heading(z,67.5):vector.
      lock lookUp to heading(z,-45):vector.
      lock steering to lookDirUp(lookAt,lookUp).
      wait until apoapsis > altitude + 1000 - alt:radar.

      lock lookAt to heading(z,22.5):vector.next().
    }
    
    wait until apoapsis>=a or(ship:maxThrust<0.1 and altitude>body:atm:height).
    lock throttle to 0.
    lock steering to lookDirUp(ship:velocity:orbit,-up:vector).
    wait until altitude>body:atm:height.
    unlock steering.
  }).
}