function [feModel,ids] = gen_feModel(obj,opts)
arguments
    obj RefModel
    opts.IncludeWingtip = true;
end
model = baff.Model;
model.Name = 'DemoWing';

% Make Aero Bar
mainBeam = baff.Wing.UniformWing(obj.L,obj.BarThickness,obj.BarWidth...
    ,baff.Material.Stainless400,obj.Chord,obj.BarChordwisePos);
mainBeam.Stations = mainBeam.Stations.interpolate(linspace(0,1,obj.NBeams+1));
mainBeam.Name = 'InnerBeam';
mainBeam.A = ads.util.rotz(90)*ads.util.rotx(180);

% Add Masses
xs = [-21,-21,-21,-21,-21,-17]*1e-3 + (obj.BarChordwisePos-0.25)*obj.Chord;
ys = [100,240,380,520,660,767]*1e-3;
mass = [ones(1,5)*0.075,0.056];
inertias = [ones(1,5)*82,26;ones(1,5)*73,32;ones(1,5)*151,56]*1e-6;
% load('Wing2ndMass.mat')
for i = 1:length(xs)
    tmp_mass = baff.Mass(mass(i));
    tmp_mass.Eta = ys(i)/obj.L;
    tmp_mass.Offset(2) = xs(i);
    tmp_mass.Name = sprintf('tmp_mass_%.0f',i);
    tmp_mass.InertiaTensor = diag(inertias(:,i)');
    tmp_mass.mass= mass(i);
    mainBeam.add(tmp_mass);
end
if ~opts.IncludeWingtip
    % still include a grid point for the hinge
    hinge = baff.Point();
    hinge.Eta = 1;
    hinge.Offset = [(obj.BarChordwisePos-0.5)*obj.Chord obj.L_hinge-obj.L 0];
    hinge.Name = 'SAH';
    mainBeam.add(hinge);
if opts.IncludeWingtip
    % create hinge
    hinge = baff.Hinge();
    hinge.HingeVector = fh.rotz(-obj.Flare)*[0;1;0];
    hinge.K = 1e-4;
    hinge.C = 0;
    hinge.Rotation = -obj.Fold;
    hinge.isLocked = obj.isLocked;
    hinge.Eta = 1;
    hinge.Offset = [0 (obj.BarChordwisePos-0.5)*obj.Chord obj.L_hinge-obj.L 0];
    hinge.Name = 'SAH';
    mainBeam.add(hinge);

    % add wingtip
    wingtip = baff.Wing.UniformWing(obj.L_wingtip,4e-3,30e-3,baff.Material.Stiff,obj.Chord,0.5);
    wingtip.Eta = 1;
    wingtip.Stations = wingtip.Stations.interpolate(linspace(0,1,obj.NWingtipEle+1));
    wingtip.Name = 'Wingtip';
    hinge.add(wingtip);

    %add wingtip mass
    tmp_mass = baff.Mass(0.167);
    tmp_mass.Offset = [0.087,obj.Chord/4-0.022,0];
    tmp_mass.Name = 'wingtip_mass';
    tmp_mass.InertiaTensor = diag([122,942,1057])*1e-6;
    wingtip.add(tmp_mass);
end

% Add Constraint
con = baff.Constraint("ComponentNums",123456,"eta",0,"Name","Root Connection");
con.add(mainBeam);

% create baff model
model = baff.Model();
model.Name = "DemoWing";
model.AddElement(con);

% generate final model
baffOpts = ads.baff.BaffOpts();
baffOpts.SplitBeamsAtChildren = false;
feModelFull = ads.baff.baff2fe(model,baffOpts);
feModel = feModelFull.Flatten;
% Add Aero Settings
aoa = obj.RootAoA;
feModel.CoordSys(end+1) = ads.fe.CoordSys(Origin=[0;0;0],A=dcrg.rotzd(180)*dcrg.rotyd(aoa));
feModel.AeroSettings(1) = ads.fe.AeroSettings(0.12,1,2,1*0.12,ACSID=feModel.CoordSys(end),SymXZ=true);
for i = 1:length(feModel.AeroSurfaces)
    feModel.AeroSurfaces(i).AeroCoordSys = feModel.CoordSys(end);
end

%% update splining stratergies
for i = 1:length(feModel.AeroSurfaces)
    feModel.AeroSurfaces(i).SplineType = 6;
end
if opts.IncludeWingtip
    StructuralPoints = [feModel.AeroSurfaces(1).StructuralPoints;feModel.AeroSurfaces(2).StructuralPoints];
    feModel.AeroSurfaces(1).DisplacementPoints = StructuralPoints;
    feModel.AeroSurfaces(2).DisplacementPoints = StructuralPoints;
end

%% sort output
ids = feModel.UpdateIDs();
obj.FeModel = feModel;
obj.ids = ids;
end

