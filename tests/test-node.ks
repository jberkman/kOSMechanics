{
  if not hasNode add Node(time:seconds+obt:period/2,0,0,-obt:velocity:orbit:mag/2).
  wait 0.
  print "Eccentricity: "+nextNode:obt:eccentricity+" ("+obt:eccentricity+")".
}