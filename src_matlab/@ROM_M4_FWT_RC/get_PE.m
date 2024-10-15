function out = get_PE(p,U)
	%GET_PE Auto-generated function from moyra
	%
	%	Created at : Tue Oct 15 11:55:06 2024 
	%	Created with : moyra https://pypi.org/project/moyra/
	%
	%% extract required parameters from structure
	S = p.S;
	K = p.K;
	g_v = p.g_v;
	Lambda = p.Lambda;
	X_f = p.X_f;
	X_h = p.X_h;
	m_f = p.m_f;
	R = p.R;
	g = p.g;
	k_h = p.k_h;
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
	out = k_h.*U(5).^2/2 + m_f.*(-g.*g_v(1).*(S(1,1).*U(1) + S(1,2).*U(2) + S(1,3).*U(3) + S(1,4).*U(4) + X_f(1).*(-rep_10.*rep_4 + rep_5.*rep_9) + X_f(2).*(rep_10.*rep_5 + rep_4.*rep_9) + X_f(3).*(rep_1.*rep_2 - rep_3.*rep_7) + X_h(1)) - g.*g_v(2).*(S(2,1).*U(1) + S(2,2).*U(2) + S(2,3).*U(3) + S(2,4).*U(4) + X_f(1).*(-rep_12.*rep_4 + rep_5.*rep_7) + X_f(2).*(rep_12.*rep_5 + rep_4.*rep_7) + X_f(3).*(-rep_1.*rep_11 - rep_3.*rep_8) + X_h(2)) - g.*g_v(3).*(S(3,1).*U(1) + S(3,2).*U(2) + S(3,3).*U(3) + S(3,4).*U(4) + X_f(1).*(rep_14.*rep_5 - rep_15.*rep_4) + X_f(2).*(rep_14.*rep_4 + rep_15.*rep_5) + X_f(3).*(rep_1 + rep_13.*rep_3) + X_h(3))) + K(1).*U(1).^2/2 + K(2).*U(2).^2/2 + K(3).*U(3).^2/2 + K(4).*U(4).^2/2;
end