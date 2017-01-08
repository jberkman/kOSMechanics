{
  local burn is get("lib/sma-burn.v2.ks").
  local countdown is get("lib/countdown.ks").
  local etaToLan is get("lib/eta-to-lan.ks").
  local fsm is get("lib/fsm.ks").
  local l is get("lib/hlog.ks").
  local launch is get("lib/launch.ks").
  put({parameter peri is body:atm:height+10000,inc is 0,lan is -1,pr is 0.6.
    fsm({parameter seq,ev,next.
      local lock lanEta to etaToLan(lan).
      if lan>=0 seq:add({
        countdown("Warping to launch window in ",15).
        warpTo(time:seconds-30+lanEta). wait until kUniverse:timeWarp:isSettled.
        if lanEta<30 next().
      }).
      seq:add({
        print "Launching...".
        launch(peri,inc,pr).next().
      }).
      seq:add({
        if periapsis<30000{
          l("Raising periapsis...").
          local a is (apoapsis+30000)/2+body:radius.
          burn(time:seconds+max(30,eta:apoapsis-60),a).
        }
        next().
      }).
      seq:add({stage. next().}).
      //function abortOnDescent {if verticalSpeed<0 abort on.}
      //set ev["abort"]to{if verticalSpeed>10 set ev["abort"]to abortOnDescent@.}.
    })().
  }).
}