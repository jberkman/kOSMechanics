{
  local _fd19 is g00_02("p/fd 19.ks").
  g00_01({parameter m.
    g00_03("PGM 07 04").
    set ship:type to _fd19(m,"type",ship:type).
    wait 1.
  }).
}