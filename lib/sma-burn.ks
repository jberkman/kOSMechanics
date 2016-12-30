{
  local ov is get("lib/orbital-velocity.ks").
  local bt is get("lib/burn-time.ks").
  local hdg is get("lib/compass-for-vec.ks").
  local pitch is get("lib/pitch-for-vec.ks").
  local steer is get("lib/steer-to-dir.ks").
  put({
    parameter gA,bA,getETA.
    local sma is body:radius+(gA+bA)/2.
    local dV is ov(ship,bA,sma)-ov(ship,bA).
    //if career():canMakeNodes{add node(time:seconds+getETA(), 0, 0, dV).return.}
    local t2 is abs(bt(dV))/2.
    local lock t to getETA()-t2.
    wait until t<20.
    set warp to 0.
    lock burnVec to prograde:foreVector.
    if dV<0 lock burnVec to retrograde:foreVector.
    lock burnPitch to-pitch(ship,burnVec).
    lock burnHdg to hdg(ship,burnVec).
    lock steering to lookdirup(heading(burnHdg,burnPitch):vector,-up:vector).
    wait until t<=0.
    steer().
    lock throttle to 1.
    if dV>0 wait until obt:semiMajorAxis>=sma.
    else wait until obt:eccentricity<1 and obt:semiMajorAxis<=sma.
    lock throttle to 0.
    unlock steering.
    unlock throttle.
  }).
}