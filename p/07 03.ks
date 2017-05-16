{
  local _fd19 is g00_02("p/fd 19.ks").
  g00_01({parameter m.
    g00_03("PGM 07 03").
    set kUniverse:activeVessel to Vessel(_fd19(m,"vsl",ship:name)).
    wait 1.
  }).
}