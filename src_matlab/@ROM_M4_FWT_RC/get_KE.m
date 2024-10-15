function out = get_KE(p,U)
	%GET_KE Auto-generated function from moyra
	%
	%	Created at : Tue Oct 15 11:55:06 2024 
	%	Created with : moyra https://pypi.org/project/moyra/
	%
	%% extract required parameters from structure
	M = p.M;
	S = p.S;
	Lambda = p.Lambda;
	X_f = p.X_f;
	m_f = p.m_f;
	R = p.R;
	I_f = p.I_f;
	%% create common groups
	rep_1 = S(1,1).*U(6);
	rep_2 = S(1,2).*U(7);
	rep_3 = S(1,3).*U(8);
	rep_4 = S(1,4).*U(9);
	rep_5 = cos(U(5));
	rep_6 = R(2,1).*U(6) + R(2,2).*U(7) + R(2,3).*U(8) + R(2,4).*U(9);
	rep_7 = sin(U(5));
	rep_8 = R(2,1).*U(1) + R(2,2).*U(2) + R(2,3).*U(3) + R(2,4).*U(4);
	rep_9 = rep_7.*rep_8;
	rep_10 = cos(Lambda);
	rep_11 = R(3,1).*U(6) + R(3,2).*U(7) + R(3,3).*U(8) + R(3,4).*U(9);
	rep_12 = sin(Lambda);
	rep_13 = R(3,1).*U(1) + R(3,2).*U(2) + R(3,3).*U(3) + R(3,4).*U(4);
	rep_14 = rep_10.*rep_13 + rep_12;
	rep_15 = rep_5.*U(10);
	rep_16 = -rep_10.*rep_11.*rep_7 - rep_14.*rep_15 + rep_5.*rep_6 - rep_9.*U(10);
	rep_17 = X_f(3).*rep_16;
	rep_18 = rep_11.*rep_5;
	rep_19 = -rep_10.*rep_18 + rep_14.*rep_7.*U(10) - rep_15.*rep_8 - rep_6.*rep_7;
	rep_20 = rep_10.*rep_19 - rep_11.*rep_12.^2;
	rep_21 = X_f(2).*rep_20;
	rep_22 = rep_11.*rep_12;
	rep_23 = rep_10.*rep_22;
	rep_24 = -rep_12.*rep_19 - rep_23;
	rep_25 = X_f(1).*rep_24;
	rep_26 = S(2,1).*U(6);
	rep_27 = S(2,2).*U(7);
	rep_28 = S(2,3).*U(8);
	rep_29 = S(2,4).*U(9);
	rep_30 = R(1,1).*U(6) + R(1,2).*U(7) + R(1,3).*U(8) + R(1,4).*U(9);
	rep_31 = R(1,1).*U(1) + R(1,2).*U(2) + R(1,3).*U(3) + R(1,4).*U(4);
	rep_32 = -rep_10 + rep_12.*rep_13;
	rep_33 = rep_32.*rep_5;
	rep_34 = -rep_22.*rep_7 - rep_30.*rep_5 + rep_31.*rep_7.*U(10) - rep_33.*U(10);
	rep_35 = X_f(3).*rep_34;
	rep_36 = rep_32.*rep_7;
	rep_37 = -rep_12.*rep_18 + rep_15.*rep_31 + rep_30.*rep_7 + rep_36.*U(10);
	rep_38 = rep_10.*rep_37 + rep_23;
	rep_39 = X_f(2).*rep_38;
	rep_40 = rep_10.^2.*rep_11 - rep_12.*rep_37;
	rep_41 = X_f(1).*rep_40;
	rep_42 = S(3,1).*U(6);
	rep_43 = S(3,2).*U(7);
	rep_44 = S(3,3).*U(8);
	rep_45 = S(3,4).*U(9);
	rep_46 = rep_10.*rep_30 + rep_12.*rep_6;
	rep_47 = rep_10.*rep_31 + rep_12.*rep_8;
	rep_48 = rep_47.*rep_5;
	rep_49 = rep_46.*rep_7 + rep_48.*U(10) - rep_7.*U(10);
	rep_50 = X_f(3).*rep_49;
	rep_51 = -rep_10.*rep_6 + rep_12.*rep_30;
	rep_52 = rep_47.*rep_7;
	rep_53 = -rep_15 + rep_46.*rep_5 - rep_52.*U(10);
	rep_54 = rep_10.*rep_53 + rep_12.*rep_51;
	rep_55 = X_f(2).*rep_54;
	rep_56 = rep_10.*rep_51 - rep_12.*rep_53;
	rep_57 = X_f(1).*rep_56;
	rep_58 = rep_20.*(-rep_14.*rep_7 + rep_5.*rep_8);
	rep_59 = rep_38.*(-rep_31.*rep_5 - rep_36);
	rep_60 = rep_54.*(rep_5 + rep_52);
	rep_61 = -rep_32;
	rep_62 = -rep_14.*rep_5 - rep_9;
	rep_63 = rep_16.*(rep_10.*rep_61 - rep_12.*rep_62);
	rep_64 = rep_31.*rep_7 - rep_33;
	rep_65 = rep_34.*(rep_10.*rep_14 - rep_12.*rep_64);
	rep_66 = -rep_10.*rep_8 + rep_12.*rep_31;
	rep_67 = rep_48 - rep_7;
	rep_68 = rep_49.*(rep_10.*rep_66 - rep_12.*rep_67);
	rep_69 = rep_40.*(rep_10.*rep_64 + rep_12.*rep_14);
	rep_70 = rep_24.*(rep_10.*rep_62 + rep_12.*rep_61);
	rep_71 = rep_56.*(rep_10.*rep_67 + rep_12.*rep_66);
	%% create output vector
	out = m_f.*(rep_1/2 + rep_17/2 + rep_2/2 + rep_21/2 + rep_25/2 + rep_3/2 + rep_4/2).*(rep_1 + rep_17 + rep_2 + rep_21 + rep_25 + rep_3 + rep_4) + m_f.*(rep_26/2 + rep_27/2 + rep_28/2 + rep_29/2 + rep_35/2 + rep_39/2 + rep_41/2).*(rep_26 + rep_27 + rep_28 + rep_29 + rep_35 + rep_39 + rep_41) + m_f.*(rep_42/2 + rep_43/2 + rep_44/2 + rep_45/2 + rep_50/2 + rep_55/2 + rep_57/2).*(rep_42 + rep_43 + rep_44 + rep_45 + rep_50 + rep_55 + rep_57) + I_f(1).*(rep_58/2 + rep_59/2 + rep_60/2).*(rep_58 + rep_59 + rep_60) + I_f(2).*(rep_63/2 + rep_65/2 + rep_68/2).*(rep_63 + rep_65 + rep_68) + I_f(3).*(rep_69/2 + rep_70/2 + rep_71/2).*(rep_69 + rep_70 + rep_71) + M(1).*U(6).^2/2 + M(2).*U(7).^2/2 + M(3).*U(8).^2/2 + M(4).*U(9).^2/2;
end