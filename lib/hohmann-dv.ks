{local ov is get("lib/orbital-velocity.ks").put({parameter a,a0,a1. local d is a+2*body:radius.return ov(ship,a,a1+d)-ov(ship,a,a0+d).}).}