{
  local countdown is get("lib/countdown.ks").
  local etaToLan is get("lib/eta-to-lan.ks").
  local exec is get("lib/exec-node.ks").
  local find is get("lib/find-node.ks").
  local findPeri is get("lib/finders/periapsis.ks").
  local findAP is get("lib/finders/apo-and-peri.ks").
  local fsm is get("lib/fsm.ks").
  local l is get("lib/hlog.ks").
  local launch is get("lib/launch.ks").
  put({parameter peri is body:atm:height+10000,inc is 0,lan is -1,pr is 0.4.
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
          local nd is find(Node(time:seconds+30,0,0,10),List(0,0,0,10),findPeri(30000)).
          exec(find(nd,List(0,1,0,1),findAP(peri,30000))).
        }
        next().
      }).
      seq:add({stage. next().}).
    })().
  }).
}