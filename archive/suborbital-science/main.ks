put({
  local science is get("lib/record-science.ks").
  wait until altitude>body:atm:height.
  stage. wait 10.science(1).
}).