{put({parameter a is body:atm:height+10000, i is 0, pr is 0.6.
  local clamp is get("lib/clamp.ks").
  local compassForVec is get("lib/compass_for_vec.ks").
  local hlog is get("lib/hlog.ks").
  local z is arcsin(clamp(cos(i) / cos(latitude),-1,1)).
  get("lib/main.ks")({
    parameter s, e, next.
    s:add({
      sas on.
      if status="prelaunch"{
        local t is 30.
        until t < 0 {wait 1.hudText("T - "+t,0.9,2,-1,yellow,1).set t to t-1.}
        stage.
      }
      next().
    }).
    s:add({
      hlog("Ignition!").
      lock throttle to 1-(0.999*apoapsis/(a+body:radius)).
      wait until verticalSpeed>1.next().
    }).
    s:add({
      hlog("Liftoff!").
      local rollAt is alt:radar.
      until alt:radar>rollAt+60.
      sas off.next().
    }).
    if body:atm:exists{
      s:add({
        set pc to time:seconds.
        hlog("Go for roll and pitch.").
        lock lookAt to heading(z,90-pr*(time:seconds-pc)):vector.
        lock lookUp to heading(z,-45):vector.
        lock steering to lookDirUp(lookAt, lookUp).
        local mq is ship:q.
        until mq>ship:q or ship:q>0.2 set mq to max(mq,ship:q).
        next().
      }).
      s:add({
        hlog("Following prograde vector").
        lock lookAt to ship:velocity:surface.
        lock lookUp to -up:vector.
        wait until ship:q<0.02.next().
      }).
      s:add({
        hlog("Transitioning to horizontal flight.").
        lock lookAt to heading(compassForVec(ship,ship:velocity:orbit),0):vector.
        next().
      }).
    }else{
      s:add({
        lock lookAt to heading(z,67.5):vector.
        lock lookUp to heading(z,-45):vector.
        lock steering to lookDirUp(lookAt,lookUp).
        wait until apoapsis > altitude + 1000 - alt:radar.next().
      }).
      s:add({
        lock lookAt to heading(z,22.5):vector.next().
      }).
    }
    s:add({wait until apoapsis>=a. next().}).
    s:add({lock throttle to 0.unlock steering.next().}).
    if body:atm:exists s:add({wait until altitude>body:atm:height. next().}).
  })().
}).}