{
  local etaToLan is get("lib/eta-to-lan.ks").
  local launch is get("lib/launch.ks").
  put(get("lib/fsm.ks")({parameter states, events, next.
    local lock lanEta to etaToLan(263.9).
    states:add({
      warpTo(time:seconds-30+lanEta).
      wait until kUniverse:timeWarp:isSettled.
      if lanEta<30 next().
    }).
    states:add({
      launch(4055773,3.2).
      stage.
      next().
    }).
  })).
}