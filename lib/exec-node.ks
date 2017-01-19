{
  local bt is get("lib/burn-time.ks").
  local kw is get("lib/kill-warp.ks").
  put({parameter node is nextNode, w is 0.
    wait 0. if not hasNode add node.
    local lock nbt to bt(node:deltaV:mag).
    local lock t to node:eta-nbt/2.
    if w warpTo(time:seconds+t-30).
    wait until t<30. kw().
    lock steering to lookDirUp(node:deltaV,-up:vector).
    wait until t<0. kw().
    local v is node:deltaV.
    lock throttle to min(1,nbt).
    wait until vDot(v,node:deltaV)<=0.
    lock throttle to 0.set ship:control:pilotMainThrottle to 0.
    unlock steering. remove node. wait 0.
  }).   
}