function out = get_pos_fwt2global(p,U,Xi)
	%GET_POS_FWT2GLOBAL Auto-generated function from moyra
	%
	%	Created at : Tue Oct 15 11:55:06 2024 
	%	Created with : moyra https://pypi.org/project/moyra/
	%
	%% extract required parameters from structure
	S = p.S;
	Lambda = p.Lambda;
	X_h = p.X_h;
	R = p.R;
	%% create common groups
	rep_1 = cos(U(5));
	rep_2 = R(2,1).*U(1) + R(2,2).*U(2) + R(2,3).*U(3) + R(2,4).*U(4);
	rep_3 = sin(U(5));
	rep_4 = sin(Lambda);
	rep_5 = cos(Lambda);
	rep_6 = R(3,1).*U(1) + R(3,2).*U(2) + R(3,3).*U(3) + R(3,4).*U(4);
	rep_7 = rep_4 + rep_5.*rep_6;
	rep_8 = rep_4.*rep_6 - rep_5;
	rep_9 = -rep_8;
	rep_10 = -rep_1.*rep_7 - rep_2.*rep_3;
	rep_11 = R(1,1).*U(1) + R(1,2).*U(2) + R(1,3).*U(3) + R(1,4).*U(4);
	rep_12 = -rep_1.*rep_8 + rep_11.*rep_3;
	rep_13 = rep_11.*rep_5 + rep_2.*rep_4;
	rep_14 = rep_11.*rep_4 - rep_2.*rep_5;
	rep_15 = rep_1.*rep_13 - rep_3;
	%% create output vector
	out = [S(1,1).*U(1) + S(1,2).*U(2) + S(1,3).*U(3) + S(1,4).*U(4) + X_h(1) + (rep_1.*rep_2 - rep_3.*rep_7).*Xi(3,:) + (-rep_10.*rep_4 + rep_5.*rep_9).*Xi(1,:) + (rep_10.*rep_5 + rep_4.*rep_9).*Xi(2,:);...
		 S(2,1).*U(1) + S(2,2).*U(2) + S(2,3).*U(3) + S(2,4).*U(4) + X_h(2) + (-rep_1.*rep_11 - rep_3.*rep_8).*Xi(3,:) + (-rep_12.*rep_4 + rep_5.*rep_7).*Xi(1,:) + (rep_12.*rep_5 + rep_4.*rep_7).*Xi(2,:);...
		 S(3,1).*U(1) + S(3,2).*U(2) + S(3,3).*U(3) + S(3,4).*U(4) + X_h(3) + (rep_1 + rep_13.*rep_3).*Xi(3,:) + (rep_14.*rep_4 + rep_15.*rep_5).*Xi(2,:) + (rep_14.*rep_5 - rep_15.*rep_4).*Xi(1,:)];
end