@lazyglobal off.
parameter vesselName, command, args is list().
{
  function send {
    parameter dst, msg.
    if dst = ship:name ship:messages:push(msg).
    else return vessel(dst):connection:sendMessage(msg).
    return true.
  }
  runPath("boot.ks").
  local hlog is get("lib/hlog.ks").
  local msg is list(command, args).
  if send(vesselName, msg) hlog("Command sent succesfully.").
  else hlog("Unable to send command.").
}