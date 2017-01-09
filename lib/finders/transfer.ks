{
  local gss is get("lib/golden-section-search.ks").
  local xfer2 is get("lib/transfers-to.ks").
  local xferObt is get("lib/transfer-obt.ks").
  put({parameter b,h is 10000.return{parameter n.
    local inf is 2^64.
    if xfer2(n:obt,b){
      local xo is xferObt(n:obt,b).
      return round(b:soiRadius-abs(xo:periapsis-h)).
    }else if n:obt:eccentricity<1{
      function dx{parameter t.return-round((positionAt(ship,t)-positionAt(b,t)):mag).}
      return dx(gss(time:seconds+n:eta,time:seconds+n:eta+n:obt:period,1,dx@)).
    }else return-inf.
  }.}).
}