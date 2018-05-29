{
  local f is"1:/00 f4.kson".
  local ml is g00_02("p/fd 08.ks")[core:tag].
  local cmds is Lex().
  {
    local map is Lex(
      "nop","p/07 00.ks",
      "lch","p/07 01.ks",
      "stg","p/07 02.ks",
      "vsl","p/07 03.ks",
      "typ","p/07 04.ks",
      "om1","p/07 21.ks",
      "om2","p/07 22.ks",
      "om3","p/07 23.ks",
      "om4","p/07 24.ks",
      "tm1","p/07 41.ks",
      "tm2","p/07 42.ks",
      "tm3","p/07 43.ks",
      "tm4","p/07 44.ks"
    ).
    for m in ml{
      local cmd is m["cmd"].
      if not cmds:hasKey(cmd)set cmds[cmd]to g00_02(map[cmd]).
    }
  }
  local _fd21 is g00_02("p/fd 21.ks").
  local _fd24 is g00_02("p/fd 24.ks").
  local _fd25 is g00_02("p/fd 25.ks").
  g00_01({
    local i is _fd25(f,0).
    until i>=ml:length{
      wait until ship=kUniverse:activeVessel.
      local m is ml[i].
      cmds[m["cmd"]](m).
      set i to i+1.
      _fd24(f,i). 
      _fd21().
    }
    //reboot.
  }).
}
