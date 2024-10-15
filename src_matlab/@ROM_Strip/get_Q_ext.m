function [out] = get_Q_ext(p,U,t)
%GET_AERO_Q Summary of this function goes here
%   Detailed explanation goes here
if p.u == 0
    out = 0;
else
    out = get_inner_aero(p,U,t) + get_fwt_aero(p,U,t) + get_art_damping(p,U,t);
end
end

