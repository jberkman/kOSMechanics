{
local hal is g00_02("p/fd 0f.ks").
local _fd10 is g00_02("p/fd 10.ks").
local find is g00_02("p/fd 13.ks").
local gss is g00_02("p/fd 14.ks").
local x2 is g00_02("p/fd 15.ks").
local _fd16 is g00_02("p/fd 16.ks").
local altAt is g00_02("p/fd 1a.ks").
local xferETA is g00_02("p/fd 1b.ks").
local xferMap is g00_02("p/fd 1c.ks").
g00_01({parameter b,a,i,e.
g00_03("PGM 04 03").
_fd10().
if not x2(obt,b){e().return.}
//if altitude>b:altitude/2{s().return.}
set target to b.
{
  local t is xferETA(obt,b).
  local h is obt:periapsis/2.
  if altitude>b:altitude set h to obt:apoapsis/2.
  set h to h+b:altitude/2.
  add Node(gss(time:seconds,time:seconds+t,60,{parameter t.return abs(altAt(t)-h).}),0,0,0).
}
local h is hal().
if(i<90)<>(_fd16(nextNode:obt,b):inclination<90){
  h["add"](b:radius,xferMap(b,{parameter o.
    //print "peri: "+o:periapsis+" ("+(o:periapsis+b:radius)+")".
    return o:periapsis+b:radius.
  })).
  add find(h["solve"]@,nextNode,List(0,0.5,0.5,0.5)).
  set h to hal().
}
if i<90 set i to 0.else set i to 180.
h["add"](30,xferMap(b,{parameter o.return o:inclination-i.})).
add find(h["solve"]@,nextNode,List(0,1,1,1)).
print"AAA: "+(0.05*abs(a)).
local gl is max(10000,0.05*abs(a)).
h["add"](max(10000,0.2*abs(a)),xferMap(b,{parameter o.
print "gl: "+gl+" dlt: "+abs(o:periapsis-a).
return o:periapsis-a.
})).
add find(h["solve"]@,nextNode,List(0,0.5,0.5,0.5)).
}).
}