clear all

Modes = [1,2,3,9];
[model,sp] = ROM_Strip.FromRef(15,Modes);
d = model.generate_lift_distribution();
model.apply_lift_dist(d,10,sp,20,1,0);
model.u = 18;
model.alpha_r = 5;
model.deriv(0,zeros(model.DoFs*2,1))

%% run simulation
tic;
sol = ode45(@(t,y)model.deriv(t,y),[0,4],zeros(model.DoFs*2,1));
toc;

%% convert to linear
J = mbd.jacobiancd(@(x)model.deriv(0,x),zeros(model.DoFs*2,1));
f_0 = model.deriv(0,zeros(10,1));
tic;
sol_lin = ode45(@(t,y)f_0+J*y,[0,4],zeros(model.DoFs*2,1));
toc;

%% do interpolate J

%% make plot
figure(1);
clf;
hold on
plot(sol.x,sol.y(5,:))
plot(sol_lin.x,sol_lin.y(5,:))
xlabel('Time [s]')
ylabel('Fold Angle [red]')
% plot(sol_lin2.x,sol_lin2.y(5,:))
legend('Nonlinear Simualtion','Linearised Sim.')

% function d = deriv_Js(t,y,Js)
% interp1
% end