{
    local _fd20 is g00_02("p/fd 20.ks").
    local g0 is 9.81.//9.80665.
    g00_01({parameter pe is body:atm:Height+10000,i is 0,ap is pe.
        g00_03("PGM 02 09").
        sas on. wait 0. set sasMode to "prograde".
        local a is 2*body:radius+pe+ap.
        local vOrbit is sqrt(body:mu*(2/(body:radius+pe)+1/a)).
        until 0{
            local y0 is altitude.
            local t0 is 0.
            local v0 is velocity:orbit:mag.
            local m0 is mass*1000.
            local F is 1000*ship:availableThrust*throttle.

            local theta0 is _fd20(ship,velocity:orbit).
            local psi0 is 90-theta0.
            local dPsi is 0.5.
            local z0 is tan(psi0/2).

            list engines in eL.
            local mDot is 0.
            for e in eL if e:isp>0 set mDot to mDot+e:thrust/e:isp.
            set mDot to 1000*mDot/g0.

            local dX is 0.
            local dY is 0.

            until y0>=pe or dY<0 or psi0>=90{
                local g is body:mu/(y0+body:radius)^2.
                local n is F/m0/g.
                local C is v0/(z0^(n-1)*(1+z0^2)).

                local psi is psi0+dPsi.
                local z is tan(psi/2).

                local v is C*z^(n-1)*(1+z^2).
                local dT is C/g.
                {
                    local termA is z ^(n-1)*(1/(n-1)+(z ^2/(n+1))).
                    local termB is z0^(n-1)*(1/(n-1)+(z0^2/(n+1))).
                    set dT to dT*(termA-termB).
                }

                set dX to 0.5*(v0*sin(psi0)+v*sin(psi))*dT.
                set dY to 0.5*(v0*cos(psi0)+v*cos(psi))*dT.

                set t0 to t0+dT.
                set y0 to y0+dY.
                set m0 to m0-mDot*dT.

                set z0 to z.
                set v0 to v.
                set t0 to t0.
                set psi0 to psi.

                set dX to dX/dT.
                set dY to dY/dT.

                wait 0.
            }
            print "y: "+round(y0/1000,3)+"   dY: "+round(dY/1000,3)+"   dX: "+round(dX/1000,3).
            if y0<pe{
                if dX>vOrbit g00_03("FAST").
                else g00_03("LOW").
            }else if dX<vOrbit g00_03("SLOW").
            wait 1.
        }
    }).
}