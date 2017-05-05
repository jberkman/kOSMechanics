{
  local f is"1:/00 f4.kson".
  local ml is g00_02("p/fd 08.ks")[core:tag].
  local cmds is Lex().
  {
    local map is Lex(
      "atv","p/07 03.ks",
      "nop","p/07 00.ks",
      "lch","p/07 01.ks",
      "om1","p/07 21.ks",
      "om2","p/07 22.ks",
      "stg","p/07 02.ks",
      "tm1","p/07 41.ks",
      "tm2","p/07 42.ks",
      "tm3","p/07 43.ks"
    ).
    for m in ml{
      local cmd is m["cmd"].
      if not cmds:hasKey(cmd)set cmds[cmd]to g00_02(map[cmd]).
    }
  }
  local rst is g00_02("p/fd 21.ks").
  local wf is g00_02("p/fd 24.ks").
  local rf is g00_02("p/fd 25.ks").
  g00_01({
    local i is rf(f,0).
    until i>=ml:length{
      local m is ml[i].
      cmds[m["cmd"]](m).
      set i to i+1.
      wf(f,i). 
      rst().
    }
    //reboot.
  }).
}
