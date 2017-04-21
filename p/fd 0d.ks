g00_01({parameter o,h,a is o:semiMajorAxis.
  print "h: "+h+" a:"+a.
  print "2/h+o:body:radius: "+(2/(h+o:body:radius)).
  print "1/a: "+(1/a).
  print "2/...: "+(2/(h+o:body:radius)-1/a).
  print "mu:"+o:body:mu.
return sqrt(o:body:mu*(2/(h+o:body:radius)-1/a)).}).