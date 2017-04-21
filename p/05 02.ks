{
  local compassForVec is g00_02("p/fd 05.ks").
  local kw is g00_02("p/fd 0b.ks").
  local s2d is g00_02("p/fd 1e.ks").
  local d is 0.
  g00_01({parameter w is 0.
    g00_03("PGM 05 02").
    clearScreen.
    clearVecDraws().

    print "DunaDirect HoverSlam! v0.1".
    print "  grav:". // 1
    print "thrust:". // 2
    print " ".
    print "goal a:". // 4
    print "throtl:". // 5

    local printRow is 0.
    local printCol is 8.

    local drawVecs is 0.
    local o is v(0, 0, 0).
    local vecGrav is VecDraw(o, o, yellow, "Gravity", 1, drawVecs).
    local vecDrag is VecDraw(o, o, red,    "Goal",    1, drawVecs).
    local vecThrust is VecDraw(o, o, cyan, "Thrust",  1, drawVecs).
    local vecAccel is VecDraw(o, o, green, "NonThrust",   1, drawVecs).

    function steeringDir {
      local burnHeading is compassForVec(ship,srfRetrograde:vector).
      local burnPitch is 90-1.5*vAng(up:vector,srfRetrograde:vector).
      local upHeading is 0.
      local upPitch is 0.
      if burnPitch>0{
        set upHeading to 90.
        set upPitch to 90-burnPitch.
      }else{
        set upHeading to 270.
        set upPitch to 90+burnPitch.
      }
      if burnHeading<180 set upPitch to-upPitch.
      return lookDirUp(heading(burnHeading,burnPitch):vector,heading(upHeading,upPitch):vector).  
    }

    local gModifier is 0.5.
    local tBuffer is 1.
    //local timestep is 0.01.

    local burnStart is false.
    local altStart is false.

    global throttleValue is 0.
    lock throttle to throttleValue.

    local hOffset is 0.
    for part in ship:parts set hOffset to min(hOffset,facing:vector*part:position).

    local lock altRadar to altitude-body:geopositionof(ship:position):terrainheight.

    // v = at
    // t = v / a
    // d = at^2 / 2
    // d = a/2 * (v^2 / a^2)
    // d = v^2 / 2a
    // a = v^2 / 2d
    local lock goal to airSpeed^2/(altRadar-hOffset-5)/2.
    local lock grav to body:mu/((gModifier*altitude+body:radius)^2).
    local lock thrust to ship:availableThrust/mass.
    local lock throttleGoal to(goal+grav)/thrust.

    function dWait{
      print round(grav,3)  +" m/s^2      "at(printCol,printRow+1).
      print round(thrust,3)+" m/s^2      "at(printCol,printRow+2).
      print round(goal,3)+" m/s^2     "at(printCol,printRow + 4).
      print round(throttleGoal*100,3)+" %         "at(printCol,printRow+5).
      set vecGrav:vec to-grav*up:vector.
      set vecThrust:vec to thrust*facing:vector.
      wait 0.2.
    }
    if w and throttleGoal<0.4{
      print"warping...".
      set warp to 4.
      until throttleGoal>=0.1 dWait().
      set warp to 3.
      until throttleGoal>=0.25 dWait().
      set warp to 2.
    }
    until throttleGoal>=0.5 dWait().kw().
    gear off.
    lock steering to steeringDir().s2d().
    if w set warp to 1.
    until throttleGoal>0.75 dWait().kw().
    gear on.
    until throttleGoal>0.99 dWait().
    set burnStart to time:seconds.
    set altStart to altRadar.
    until status="LANDED"or status="SPLASHED"{
      if verticalSpeed>0 set throttleValue to 0.
      else if verticalSpeed>-2 set throttleValue to grav/thrust.
      else if throttleGoal>2/3 set throttleValue to throttleGoal*1.01.
      else set throttleValue to grav/thrust.
      dWait().
    }
    lock throttle to 0.
    print"burn time: "+round(time:seconds-burnStart,3)+" s".
    print"burn dist: "+round(altRadar-altStart,3)+" m".
    unlock steering.
    unlock throttle.
    print "Touchdown.".
    sas on. wait 5. sas off.
    clearVecDraws().
    print "Landing complete.".
  }).
}
