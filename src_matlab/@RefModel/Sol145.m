function [data,folder_name] = Sol145(obj,Vs,rho,M,opts,FlutterOpts)
arguments
    obj
    Vs
    rho
    M
    opts.BinFolder = ""
    opts.NumAttempts = 3
    opts.Silent = true;
    FlutterOpts.Ks = [];
end
fs = ads.nast.FlutterSim();
fs.FreqRange = [0 300];
fs.LModes = 20;
fs.V = Vs;
fs.Mach = M;
fs.rho = rho;
fs.FlutterMethod = 'PK';
if ~isempty(FlutterOpts.Ks)
    fs.ReducedFreqs = FlutterOpts.Ks;
end
obj.ids = fs.UpdateID(obj.ids);
opts_cell = namedargs2cell(opts);
[data,folder_name] = fs.get_flutter_data(obj.FeModel,opts_cell{:});
end

