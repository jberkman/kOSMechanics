{
  local countdown is get("lib/countdown.ks").
  local etaToLan is get("lib/eta-to-lan.ks").
  local fsm is get("lib/fsm.ks").
  local launch is get("lib/launch.ks").
  put({parameter peri,inc is 0,lan is -1,pr is 0.4.
    fsm({parameter seq,ev,next.
      local lock lanEta to etaToLan(lan).
      if lan>=0{
        seq:add({
          countdown("Warping to launch window in ",15).
          warpTo(time:seconds-30+lanEta).
          next().
        }).
        seq:add({if kUniverse:timeWarp:isSettled and lanEta<30 next().}).
      }
      seq:add({launch(peri,inc,pr).stage. next().}).
    })().
  }).
}