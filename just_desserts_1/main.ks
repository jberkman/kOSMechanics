{
    local hlog is get("lib/hlog.ks").
    hlog("Collecting science in 5 seconds...").
    wait 5.

    function cxtx {
        parameter p. set p to p:getModule("ModuleScienceExperiment").
        hlog("Collecting science from " + p:part:title).
        if not p:inoperable and not p:deployed p:deploy().
        wait 1.
    }

    for n in get("lib/science_parts.ks") for p in ship:partsNamed(n) cxtx(p).
}