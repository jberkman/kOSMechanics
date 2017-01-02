@lazyglobal off.{
  local seek is 0.
  global put is{parameter f.set seek to f.}.
  runPath("0:/lib/hill-climb.ks").
  {
    local x is seek(list(100),{parameter x.return -x[0]^2.})[0].
    print "Should be 0: "+x.
    if x<>0 print 1/0.
  }
  {
    local x is seek(list(0,0),{parameter x.return -sqrt((x[0]-42)^2 + (x[1]-42)^2).}).
    print "Should be 42, 42: "+x.
    if x[0]<>42 or x[1]<>42 print 1/0.
  }
}