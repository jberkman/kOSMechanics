{local a is get("lib/altitude-at.ks").put({parameter n.if n:eta>0 return a(time:seconds+n:eta).return 2^64.}).}