function out = get_fwt_V_global(p,U,Xi)
	%GET_FWT_V_GLOBAL Auto-generated function from moyra
	%
	%	Created at : Tue Oct 15 11:55:06 2024 
	%	Created with : moyra https://pypi.org/project/moyra/
	%
	%% extract required parameters from structure
	S = p.S;
	Lambda = p.Lambda;
	R = p.R;
	%% create common groups
	rep_1 = cos(U(5));
	rep_2 = R(2,1).*U(6) + R(2,2).*U(7) + R(2,3).*U(8) + R(2,4).*U(9);
	rep_3 = R(2,1).*U(1) + R(2,2).*U(2) + R(2,3).*U(3) + R(2,4).*U(4);
	rep_4 = sin(U(5));
	rep_5 = rep_4.*U(10);
	rep_6 = cos(Lambda);
	rep_7 = R(3,1).*U(6) + R(3,2).*U(7) + R(3,3).*U(8) + R(3,4).*U(9);
	rep_8 = rep_6.*rep_7;
	rep_9 = sin(Lambda);
	rep_10 = R(3,1).*U(1) + R(3,2).*U(2) + R(3,3).*U(3) + R(3,4).*U(4);
	rep_11 = rep_10.*rep_6 + rep_9;
	rep_12 = rep_1.*U(10);
	rep_13 = -rep_1.*rep_8 + rep_11.*rep_4.*U(10) - rep_12.*rep_3 - rep_2.*rep_4;
	rep_14 = rep_8.*rep_9;
	rep_15 = R(1,1).*U(6) + R(1,2).*U(7) + R(1,3).*U(8) + R(1,4).*U(9);
	rep_16 = R(1,1).*U(1) + R(1,2).*U(2) + R(1,3).*U(3) + R(1,4).*U(4);
	rep_17 = rep_7.*rep_9;
	rep_18 = rep_10.*rep_9 - rep_6;
	rep_19 = -rep_1.*rep_17 + rep_12.*rep_16 + rep_15.*rep_4 + rep_18.*rep_5;
	rep_20 = rep_15.*rep_6 + rep_2.*rep_9;
	rep_21 = rep_16.*rep_6 + rep_3.*rep_9;
	rep_22 = rep_15.*rep_9 - rep_2.*rep_6;
	rep_23 = rep_1.*rep_20 - rep_12 - rep_21.*rep_5;
	%% create output vector
	out = [S(1,1).*U(6) + S(1,2).*U(7) + S(1,3).*U(8) + S(1,4).*U(9) + (rep_13.*rep_6 - rep_7.*rep_9.^2).*Xi(2,:) + (-rep_13.*rep_9 - rep_14).*Xi(1,:) + (rep_1.*rep_2 - rep_11.*rep_12 - rep_3.*rep_5 - rep_4.*rep_8).*Xi(3,:);...
		 S(2,1).*U(6) + S(2,2).*U(7) + S(2,3).*U(8) + S(2,4).*U(9) + (rep_14 + rep_19.*rep_6).*Xi(2,:) + (-rep_19.*rep_9 + rep_6.^2.*rep_7).*Xi(1,:) + (-rep_1.*rep_15 - rep_12.*rep_18 + rep_16.*rep_4.*U(10) - rep_17.*rep_4).*Xi(3,:);...
		 S(3,1).*U(6) + S(3,2).*U(7) + S(3,3).*U(8) + S(3,4).*U(9) + (rep_22.*rep_6 - rep_23.*rep_9).*Xi(1,:) + (rep_22.*rep_9 + rep_23.*rep_6).*Xi(2,:) + (rep_12.*rep_21 + rep_20.*rep_4 - rep_5).*Xi(3,:)];
end