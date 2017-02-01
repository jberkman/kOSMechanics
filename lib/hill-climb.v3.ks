// Inspired by Kevin Gisi http://youtube.com/gisikw
{
  local map is get("lib/map.ks").
  put({
    local goals is List().
    local epsilons is List().
    local evals is List().
    return lex(
      "add",{parameter goal, epsilon, eval.
        goals:add(goal).
        epsilons:add(epsilon).
        evals:add(eval).
      },
      "seek",{parameter point, steps, remap is {parameter x.return x.}, acceleration is 1.2.
        local candidates is List(-acceleration,-1/acceleration,0,1/acceleration,acceleration).
        function satisfyGoal{parameter goalIndex.
          local goal is goals[goalIndex].
          local epsilon is epsilons[goalIndex].
          local eval is evals[goalIndex].
          local bestScore is abs(eval(remap(point))-goal).
          local done is 0.
          until 0{
            set done to 1.
            local i is 0.until i=point:length{
              if steps[i]<>0{
                //print goalIndex+": "+i+" "+round(steps[i],6).
                local best is -1.
                local j is 0.until j=candidates:length{
                  local t is point[i].
                  set point[i] to point[i]+steps[i]*candidates[j].
                  local remapped is remap(point).
                  local k is 0.until k=goalIndex{
                    if abs(evals[k](remapped)-goals[k])>epsilons[k]break.
                    set k to k+1.
                  }
                  if k<goalIndex{
                    print "-"+k+": "+(abs(evals[k](remapped)-goals[k])).
                  }
                  local cur is abs(eval(remapped)-goal).
                  if k=goalIndex and cur<bestScore{
                    set bestScore to cur.
                    set best to j.
                    //print "("+point:join(", ")+")["+goalIndex+"] + "+(steps[i]*candidates[j])+" => "+bestScore.
                  }
                  set point[i] to t.
                  set j to j+1.
                }
                //print "best: "+best.
                if best<0 or candidates[best]=0 set steps[i] to steps[i]/acceleration.
                else{
                  set steps[i] to steps[i]*candidates[best].
                  set point[i] to point[i]+steps[i].
                  print "+"+goalIndex+": "+bestScore.
                  if bestScore*2<epsilon return.
                  set done to 0.
                }
              }
              set i to i+1.
            }
          }
        }
        function findUnmetGoal{
          local remapped is remap(point).
          local goalIndex is 0.until goalIndex=goals:length{
            if abs(evals[goalIndex](remapped)-goals[goalIndex])>epsilons[goalIndex] return List(0, goalIndex).
            print "resolved: "+goalIndex.
            set goalIndex to goalIndex+1.
          }
          return List(1).
        }
        until 0{
          local goal is findUnmetGoal().
          if goal[0]return point.
          print "resolving: "+goal[1].
          satisfyGoal(goal[1]).
        }
      }
    ).
  }).
}