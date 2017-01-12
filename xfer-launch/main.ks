{
  local countdown is get("lib/countdown.ks").
  local etaToLan is get("lib/eta-to-lan.ks").
  local exec is get("lib/exec-node.ks").
  local find is get("lib/find-node.v2.ks").
  local seek is get("lib/hill-climb.v2.ks").
  local findXfer is get("lib/finders.v2/closest-approach.ks").
  local fsm is get("lib/fsm.ks").
  local l is get("lib/hlog.ks").
  local launch is get("lib/launch.ks").
  local x2 is get("lib/transfers-to.ks").
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
        local hc is seek().
        hc["add"](0,0,{parameter n.return n:obt:eccentricity.}).
        exec(find(hc,Node(time:seconds+eta:apoapsis,0,0,100),List(0,0,0,100))).
        next().
      }).
      seq:add({
        l("Performing transfer").
        local hc is seek().
        hc["add"](dst:obt:semiMajorAxis-body:radius,0,{parameter n.return n:obt:apoapsis.}).
        local dn0 is find(hc,Node(time:seconds+eta:apoapsis,0,0,100),List(0,0,0,100)).
        set hc to seek().
        hc["add"](dst:radius*0.9,0,findXfer(dst)).
        until 0{
          set dn0:eta to random()*obt:period.
          add find(hc,dn0,List(obt:period/36,10,10,10)).
          if x2(nextNode:obt,dst)break.
        }
        exec().next().
      }).
    })().
  }).
}