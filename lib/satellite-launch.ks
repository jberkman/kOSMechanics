{
  local countdown is get("lib/countdown.ks").
  local etaToLan is get("lib/eta-to-lan.ks").
  local fsm is get("lib/fsm.ks").
  local launch is get("lib/launch.ks").
  put({parameter peri,inc is 0,lan is -1.
    fsm({parameter states, events, next.
      local lock lanEta to etaToLan(lan).
      if lan>=0 states:add({
        countdown("Warping to launch window in ",15).
        warpTo(time:seconds-30+lanEta). wait until kUniverse:timeWarp:isSettled.
        if lanEta<30 next().
      }).
      states:add({launch(peri,inc).stage. next().}).
    })().
  }).
}