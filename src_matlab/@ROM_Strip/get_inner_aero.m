function [Q,L] = get_inner_aero(p,U,t) %#codegen
%GET_MAIN_AERO_Q Summary of this function goes here
%   Detailed explanation goes here
N = p.inner_N;
pos = p.inner_pos;
C_l = p.inner_Cl;
Qs = zeros(length(U)/2,N);
alpha = zeros(1,N);
L = zeros(1,N);
A = p.get_body_A(U);
V_air = A'*p.get_air_velocity(t);
for i = 1:size(pos,2) 
    V_eff = V_air + p.G(1:3,:,i)*U(p.DoFs+1:end);
%     V_eff = V_air + p.get_inner_V_b(U,pos(1,i),pos(2,i));
    %correct for surface direction
%     surf_norm = p.get_surf_z(U,pos(1,i),pos(2,i));
%     surf_norm = surf_norm./norm(surf_norm);
%     surf_x= p.get_surf_x(U,pos(2,i));
%     surf_x = surf_x./norm(surf_x);
%     surf_y = cross(surf_norm,surf_x);
%     R = [surf_x,surf_y,surf_norm];
%     V_eff = R*V_eff;

    % get lift
    V_eff(2,:) = 0;
    if V_eff(1,:) ~= 0
        alpha(i) = real(atan(V_eff(3,:)./V_eff(1,:))) + p.inner_aoa_0;
    end
    L(i) = 0.5*1.225.*(V_eff'*V_eff).*(p.inner_c(i)*p.innerSpan/N).*C_l(i).*alpha(i);
    W = [0,0,-L(i),0,0,0]';
    Qs(:,i) = p.G(:,:,i)'*W;
end
Q = sum(Qs,2);
end
