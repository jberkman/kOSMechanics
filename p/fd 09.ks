{
  local f is g00_02("p/fd 01.ks").
  g00_01({parameter s,n,p,a is List(),i is{}.
    set p to g00_02(p).
    s:add({
      i().
      f(p,a).
      n().
    }).
  }).
}