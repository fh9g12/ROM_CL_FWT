function out = get_fwt_A(p,U)
	%GET_FWT_A Auto-generated function from moyra
	%
	%	Created at : Tue Oct 15 11:55:06 2024 
	%	Created with : moyra https://pypi.org/project/moyra/
	%
	%% extract required parameters from structure
	R = p.R;
	Lambda = p.Lambda;
	%% create common groups
	rep_1 = cos(Lambda);
	rep_2 = sin(Lambda);
	rep_3 = R(3,1).*U(1) + R(3,2).*U(2) + R(3,3).*U(3) + R(3,4).*U(4);
	rep_4 = -rep_1 + rep_2.*rep_3;
	rep_5 = -rep_4;
	rep_6 = sin(U(5));
	rep_7 = R(2,1).*U(1) + R(2,2).*U(2) + R(2,3).*U(3) + R(2,4).*U(4);
	rep_8 = cos(U(5));
	rep_9 = rep_1.*rep_3 + rep_2;
	rep_10 = -rep_6.*rep_7 - rep_8.*rep_9;
	rep_11 = R(1,1).*U(1) + R(1,2).*U(2) + R(1,3).*U(3) + R(1,4).*U(4);
	rep_12 = rep_11.*rep_6 - rep_4.*rep_8;
	rep_13 = -rep_1.*rep_7 + rep_11.*rep_2;
	rep_14 = rep_1.*rep_11 + rep_2.*rep_7;
	rep_15 = rep_14.*rep_8 - rep_6;
	%% create output vector
	out = [rep_1.*rep_5 - rep_10.*rep_2 rep_1.*rep_10 + rep_2.*rep_5 -rep_6.*rep_9 + rep_7.*rep_8;...
		 rep_1.*rep_9 - rep_12.*rep_2 rep_1.*rep_12 + rep_2.*rep_9 -rep_11.*rep_8 - rep_4.*rep_6;...
		 rep_1.*rep_13 - rep_15.*rep_2 rep_1.*rep_15 + rep_13.*rep_2 rep_14.*rep_6 + rep_8];
end