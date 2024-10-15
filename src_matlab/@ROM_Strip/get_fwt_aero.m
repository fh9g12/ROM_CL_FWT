function [Q,alpha,L] = get_fwt_aero(p,U,t)
%GET_MAIN_AERO_Q Summary of this function goes here
%   Detailed explanation goes here
N = p.fwt_N;
pos = p.fwt_pos;
C_l = p.fwt_Cl;
A = p.get_fwt_A(U);
V_air = A'*p.get_air_velocity(t);

V_eff = repmat(V_air,1,N) + p.get_fwt_V_b(U,pos);
V_eff(2,:) = 0;
% get alpha
alpha = ones(1,N)*p.fwt_aoa_0;
idx = V_eff(1,:)~=0;
alpha(idx) = alpha(idx) + atan(V_eff(3,idx)./V_eff(1,idx));
% calc Lift wrench
L = 0.5*1.225.*vecnorm(V_eff).^2.*(p.fwt_c.*p.fwtSpan./N).*C_l.*alpha;
Ws = zeros(6,N);
Ws(3,:) = -L;
% get generalised force
Q = sum(p.get_fwt_Q(U,Ws,pos),2);
end

