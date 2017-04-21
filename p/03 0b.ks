{
  local s2d is g00_02("p/fd 1e.ks").
  g00_01({parameter a,e is 0.1.
    g00_03("PGM 03 0B").
    local lock done to abs(obt:semiMajorAxis-a)<e.
    until done{
      local gt is obt:semiMajorAxis>a.
      local d is prograde.
      if gt set d to retrograde.
      lock steering to lookDirUp(d:vector,-up:vector).
      s2d().wait 5.
      rcs on.
      until done or(obt:semiMajorAxis>a)<>gt{
        print obt:semiMajorAxis.
        set ship:control:fore to 0.1.
        wait 0.
        set ship:control:fore to 0.
      }
      rcs off.
      print obt:semiMajorAxis.
    }
  }).
}