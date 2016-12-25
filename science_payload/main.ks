{put({local hlog is get("lib/hlog.ks").
  local science is get("lib/record_science.ks").
  wait until ship:modulesNamed("kOSProcessor"):length = 1.
  hlog("Getting deployed science...").
  science().
  wait until verticalSpeed<-1.
  hlog("Getting apoapsis science...").
  science().
  wait until status = "LANDED" or status = "SPLASHED".
  wait 5.
  hlog("Getting landed science...").
  science().
}).}