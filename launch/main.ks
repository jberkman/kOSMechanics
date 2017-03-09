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
  if l>=0 and i>0{
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
    local exec is get("lib/exec-node-state.ks"):bind(next,1).
    local find is get("lib/find-node.v4.ks").
    local h is get("lib/hlog.ks").
    local hal9k is get("lib/hal.v1.ks").
    local hohmann is get("lib/hohmann.v2.ks").
    local x2 is get("lib/transfers-to.ks").
    seq:add({h("Circularizing parking orbit").
      local hal is hal9k().
      hal["add"](0.1,{parameter n.return n:obt:semiMajorAxis-body:radius-apoapsis.}).
      local t is time:seconds+eta:apoapsis.
      print apoapsis.
      print hohmann(t,apoapsis).
      add find(hal,Node(t,0,0,hohmann(t,apoapsis)),List(0,0,0,100)).
      next().
    }).
    seq:add(exec@).
    local findXfer is get("lib/finders.v2/closest-approach.ks").
    seq:add({h("Performing transfer").
      local hal is hal9k().
      hal["add"](b:SOIRadius/4,findXfer(b)).
      until hasNode and nextNode:eta>180 and x2(nextNode:obt,b){
        local t is time:seconds+obt:period.
        add find(hal,Node(t,0,0,hohmann(t,b:altitude)),List(60,25,25,100)).
        wait 0.
      }
      next().
    }).
    seq:add(exec@).
  }
  if v(m,"launch.stage",1)seq:add({stage. next().}).
  if v(m,"launch.deorbit",0)seq:add({next().}).
})).
