@lazyglobal off.{
  local seek is 0.
  global put is{parameter f.set seek to f.}.
  runPath("0:/lib/hill-climb.v2.ks").
  {
    local hc is seek().
    hc["add"](0,0.5,{parameter x.print x[0]. return-x[0]^2.}).
    local x is hc["seek"](list(100),list(1)).
    print "Should be 0: "+x.
    if x[0]<>0 print 1/0.
  }
  {
    local hc is seek().
    hc["add"](0,0.5,{parameter x.print "0 "+x[0]+" "+x[1]. return-(x[0]-42)^2.}).
    hc["add"](0,0.5,{parameter x.return-(x[1]-42)^2.}).
    local x is hc["seek"](list(0,0),list(1,1)).
    print "Should be 42, 42: "+x.
    if x[0]<>42 print 1/0.
    if x[1]<>42 print 1/0.
  }
  {
    local y is 24.
    local hc is seek().
    hc["add"](0,0.5,{parameter x.print "0 "+x[0]+" "+x[1]+" "+x[2]. return-(x[0]-y)^2.}).
    hc["add"](0,0.5,{parameter x. return-(x[1]-y/2)^2.}).
    hc["add"](0,0.5,{parameter x. return-(x[2]-y/3)^2.}).
    local x is hc["seek"](list(0,0,0),list(1,1,1)).
    print "Should be "+y+", "+(y/2)+", "+(y/3)+": "+x.
    if x[0]<>y print 1/0.
    if x[1]<>y/2 print 1/0.
    if x[2]<>y/3 print 1/0.
  }
}