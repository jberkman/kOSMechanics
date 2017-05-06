{
  local _0102 is g00_02("p/01 02.ks").
  local _0103 is g00_02("p/01 03.ks").
  local _0104 is g00_02("p/01 04.ks").
  local _0105 is g00_02("p/01 05.ks").
  local _0201 is g00_02("p/02 01.ks").
  local _0202 is g00_02("p/02 02.ks").
  local _0203 is g00_02("p/02 03.ks").
  local _0204 is g00_02("p/02 04.ks").
  local _0205 is g00_02("p/02 05.ks").
  //local _0206 is g00_02("p/02 06.ks").
  local _0208 is g00_02("p/02 08.ks").
  local _0301 is g00_02("p/03 01.ks").
  local _0304 is g00_02("p/03 04.ks").
  local _030a is g00_02("p/03 0a.ks").
  local _fd07 is g00_02("p/fd 07.ks").
  local _fd19 is g00_02("p/fd 19.ks").
  local _fd1e is g00_02("p/fd 1e.ks").
  local _fd27 is g00_02("p/fd 27.ks").
  g00_01({parameter m.
    _fd07({parameter seq,ev,next.
      g00_03("PGM 07 01").
      local pgm is _fd27:bind(seq,next@).
      local g is _fd19:bind(m).
      local o is _fd19:bind(g("obt",Lex())).
      local b is Kerbin.
      local hasPeer is m:hasKey("per").
      local peer is g("per",0).
      if hasPeer set b to peer:obt:body.
      set b to o("bdy",b).
      local p is g("prt",0.4).
      local a is 0. local i is 0. local l is 0.
      local w is 1.
      local ecc is o("ecc",0).
      local sma is o("sma",b:radius+b:atm:height+10000).
      set a to sma*(1-ecc)-b:radius.
      if b=Kerbin and hasPeer=0{
        set i to o("inc",0).
        set l to o("lan",-1).
      }else if b:obt:body=Kerbin{
        set i to b:obt:inclination.
        set l to b:obt:longitudeOfAscendingNode.
      }else if hasPeer{
        set i to peer:obt:inclination.
        set l to peer:obt:longitudeOfAscendingNode.
      }
      if l>=0 and i>0{
        pgm(_0102@,List(l)).
        seq:add(_0103:bind(l,next@)).
      }else{
        seq:add(next@).
        seq:add(next@).
      }
      pgm(_0104@).
      pgm(_0105@).
      pgm(_0201@).
      pgm(_0202@,List(i,p)).
      pgm(_0203@,List(a)).
      pgm(_0208@,List(a,i)).
      pgm(_0204@,List(a,i)).
      pgm(_0205@).
      //if g("rpa",0){
      //  pgm(_0206@,List(a)).
      //  pgm(_0301@,List(next@,w)).
      //}else{
      //  seq:add(next@).
      //  seq:add(next@).
      //}
    })().
  }).
}