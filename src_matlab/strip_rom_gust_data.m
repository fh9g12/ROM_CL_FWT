data = [];
% Freqs = [4];
Freqs = [1,3,10];
amps = 0.5;

%% strip theory data (Linearise about zero)
Modes = [1,2,3,9];
% Modes = [1];
[model,sp] = ROM_Strip.FromRef(15,Modes);
d = model.generate_lift_distribution();
model.apply_lift_dist(d,10,sp,20,1,0);
model.u = 18;
model.alpha_r = 7.5;
model_struct = model.ToStruct();

% linearise about zero
U = zeros(model.DoFs*2+1,1);
U(model.DoFs) = deg2rad(0);
J = mbd.jacobiancd(@(x)gust_deriv(model,x),U);
f_0 = gust_deriv(model,U);

%find equilibium position
options = optimoptions('fsolve','Algorithm','levenberg-marquardt','Display','off');
U0 = fsolve(@(y)lin_deriv(J,f_0,U(1:end-1),y,0),U(1:end-1),options);

%apply gusts
for i = 1:length(Freqs)
    fprintf('LO-VLM Zero: Running Gust %.0f out of %.0f...',i,length(Freqs))
    tic;
    ts = -0.25:0.01:2.5;
    [ts,y] = ode45(@(t,y)lin_gust_deriv(J,f_0,U(1:end-1),y,t,Freqs(i),amps),ts,U0);
    t=toc;
    tmp_data = struct();
    tmp_data.Model = sprintf('ROM%.0f',length(Modes));
    tmp_data.Aero = "Strip";
    tmp_data.Lin = "Zero";
    tmp_data.Freq = Freqs(i);
    tmp_data.Amp = amps;
    tmp_data.Time = t;
    tmp_data.t = ts;
    tmp_data.U0 =  U0;
    tmp_data.fold = rad2deg(y(:,model.DoFs));
    tmp_data.wrbm = (model.WRBMi*y(:,1:(model.DoFs-1))')';
    data = dcrg.struct.concat(data,tmp_data);
    fprintf('Completed in %.3f seconds!\n',t);
end

%% strip theory data (Linearise about Eq)
[model,sp] = ROM_Strip.FromStruct(15,model_struct);
d = model.generate_lift_distribution();
model.apply_lift_dist(d,10,sp,20,1,0);
model.u = 18;
model.alpha_r = 7.5;

%find equilbrium
U = zeros(model.DoFs*2,1);
U_0 = model.find_equilibrium(U,0);

% linearise about Eq
U = [U_0;0];
J = mbd.jacobiancd(@(x)gust_deriv(model,x),U);
f_0 = gust_deriv(model,U);
deriv = @(t,y)f_0+J*y;

%find equilibium position
options = optimoptions('fsolve','Algorithm','levenberg-marquardt','Display','off');
U0 = fsolve(@(y)lin_deriv(J,f_0,U_0,y,0),U_0,options);

%apply gusts
for i = 1:length(Freqs)
    fprintf('LO-VLM Eq: Running Gust %.0f out of %.0f...',i,length(Freqs))
    tic;
    ts = -0.25:0.01:2.5;
    [ts,y] = ode45(@(t,y)lin_gust_deriv(J,f_0,U_0,y,t,Freqs(i),amps),ts,U0);
    t=toc;
    tmp_data = struct();
    tmp_data.Model = sprintf('ROM%.0f',length(Modes));
    tmp_data.Aero = "Strip";
    tmp_data.Lin = "Eq";
    tmp_data.Freq = Freqs(i);
    tmp_data.Amp = amps;
    tmp_data.Time = t;
    tmp_data.t = ts;
    tmp_data.U0 =  U0;
    tmp_data.fold = rad2deg(y(:,model.DoFs));
    tmp_data.wrbm = (model.WRBMi*y(:,1:(model.DoFs-1))')';
    data = dcrg.struct.concat(data,tmp_data);
    fprintf('Completed in %.3f seconds!\n',t);
end

%% strip theory data (Nonlinear simulation)
for i = 1:length(Freqs)
    [model,sp] = ROM_Strip.FromStruct(15,model_struct);
    d = model.generate_lift_distribution();
    model.apply_lift_dist(d,10,sp,20,1,0);
    model.u = 18;
    model.alpha_r = 7.5;
    
    %find equilbrium
    U = zeros(model.DoFs*2,1);
    U0 = model.find_equilibrium(U,0);
    
    %apply gust
    fprintf('LO-VLM NonLin: Running Gust %.0f out of %.0f...',i,length(Freqs))
    tic;
    ts = -0.25:0.01:2.5;
    model.set_gust(Freqs(i),amps,0)
    [ts,y] = ode45(@(t,y)model.deriv(t,y),ts,U0);
    t=toc;
    tmp_data = struct();
    tmp_data.Model = sprintf('ROM%.0f',length(Modes));
    tmp_data.Aero = "Strip";
    tmp_data.Lin = "Nonlin";
    tmp_data.Freq = Freqs(i);
    tmp_data.Amp = amps;
    tmp_data.Time = t;
    tmp_data.t = ts;
    tmp_data.U0 =  U0;
    tmp_data.fold = rad2deg(y(:,model.DoFs));
    tmp_data.wrbm = (model.WRBMi*y(:,1:(model.DoFs-1))')';
    data = dcrg.struct.concat(data,tmp_data);
    fprintf('Completed in %.3f seconds!\n',t);
end

%% save data
strip_data = data;
dt = datetime;
dt.Format = 'dd_MMM_uuuu_HH_mm_ss';
save(sprintf('strip_rom_M%.0f_gust_data_%s.mat',length(Modes),dt),"strip_data");

%% make plot
colors = fh.colors.colorspecer(3,'qual','HighCon');
figure(1);
clf;
Freqs = [1,3,10];
tt = tiledlayout(length(Freqs),1);
lins = ["Zero","Eq","Nonlin"];
names = ["Linear Sim.","Linear about Eq.","Nonlin"];
lines = ["-","-.",":"];
for f_i = 1:length(Freqs)
    nexttile(f_i)
    hold on
    for i = 1:length(lins)
        tmp = dcrg.struct.filter(data,{{'Freq',Freqs(f_i)},{'Lin',lins(i)}});
        p = plot(tmp(1).t,tmp(1).wrbm-tmp(1).wrbm(1));
        p.Color = colors(i,:);
        p.LineWidth = 1.5;
        p.LineStyle = lines(i);
        p.Annotation.LegendInformation.IconDisplayStyle = 'off';
    end
end
for i = 1:length(lins)
    p = plot(nan,nan,lines(i),'Color',colors(i,:),'LineWidth',1.5);
    p.DisplayName = names(i);
end
lg = legend();
lg.Location = 'east';
lg.FontSize = 10;
for i = 1:length(Freqs)
    nexttile(i)
    xlim([0,2])
    ylabel('WRBM [Nm]')
    xlabel('Time [s]')
    title(sprintf('Gust Frequency: %.1f Hz',Freqs(i)))
end

function dx = lin_gust_deriv(J,f_0,U_0,x,t,f,amp)
w = fh.OneMinusCosine(f,0,t)*amp;
dx = lin_deriv(J,f_0,U_0,x,w);
end

function dx = lin_deriv(J,f_0,U_0,x,w)
dx = J*[(x-U_0);w]+f_0;
dx = dx(1:end-1);
end

function dy = gust_deriv(model,y)
model.w = y(end);
dy = model.deriv(0,y(1:end-1));
dy = [dy;0];
end


