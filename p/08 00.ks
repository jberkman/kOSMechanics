{
    local g0 is 9.81.//9.80665.
    g00_01({parameter mode, params.
        if mode<>1 print 1/0.
        local eL is 0.
        local t_b is-1.
        local lock t_go to t_b.
        until 0{
            list engines in eL.
            local mDot is 0.
            local f_T is 0.
            local loxDot is 0.
            for e in eL{
                set f_T to f_T+e:thrust.
                set loxDot to loxDot+e:fuelFlow.
                if e:isp>0 set mDot to mDot+e:thrust/e:isp.
            }
            if mDot>0{
                set mDot to mDot/g0.
                set t_b to stage:oxidizer/loxDot/0.55.
                local a_T is f_T/mass.
                local v_ex is f_T/mDot.
                local tau is v_ex/a_T.
                //print "t_b: "+t_b+"    tau: "+tau+"    v_ex: "+v_ex+"    f_T: "+f_T.

                local L is-v_ex*ln((tau-t_b)/tau).
                local J is L*tau-v_ex*t_b.
                local S is-J+t_b*L.
                local Q is S*(tau+t_go)+0.5*v_ex*t_b^2.
                local P is Q*(tau+t_go)-0.5*v_ex*t_b^2*(t_b/3+t_go).

                set J to J+L*t_go.
                set S to S+L*t_b.
                set Q to Q+J*t_b.
                set H to t_go*J-Q.
                set P to P+H*t_b.

                print "t_b: "+round(t_b,1)+"    L: "+round(L,2)+"    J: "+round(J,2)+"    S: "+round(S,2)+"    Q: "+round(Q,2)+"    P: "+round(P,2)+"    H: "+round(H,2).
                //set t_b to tau*(1-constant:e^(-L/v_ex)).
            }
            wait 1.
        }
    }).
}