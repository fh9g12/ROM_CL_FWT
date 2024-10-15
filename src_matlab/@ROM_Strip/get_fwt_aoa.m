function [alpha] = get_fwt_aoa(p,U,t)
%GET_MAIN_AERO_Q Summary of this function goes here
%   Detailed explanation goes here
A = p.get_fwt_A(U);
V_air = A'*p.get_air_velocity(t);
V_air(2,:) = 0;
alpha = atan(V_air(3,:)./V_air(1,:));
end

