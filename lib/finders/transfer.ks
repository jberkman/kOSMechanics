{
  local gs is get("lib/golden-section-search.ks").
  local x2 is get("lib/transfers-to.ks").
  local xo is get("lib/transfer-obt.ks").
  put({parameter b,h is 10000,e is 500.return{parameter n.
    if n:eta<0 return-2^64.
    if x2(n:obt,b){
      local o is xo(n:obt,b).
      return round((b:soiRadius-abs(o:periapsis-h))/e)*e.
    }else if n:obt:eccentricity<1{
      function dx{parameter t.return-round((positionAt(ship,t)-positionAt(b,t)):mag/e)*e.}
      return dx(gs(time:seconds+n:eta,time:seconds+n:eta+n:obt:period,100,dx@)).
    }else return-2^64.
  }.}).
}