@lazyglobal off.{local l is "1:/boot.ks".if not exists(l)copyPath("0:/boot.ks",l).runPath(l).get("init.ks")("scisat2/launch.ks")().}