function obj = apply_lift_dist(obj,dist,inner_N,spline,fwt_N,grad_correction,zeroAoA)
y = dist.ys;
C_l = dist.Cl;
c = dist.c;

% inner wing
obj.inner_N = inner_N;
pos = [zeros(1,(inner_N*2)+1);linspace(0,obj.innerSpan,(inner_N*2)+1);zeros(1,(inner_N*2)+1)];
obj.inner_pos = pos(:,2:2:(end-1));
y_inner = obj.inner_pos(2,:)./(obj.semiSpan);

obj.inner_Cl = interp1(y,C_l.*grad_correction,y_inner);
obj.inner_c = interp1(y,c,y_inner);
obj.inner_aoa_0 = -zeroAoA;

%interpolate eigenvectors
% obj.G = zeros(6,obj.DoFs,size(obj.inner_pos,2));
obj.G = spline.get_G(obj.inner_pos,obj.DoFs,1:obj.DoFs-1);

% fwt
obj.fwt_N = fwt_N;
pos = [zeros(1,(fwt_N*2)+1);...
    linspace(-tan(obj.Lambda)*obj.chord/4,obj.fwtSpan,(fwt_N*2)+1);zeros(1,(fwt_N*2)+1)];
obj.fwt_pos = pos(:,2:2:(end-1));
y_fwt = (obj.fwt_pos(2,:)+obj.semiSpan-obj.fwtSpan)./(obj.semiSpan);
obj.fwt_Cl = interp1(y,C_l.*grad_correction,y_fwt);
obj.fwt_c = interp1(y,c,y_fwt);
obj.fwt_aoa_0 = -zeroAoA;
end

