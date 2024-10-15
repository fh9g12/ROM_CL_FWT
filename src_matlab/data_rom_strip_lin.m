Modes = [1,2,3,9];
% Modes = [1];
[model,sp] = ROM_Strip.FromRef(15,Modes);
d = model.generate_lift_distribution();
model.apply_lift_dist(d,10,sp,20,1,0);
model.u = 18;
model.alpha_r = 5;
model.deriv(0,zeros(model.DoFs*2,1));

%% convert to linear
Vs = 0.25:0.25:40;

model.u = 20;
J = mbd.jacobiancd(@(x)model.deriv(0,x),zeros(model.DoFs*2,1));

deriv = @(t,y)f_0+J*y;
[evecs,eval] = eig(J);
f = abs(unique(diag(eval)))/(2*pi);

%% get freq data
F = nan(model.DoFs*2,length(Vs));
D = nan(model.DoFs*2,length(Vs));
ev = complex(F);
fold = nan(1,length(Vs));
for i = 1:length(Vs)
    model.u = Vs(i);
    model.alpha_r = 0;
    J = mbd.jacobiancd(@(x)model.deriv(0,x),zeros(model.DoFs*2,1));
    f_0 = model.deriv(0,zeros(model.DoFs*2,1));
%     deriv = @(t,y)f_0+J*y;
    %     y = fsolve(@(y)deriv(0,y),zeros(10,1));
    %     fold(i) = rad2deg(y(5));
    [evecs,ev] = eig(J);
    ev = diag(ev);
    F_n = abs(ev);
    D_tmp = -real(ev)./F_n;
    D_tmp(imag(ev)==0) = 1*sign(real(ev(imag(ev)==0)));
    F_tmp = F(:,i);
    F_tmp(imag(ev)~=0) = F_n(imag(ev)~=0).*sqrt(1-D_tmp(imag(ev)~=0).^2)/(2*pi);

    [~,idx] = sort(F_tmp);
    D(:,i) = D_tmp(idx);
    F(:,i) = F_tmp(idx);
    ev(imag(ev)~=0,i) = ev(imag(ev)~=0);
    ev(:,i) = ev(idx);
end
data_freq_strip = [];
for i = 1:length(Vs)
    for j = 1:size(F,1)
        if ~isnan(F(j,i)) && abs(D(j,i))<1
            tmp_data = struct();
            tmp_data.MODE = j;
            tmp_data.M = 0;
            tmp_data.rho = 1.225;
            tmp_data.V = Vs(i);
            tmp_data.D = -D(j,i);
            tmp_data.F = F(j,i);
            tmp_data.CMPLX = ev(j,i);
            tmp_data.Flare = 15;
            tmp_data.isLocked = false;
            data_freq_strip = dcrg.struct.concat(data_freq_strip,tmp_data);
        end
    end
end

figure(2);
tt = tiledlayout(2,1);
nexttile(1);
plot(Vs,F)
xlabel('Velocity [m/s]')
ylabel('Freqeuncy [Hz]')
nexttile(2);
hold on
plot(Vs,D)
plot(Vs,zeros(1,length(Vs)),'k-')
xlabel('Velocity [m/s]')
ylabel('Damping Ratio')
ylim([-0.5,0.5])

%% data static equilbirum
fold = nan(1,length(Vs));
data_eq_strip = [];
aoas = 2.5:2.5:7.5;
for a_i = 1:length(aoas)
    model.alpha_r = aoas(a_i);
    for i = 1:length(Vs)
        model.u = Vs(i);
        J = mbd.jacobiancd(@(x)model.deriv(0,x),zeros(model.DoFs*2,1));
        f_0 = model.deriv(0,zeros(model.DoFs*2,1));
        deriv = @(t,y)f_0+J*y;
        options = optimoptions('fsolve','Algorithm','levenberg-marquardt','Display','off');
        y = fsolve(@(y)deriv(0,y),zeros(model.DoFs*2,1),options);
        tmp_data = struct();
        tmp_data.AoA = aoas(a_i);
        tmp_data.Flare = 15;
        tmp_data.isLocked = false;
        tmp_data.V = Vs(i);
        tmp_data.Fold = rad2deg(y(model.DoFs));
        tmp_data.hda = rad2deg(model.get_hda(y));
        tmp_data.wrbm = model.WRBMi*y(1:model.DoFs-1);
        data_eq_strip = dcrg.struct.concat(data_eq_strip,tmp_data);
    end
end
%% plot
figure(1)
clf;
hold on
for a_i = 1:length(aoas)
    tmp = dcrg.struct.filter(data_eq_strip,{{'AoA',aoas(a_i)}});
    plot([tmp.V],[tmp.Fold])
end
ylim([-90 90])
xlabel('Velocity [m/s]')
ylabel('fold angle [deg]')
% save(sprintf('data_lin_rom_M%.0f_strip.mat',length(Modes)),"data_freq_strip","data_eq_strip");
