function out = get_fwt_V_b(p,U,Xi)
	%GET_FWT_V_B Auto-generated function from moyra
	%
	%	Created at : Tue Oct 15 11:55:06 2024 
	%	Created with : moyra https://pypi.org/project/moyra/
	%
	%% extract required parameters from structure
	S = p.S;
	Lambda = p.Lambda;
	R = p.R;
	%% create common groups
	rep_1 = cos(Lambda);
	rep_2 = sin(Lambda);
	rep_3 = R(3,1).*U(1) + R(3,2).*U(2) + R(3,3).*U(3) + R(3,4).*U(4);
	rep_4 = rep_1.*rep_3 + rep_2;
	rep_5 = sin(U(5));
	rep_6 = R(1,1).*U(1) + R(1,2).*U(2) + R(1,3).*U(3) + R(1,4).*U(4);
	rep_7 = cos(U(5));
	rep_8 = -rep_1 + rep_2.*rep_3;
	rep_9 = rep_5.*rep_6 - rep_7.*rep_8;
	rep_10 = R(1,1).*U(6) + R(1,2).*U(7) + R(1,3).*U(8) + R(1,4).*U(9);
	rep_11 = R(3,1).*U(6) + R(3,2).*U(7) + R(3,3).*U(8) + R(3,4).*U(9);
	rep_12 = rep_11.*rep_2;
	rep_13 = rep_7.*U(10);
	rep_14 = rep_1.*rep_12;
	rep_15 = rep_5.*U(10);
	rep_16 = rep_10.*rep_5 - rep_12.*rep_7 + rep_13.*rep_6 + rep_15.*rep_8;
	rep_17 = S(2,1).*U(6) + S(2,2).*U(7) + S(2,3).*U(8) + S(2,4).*U(9) + (rep_1.*rep_16 + rep_14).*Xi(2,:) + (rep_1.^2.*rep_11 - rep_16.*rep_2).*Xi(1,:) + (-rep_10.*rep_7 - rep_12.*rep_5 - rep_13.*rep_8 + rep_5.*rep_6.*U(10)).*Xi(3,:);
	rep_18 = -rep_8;
	rep_19 = R(2,1).*U(1) + R(2,2).*U(2) + R(2,3).*U(3) + R(2,4).*U(4);
	rep_20 = -rep_19.*rep_5 - rep_4.*rep_7;
	rep_21 = R(2,1).*U(6) + R(2,2).*U(7) + R(2,3).*U(8) + R(2,4).*U(9);
	rep_22 = rep_1.*rep_11;
	rep_23 = -rep_13.*rep_19 - rep_21.*rep_5 - rep_22.*rep_7 + rep_4.*rep_5.*U(10);
	rep_24 = S(1,1).*U(6) + S(1,2).*U(7) + S(1,3).*U(8) + S(1,4).*U(9) + (-rep_14 - rep_2.*rep_23).*Xi(1,:) + (rep_1.*rep_23 - rep_11.*rep_2.^2).*Xi(2,:) + (-rep_13.*rep_4 - rep_15.*rep_19 + rep_21.*rep_7 - rep_22.*rep_5).*Xi(3,:);
	rep_25 = -rep_1.*rep_19 + rep_2.*rep_6;
	rep_26 = rep_1.*rep_6 + rep_19.*rep_2;
	rep_27 = rep_26.*rep_7;
	rep_28 = rep_27 - rep_5;
	rep_29 = rep_1.*rep_10 + rep_2.*rep_21;
	rep_30 = -rep_1.*rep_21 + rep_10.*rep_2;
	rep_31 = -rep_13 - rep_15.*rep_26 + rep_29.*rep_7;
	rep_32 = S(3,1).*U(6) + S(3,2).*U(7) + S(3,3).*U(8) + S(3,4).*U(9) + (rep_1.*rep_30 - rep_2.*rep_31).*Xi(1,:) + (rep_1.*rep_31 + rep_2.*rep_30).*Xi(2,:) + (-rep_15 + rep_27.*U(10) + rep_29.*rep_5).*Xi(3,:);
	%% create output vector
	out = [rep_17.*(rep_1.*rep_4 - rep_2.*rep_9) + rep_24.*(rep_1.*rep_18 - rep_2.*rep_20) + rep_32.*(rep_1.*rep_25 - rep_2.*rep_28);...
		 rep_17.*(rep_1.*rep_9 + rep_2.*rep_4) + rep_24.*(rep_1.*rep_20 + rep_18.*rep_2) + rep_32.*(rep_1.*rep_28 + rep_2.*rep_25);...
		 rep_17.*(-rep_5.*rep_8 - rep_6.*rep_7) + rep_24.*(rep_19.*rep_7 - rep_4.*rep_5) + rep_32.*(rep_26.*rep_5 + rep_7)];
end