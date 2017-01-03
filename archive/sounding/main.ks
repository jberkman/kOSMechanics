put({local hlog is get("lib/hlog.ks").
  local science is get("lib/record-science.ks").
  if status="prelaunch"{
    local t is 30.
    until t < 0 {wait 1.hudText("T - "+t,0.9,2,-1,yellow,1).set t to t-1.}
    stage.
  }
  wait until verticalSpeed<-1.stage.
  hlog("Getting apoapsis science...").science().
  wait until status = "LANDED" or status = "SPLASHED".
  wait 5.hlog("Getting landed science...").science().
}).