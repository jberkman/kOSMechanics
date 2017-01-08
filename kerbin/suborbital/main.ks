{
  local ex is get("lib/exec-node.ks").
  local fsm is get("lib/fsm.ks").
  local l is get("lib/hlog.ks").
  put({
    fsm({parameter seq,ev,next.
      seq:add({wait until ship:modulesNamed("kOSProcessor"):length=1 and altitude>body:atm:height. wait 10. next().}).
      seq:add({add Node(time:seconds+eta:apoapsis,0,0,100).ex().next().}).      
      seq:add({wait 10. stage. next().}).
    })().
  }).
}