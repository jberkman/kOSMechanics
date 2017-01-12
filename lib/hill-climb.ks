// Inspired by Kevin Gisi http://youtube.com/gisikw
{
  function nb{parameter nd,st.
    function it{parameter nd.local x is nd:copy. set x[i]to nd[i]-st[i]. rt:add(x).set x to nd:copy. set x[i]to nd[i]+st[i]. rt:add(x).}
    local rt is list().local i is 0.until i=nd:length{if st[i]<>0{for j in rt:copy it(j).it(nd).}set i to i+1.}return rt.}
  put({parameter nd,st,ev.
    local sc is ev(nd).local ch is lex(""+nd,sc).
    local dn is 0.until dn{set dn to 1.for n in nb(nd,st){
      local k is ""+n. if not ch:hasKey(k)set ch[k] to ev(n).
      if ch[k]>sc{set nd to n. set sc to ch[k].set dn to 0.}
    }}return nd.}).
}