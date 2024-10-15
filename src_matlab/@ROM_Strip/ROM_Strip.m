classdef ROM_Strip < ROM_M4_FWT_RC
    properties
        fwtSpan = 0.2;
        chord = 0.12;
        semiSpan = 1;
        innerSpan = 0.8;
    end
    properties
       u = 0;
       v = 0;
       w = 0;
       alpha_r = 0;
       beta_r = 0;
       artifical_damping = 0;
       y_0_aero = 0
       Spline fh.tpapSpline
       G;

       WRBMi;
    end
    properties(Hidden)
       gust = false;
       gust_length = 0;
       gust_amplitude = [0;0;0];
       gust_t1 = 0;
       gust_t2 = 0;
       gust_freq = 0;
       gust_period = 0;
    end
    properties
       gust_UseTimeSeries = false;
       gust_ti = [0,1];
       gust_Vi = zeros(2,3);
    end
    %Aero
    properties
        inner_N;
        inner_pos;
        inner_Cl;
        inner_c;
        inner_aoa_0;
        fwt_N;
        fwt_pos;
        fwt_Cl;
        fwt_aoa_0;
        fwt_c;
    end
    methods
        function obj = add_artifical_damping(obj,damping)
            obj.artifical_damping = damping;
        end
        function set_gust(obj,f,amp,delay)
            obj.gust_t1 = delay;
            obj.gust_t2 = delay + 1/f;
            obj.gust_amplitude = [0;0;amp];
            obj.gust_freq = f;
        end
    end
    methods(Static)
        function [obj,sp] = FromRef(flare_angle,Modes)
            %% create nastran model
            NastranRefModel = RefModel(flare_angle,0);
            [feModel,ids] = NastranRefModel.gen_feModel("IncludeWingtip",false);
            %% Run 103 Analysis
            fs = ads.nast.Sol103();
            fs.FreqRange = [0 400];
            fs.LModes = 20;
            fs.Grav_Vector = [0;0;-1];
            fs.UpdateID(ids);
            [~,folder_name] = fs.run(feModel,"BinFolder","bin_103","NumAttempts",1,"Silent",true);
            %% get Modal data
            h5 = mni.result.hdf5(fullfile(folder_name,'bin','sol103.h5'));
            res_modal_force = h5.read_modal_force_CBEAM();
            res_modes = h5.read_modeshapes;
            % extract Hinge modeshape
            idx_SAH = find([feModel.Points.Tag] == "SAH",1);
            GID = [feModel.Points(idx_SAH).ID];
            idx = find(res_modes(Modes(1)).IDs == GID,1);
            S = cell2mat(arrayfun(@(x)x.EigenVector(idx,1:3)',res_modes(Modes),'UniformOutput',false));
            R = cell2mat(arrayfun(@(x)x.EigenVector(idx,4:6)',res_modes(Modes),'UniformOutput',false));
            WRBMi = arrayfun(@(x)x.Mz(1,1),res_modal_force(Modes));
            
            % Get smoothing splines
            GIDs = [feModel.Points.ID];
            Xs = [feModel.Points.GlobalPos];
            sp = fh.tpapSpline(Xs,res_modes,GIDs,Modes);

            % create a combined model
            obj = ROM_Strip(flare_angle,[res_modes(Modes).gen_mass],[res_modes(Modes).gen_stiff],...
                S,R,feModel.Points(idx_SAH).GlobalPos(),WRBMi,sp);
        end
        function [obj,sp] = FromStruct(flare_angle,s)
            obj = ROM_Strip(flare_angle,s.M,s.K,s.S,s.R,s.X_h,s.WRBMi,s.Spline);
            sp = s.Spline;
        end
    end
    methods
        function s = ToStruct(obj)
            s = struct();
            s.M = obj.M;
            s.K = obj.K;
            s.S = obj.S;
            s.R = obj.R;
            s.WRBMi = obj.WRBMi;
            s.Spline = obj.Spline;
            s.X_h = obj.X_h;
        end
        function obj = ROM_Strip(flare_angle,M,K,S,R,X_h,WRBMi,Spline,opts)
            arguments
                flare_angle (1,1) double
                M (1,:) double
                K (1,:) double
                S (3,:) double
%                 S_hn (3,:) double
                R (3,:) double
                X_h (3,1) double
                WRBMi (1,:) double
                Spline fh.tpapSpline
                opts.c = 0.12;
            end
            obj.g = 9.81;
            obj.g_v = [0, 0, 1];

            %geometry parmeters
            obj.Lambda = deg2rad(flare_angle);
            obj.chord = 0.12;
            obj.semiSpan = 1;
            obj.fwtSpan = 0.2;
            obj.X_h = X_h;
%             obj.X_h = [0 0.8 + obj.chord/4*tan(obj.Lambda) 0];

            %Inner Wing properties
            obj.M = M;
            obj.K = K;
            obj.S = S;
            obj.R = R;
            obj.WRBMi = WRBMi;
            obj.Spline = Spline;

            %hinge props
            obj.k_h = 1e-4;
            obj.d_h = 0;

            %fwt mass properties 
            obj.m_f = 167e-3;
            obj.I_f = [942, 122, 1057]*1e-6;
            obj.X_f = [-22e-3+opts.c/4, 87e-3, 0];
        end
    end
end


