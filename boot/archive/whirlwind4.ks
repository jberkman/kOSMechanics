@lazyglobal off.{local l is "1:/boot.ks".if not exists(l)copyPath("0:/boot.ks",l).runPath(l).get("init.ks")("satellite/whirlwind4/main.ks")(Minmus,414610,301271,179,272.6,79,{lock steering to lookDirUp(north:vector,-sun:position).}).}