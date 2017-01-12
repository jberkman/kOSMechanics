{
  local gs is get("lib/golden-section-search.ks").
  local x2 is get("lib/transfers-to.ks").
  local xo is get("lib/transfer-obt.ks").
  put({parameter b,e is 500.return{parameter n.
    if n:eta<0 return 2^64.
    if x2(n:obt,b) return b:radius+xo(n:obt,b):periapsis.
    if n:obt:eccentricity>=1 return 2^64.
    function dx{parameter t.return round((positionAt(ship,t)-positionAt(b,t)):mag/e)*e.}
    return dx(gs(time:seconds+n:eta,time:seconds+n:eta+n:obt:period,100,dx@)).
  }.}).
}