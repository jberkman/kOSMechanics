{
  local hlog is get("lib/hlog.ks").
  local science is get("lib/record-science.ks").
  put({
    if status="prelaunch"{
      local t is 10.
      until t<0{wait 1.hudText("T - "+t,0.9,2,-1,yellow,1).set t to t-1.}
    }
    hlog("Staging...").stage.
  }).
}