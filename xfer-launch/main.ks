{
  local countdown is get("lib/countdown.ks").
  local etaToLan is get("lib/eta-to-lan.ks").
  local exec is get("lib/exec-node.ks").
  local find is get("lib/find-node.ks").
  local findApo is get("lib/finders/apoapsis.ks").
  local findEcc is get("lib/finders/eccentricity.ks").
  local findXfer is get("lib/finders/transfer.ks").
  local fsm is get("lib/fsm.ks").
  local l is get("lib/hlog.ks").
  local launch is get("lib/launch.ks").
  local xfer2 is get("lib/transfers-to.ks").
  put({parameter dst,peri is body:atm:height+10000,pr is 0.4.
    fsm({parameter seq,ev,next.
      if dst:obt:body=Kerbin and dst:obt:inclination>1{
        local lock lanEta to etaToLan(dst:obt:longitudeOfAscendingNode).
        seq:add({
          countdown("Warping to launch window in ",15).
          warpTo(time:seconds-30+lanEta).
          next().
        }).
        seq:add({if kUniverse:timeWarp:isSettled and lanEta<30 next().}).
      }
      seq:add({launch(peri,dst:obt:inclination,pr).next().}).
      seq:add({
        l("Circularizing parking orbit").
        exec(find(Node(time:seconds+eta:apoapsis,0,0,100),List(0,0,0,100),findEcc())).
        next().
      }).
      seq:add({
        l("Performing transfer").
        local dn0 is find(Node(time:seconds+eta:apoapsis,0,0,100),List(0,0,0,100),findApo(dst:obt:semiMajorAxis-body:radius)).
        set dn0:eta to 0.
        until 0{
          set dn0:eta to dn0:eta+obt:period/3.
          local dn is find(dn0,List(obt:period/10,0,0,0),findXfer(dst)).
          set dn to find(dn,List(100,10,10,10),findXfer(dst,-dst:radius/10),3).
          add dn. if xfer2(dn:obt,dst)break.
        }
        exec().next().
      }).
    })().
  }).
}