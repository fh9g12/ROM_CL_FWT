function [out] = get_air_velocity(p,t)
%GET_AIR_VELOCITY Summary of this function goes here
%   Detailed explanation goes here
V = [p.u;p.v;p.w];

if t >p.gust_t1 && t<p.gust_t2
    V = V + p.gust_amplitude*0.5*(1-cos(2*pi*p.gust_freq*(t-p.gust_t1)));
end
if p.gust_UseTimeSeries
    V = V + interp1(p.gust_ti,p.gust_Vi,t,'linear',0)';
end

out = dcrg.rotyd(-p.alpha_r)*dcrg.rotzd(-p.beta_r)*V;
end

