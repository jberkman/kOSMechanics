{
  local launch is get("lib/launch.ks").
  put(get("lib/fsm.ks")({parameter states, events, next.
    local unwarp is {set warp to 0.wait until kUniverse:timeWarp:isSettled.}.
    states:add({
      local ish is {parameter x,y,d.return x>y-d and x<y+d.}.
      wait until ish(mod(mun:longitude-longitude+360,360),95,0.5).
      unwarp().
      next().
    }).
    states:add({
      launch(mun:altitude).
      stage.
      next().
    }).
  })).
}