{
  local countdown is get("lib/countdown.ks").
  local etaToLan is get("lib/eta-to-lan.ks").
  local launch is get("lib/launch.ks").
  put(get("lib/fsm.ks")({parameter states, events, next.
    local lock lanEta to etaToLan(65.9).
    states:add({
      countdown("Warping to launch window in ",15).
      warpTo(time:seconds-30+lanEta).
      wait until kUniverse:timeWarp:isSettled.
      if lanEta<30 next().
    }).
    states:add({
      launch(4295135,5.9).
      stage.
      next().
    }).
  })).
}