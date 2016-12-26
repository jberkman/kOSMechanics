{put({
  local e is get("lib/extend_antennae.ks").
  local s is get("lib/record_science.ks").
  if status <> "prelaunch" return.
  wait until altitude>body:atm:height.
  wait 5. stage.
  wait 5. e().
  wait 5. s(1).
  wait until eta:apoapsis<10.
  local a is apoapsis.
  local at is velocity:orbit.
  lock steering to lookDirUp(at,up:vector).
  lock throttle to 0.1.
  wait until maxThrust<1 or vAng(at,facing:vector)<2.
  lock throttle to 1.
  wait until maxThrust<1 or periapsis>a.
  lock throttle to 0.
  unlock steering.
}).}