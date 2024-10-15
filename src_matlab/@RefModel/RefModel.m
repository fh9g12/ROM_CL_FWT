classdef RefModel <handle
    %REFMODEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        L = 0.765;
        L_hinge = 0.8;
        
        Chord = 0.12;
        nChord = 5;
        WingAspectRatio = 2;
        WingtipAspectRatio = 1;

        %Wingtip Properties
        L_wingtip = 0.2;
        NWingtipEle = 5;

        
        %bar properties
        BarThickness = 4e-3;
        BarWidth = 30e-3;
        BarChordwisePos = 0.25
        NBeams = 12;

        %Hinge Properties
        Flare = 15;
        isLocked = false;
        Fold = 0;

        %Root AoA
        RootAoA = 0;

        %FeModel
        FeModel ads.fe.Component;
        ids ads.fe.IDs;
    end
    properties(Dependent)
        GravVector
    end
    methods
        function val = get.GravVector(obj)
            val = fh.roty(obj.RootAoA)'*[0;0;1];
        end
    end
    
    methods
        function obj = RefModel(Flare,Fold)
            %REFMODEL Construct an instance of this class
            %   Detailed explanation goes here
            obj.Flare = Flare;
            obj.Fold = Fold;
        end
    end
end

