{
  local cn is get("lib/clear-nodes.ks").
  local hc is get("lib/hill-climb.ks").
  put({parameter x,mk,ev.
    function ev_{parameter x.
      cn(). local nd is mk(x).add nd. wait 0.
      local y is ev(nd).remove nd. wait 0.
      return y.
    }
    return mk(hc(hc(hc(hc(x,ev_@,100),ev_@,10),ev_@,1),ev_@,0.1)).
  }).
}