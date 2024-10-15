function set_aoa(p,aoa)
%SET_AOA Summary of this function goes here
%   Detailed explanation goes here
p.alpha_r = aoa;
p.g_v = fh.roty(aoa)*[0 0 1]';
end

