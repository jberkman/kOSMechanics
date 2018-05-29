{
  local cn is g00_02("p/fd 10.ks").
  local hal is g00_02("p/fd 0f.ks").
  local find is g00_02("p/fd 13.ks").
  local xfer is g00_02("p/fd 15.ks").
  local approach is g00_02("p/fd 17.ks").
  local dv is g00_02("p/fd 0e.ks").
  g00_01({parameter pr,th is 0.
    g00_03("PGM 03 0A").
    set target to pr.
    local h is hal().
    local hvec is vcrs(prograde:vector,up:vector).
    h["add"](0.25,{parameter n.
      if n:eta<0 return 2^64.
      local t is time:seconds+n:eta.
      // compute angle from peri to peer at my apo, which is off by ~180.
      local pos is positionAt(ship,t-0.01)-body:position.
      local pPos is body:position-positionAt(pr,t+n:obt:period/2).
      local hPos is vcrs(pos:normalized,pPos:normalized).
      local a is-vAng(pPos,pos).
      if vang(hpos,hvec)>90 set a to-a.
      //clearVecDraws().
      //VecDraw(V(0,0,0),pPos:normalized*20,green,"PEER",1,1,1).
      //VecDraw(V(0,0,0),pos:normalized*20,red,"POS",1,1,1).
      //print "Theta: "+a+" x: "+vang(hpos,hvec)+" t: "+abs(a-th).
      //wait 1.
      return a-th.
    }).
    cn().
    local t is time:seconds+obt:period.
    add find(h["solve"]@,Node(t,0,0,dv(t,pr:altitude)),List(obt:period/12,0,0,0)).
    wait 0.
  }).
}