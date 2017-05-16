{
local _0301 is g00_02("p/03 01.ks").
local _0302 is g00_02("p/03 02.ks").
local _0303 is g00_02("p/03 03.ks").
local _0304 is g00_02("p/03 04.ks").
local _0305 is g00_02("p/03 05.ks").
local _0308 is g00_02("p/03 08.ks").
local _fd07 is g00_02("p/fd 07.ks").
local _fd19 is g00_02("p/fd 19.ks").
local _fd27 is g00_02("p/fd 27.ks").
g00_01({parameter m.
  _fd07({parameter seq,ev,next.
    g00_03("PGM 07 23").
    local pgm is _fd27:bind(seq,next@).
    local g is _fd19:bind(m).
    local w is g("wrp",1).
    local o is _fd19:bind(g("obt",Lex())).
    local ecc is o("ecc",0).
    local sma is o("sma",body:radius+body:atm:height+10000).
    local apo is sma*(1+ecc)-body:radius.
    local peri is sma*(1-ecc)-body:radius.
    local aop is o("aop",-1).
    local idle is g("idl",{}).
    pgm({
      if obt:semiMajorAxis>sma _0302(apo).
      else _0303(peri).
    },List(),idle@).
    pgm(_0301@,List(next@,w)).
    pgm({
      if obt:semiMajorAxis>sma _0305().
      else _0304().
    },List(),idle@).
    pgm(_0301@,List(next@,w)).
    pgm({
      local a is apo.
      if obt:semiMajorAxis>sma set a to peri.
      _0308(a,aop).
    },List(),idle@).
    pgm(_0301@,List(next@,w)).
    pgm(_0302@,List(peri),idle@).
    pgm(_0301@,List(next@,w)).
    pgm(_0303@,List(apo),idle@).
    pgm(_0301@,List(next@,w)).
  })().
}).
}