{
  local bt is get("lib/burn-time.ks").
  local kw is get("lib/kill-warp.ks").
  put({
    local node is nextNode.
    local lock nbt to bt(node:deltaV:mag).
    local lock t to node:eta-nbt/2.
    wait until t<60.
    lock steering to lookDirUp(node:deltaV,-up:vector).
    wait until t<0.local v is node:deltaV.
    lock throttle to min(1,nbt).
    wait until vDot(v,node:deltaV)<=0.
    lock throttle to 0.set ship:control:pilotMainThrottle to 0.
    unlock steering. remove node. wait 0.
  }).   
}