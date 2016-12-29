@lazyglobal off.
parameter vesselName, patch.
{
  function send {
    parameter dst, msg.
    if dst = ship:name ship:messages:push(msg).
    else return vessel(dst):connection:sendMessage(msg).
    return true.
  }
  runPath("boot.ks").
  local hlog is get("lib/hlog.ks").
  local msg is list("lib/patch.ks", list(patch)).
  if send(vesselName, msg) hlog("Patch sent succesfully.").
  else hlog("Unable to send patch.").
}