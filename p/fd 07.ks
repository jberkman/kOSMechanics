{
  local f is "1:/00 f3.kson".
  local wf is g00_02("p/fd 24.ks").
  local rf is g00_02("p/fd 25.ks").
  g00_01({
    parameter d.
    local r is rf(f,0).
    local s is List().
    local e is Lex().
    local n is{
      parameter m is r+1.
      if m<0 set r to r+m.
      else set r to m.
      wf(f,r).
    }.
    d(s,e,n).
    return{
      until r>=s:length{
        s[r]().
        local v2 is 0.
        for v2 in e:values v2().
        wait 0.
      }
    }.
  }).
}