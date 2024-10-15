function [data,dp,df,folder_name] = Sol144(obj,V,rho,M,aoa,opts)
arguments
    obj
    V
    rho
    M
    aoa
    opts.BinFolder = ""
    opts.NumAttempts = 3
    opts.Silent = true;
end
fs = ads.nast.TrimSim();
fs.FreqRange = [0 300];
fs.LModes = 20;
fs.set_trim_locked(V,rho,M);
fs.ANGLEA.Value = deg2rad(aoa);
fs.Grav_Vector = [0;0;-1];
obj.ids = fs.UpdateID(obj.ids);
opts_cell = namedargs2cell(opts);
[data,dp,df,folder_name] = fs.get_trim_data(obj.FeModel,opts_cell{:});
end

