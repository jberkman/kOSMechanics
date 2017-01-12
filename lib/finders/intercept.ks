{
  local x2 is get("lib/transfers-to.ks").
  local xo is get("lib/transfer-obt.ks").
  put({parameter b,h is 10000,i is 0.
    return{parameter n.
      if not(x2(obt,b)and x2(n:obt,b))return-2^64.
      local o1 is xo(obt,b).local o2 is xo(n:obt,b).
      if (o1:inclination<90)<>(i<90){
        local d is abs(180-o1:inclination-o2:inclination).
        print "inc:"+round(o2:inclination)+" d:"+-d.
        if d>0.1 return-d.
      }
      local g is 0.
      if i>60 and i<120 set g to 90.
      else if o1:argumentOfPeriapsis>90 set g to 180.
      local d is abs(g-o2:argumentOfPeriapsis).
      print "aop:"+round(o2:argumentOfPeriapsis)+" d:"+(180-d).
      if d>0.1 return 180-d.
      print "alt:"+round(o2:periapsis)+" d:"+(180+b:soiRadius-abs(o2:periapsis-h)).
      return 180+b:soiRadius-abs(o2:periapsis-h).
    }.
  }).
}