@lazyglobal off.{local l is "1:/boot.ks".if not exists(l)copyPath("0:/boot.ks",l).runPath(l).get("init.ks")("lib/satellite-main.ks")(2294204,1493902,170.9,{lock steering to lookDirUp(north:vector,-sun:position).}).}