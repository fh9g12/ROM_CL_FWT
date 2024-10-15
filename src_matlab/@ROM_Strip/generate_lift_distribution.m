function [dist] = generate_lift_distribution(obj,opts)
arguments
    obj
    opts.u = 20;
    opts.alpha = 1;
end
%% setup model
y_station = [0 obj.semiSpan];
CE = [zeros(1,2);y_station;0 0];
twist = [0 0];
c = [obj.chord,obj.chord];
LE = zeros(size(CE));
TE = zeros(size(CE));
% adjust for setting angle 
for i = 1:length(c)
    LE(:,i) = CE(:,i) - [cosd(twist(i));0;-sind(twist(i))]*c(i)/4;
    TE(:,i) = CE(:,i) + [cosd(twist(i));0;-sind(twist(i))]*c(i)/4*3;
end

wing = laca.model.Wing.From_RHS_LE_TE(LE,TE,{});
model = laca.model.Aircraft({wing});
model.Name = 'WT_Model';
vlm_model = laca.vlm.Model.From_laca_model(...
                model,0.025,1,true);
vlm_model.set_panel_filiments();

%% solve VLM at 0 alpha
obj.alpha_r = 0;
obj.u = opts.u;
obj.beta_r = 0;

V_func = obj.get_air_velocity(0);
V_dir = V_func./vecnorm(V_func);
vlm_model.generate_te_horseshoe(V_dir * 10);
vlm_model.generate_AIC3D();
vlm_model.solve(V_func);
% vlm_model.apply_result_ring(1.225);
vlm_model.apply_result_katz(1.225);
L_0 = vlm_model.Get_Prop('L');

%% solve VLM at 1 alpha
obj.alpha_r = opts.alpha;
V_func = obj.get_air_velocity(0);
V_dir = V_func./vecnorm(V_func);
vlm_model.generate_te_horseshoe(V_dir * 10);
vlm_model.generate_AIC3D();
vlm_model.solve(V_func);
vlm_model.apply_result_katz(1.225);
L_5 = vlm_model.Get_Prop('L');

%% generate Lift Dist
centroid = vlm_model.Centroid;
area = vlm_model.Area;
centroid(2,:) = round(centroid(2,:),4);

ys = unique(centroid(2,:));
ys = [-y_station(end),ys,y_station(end)];
Cl = zeros(size(ys));
L = zeros(size(ys));
V = norm(obj.get_air_velocity(0));
for i = 1:length(ys)-2
    idx = centroid(2,:)==ys(i+1);
    tmp_L = L_5(idx)-L_0(idx);
    Cl(i+1) = 2*sum(tmp_L)/(1.225*V^2*sum(area(idx))*deg2rad(obj.alpha_r));
    L(i+1) = sum(L_5(idx))/sum(area(idx));
end
dist = struct();
dist.ys = ys./ys(end);
dist.Cl = Cl;
dist.c = interp1(y_station,c,abs(ys));
%% plot VLM model
f = figure(1);
clf;
hold on;
vlm_model.draw('param','Lprime');
f.CurrentAxes.ZDir = 'Reverse';
ax = gca;
% ax.Clipping = 'off';
axis equal
ylim([-1.2,0])
end



