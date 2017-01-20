{
  local burn is get("lib/set-heights.ks").
  local countdown is get("lib/countdown.ks").
  local etaToLan is get("lib/eta-to-lan.ks").
  local fsm is get("lib/fsm.ks").
  local l is get("lib/hlog.ks").
  local launch is get("lib/launch.ks").
  put({parameter peri is body:atm:height+10000,inc is 0,lan is -1,pr is 0.4.
    fsm({parameter seq,ev,next.
      if lan>=0 seq:add({
        local lock lanEta to etaToLan(lan).
        countdown("Warping to launch window in ",15).
        warpTo(time:seconds-30+lanEta). wait until kUniverse:timeWarp:isSettled.
        if lanEta<30 next().
      }).
      seq:add({launch(peri,inc,pr).next().}).
      seq:add({
        if periapsis<30000 burn(time:seconds+30,peri,30000,1).
        next().
      }).
      seq:add({stage. next().}).
    })().
  }).
}