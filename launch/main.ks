put(get("lib/fsm.ks")({parameter seq,ev,next.
  local m is get("lib/mission.ks").
  function v{parameter m,k,d.if m:hasKey(k)return m[k].return d.}
  local b is v(m,"body",Kerbin).
  local p is v(m,"launch.pitch-rate",0.4).
  local a is 0. local i is 0. local l is 0.
  if b=Kerbin{
    set a to v(m,"peri",v(m,"apo",b:atm:height+10000)).
    set i to v(m,"inc",0).
    set l to v(m,"lan",-1).
  }else{
    set a to v(m,"launch.alt",Kerbin:atm:height+10000).
    if b:obt:body=Kerbin{
      set i to b:obt:inclination.
      set l to b:obt:longitudeOfAscendingNode.
    }
  }
  if l>=0{
    local w2l is get("lib/warp-to-lan.ks").
    local e2l is get("lib/eta-to-lan.ks").
    seq:add({w2l(l).next().}).
    seq:add({if kUniverse:timeWarp:isSettled and e2l(l)<30 next().}).
  }
  local launch is get("lib/launch.ks").
  seq:add({launch(a,i,p).next().}).
  if v(m,"launch.raise-peri",0){
    local setH is get("lib/set-heights.ks").
    seq:add({if periapsis<30000 setH(time:seconds+eta:apoapsis-60,a,30000,1).next().}).
  }
  if b<>Kerbin{
    local exec is get("lib/exec-node.ks").
    local find is get("lib/find-node.v2.ks").
    local h is get("lib/hlog.ks").
    local seek is get("lib/hill-climb.v2.ks").
    local x2 is get("lib/transfers-to.ks").
    seq:add({h("Circularizing parking orbit").
      local hc is seek().
      hc["add"](0,0.02,{parameter n.print n:obt:eccentricity. return n:obt:eccentricity.}).
      exec(find(hc,Node(time:seconds+eta:apoapsis,0,0,100),List(0,0,0,100)),1).
      next().
    }).
    local findXfer is get("lib/finders.v2/closest-approach.ks").
    seq:add({h("Performing transfer").
      local hc is seek().
      hc["add"](b:obt:semiMajorAxis-body:radius,b:radius,{parameter n.return n:obt:apoapsis.}).
      local dn0 is find(hc,Node(time:seconds+eta:apoapsis,0,0,100),List(0,0,0,100),5).
      set hc to seek().
      hc["add"](b:radius/2,1000,findXfer(b)).
      until 0{
        set dn0:eta to random()*obt:period.
        add find(hc,dn0,List(obt:period/36,10,10,10),2).
        if nextNode:eta>180 and x2(nextNode:obt,b)break.
      }
      exec(nextNode,1).next().
    }).
  }
  if v(m,"launch.stage",1)seq:add({stage. next().}).
  if v(m,"launch.deorbit",0)seq:add({next().}).
})).
