classdef ROM_M4_FWT_RC < mbd.BaseRC
	properties
		DoFs = 5
		g = 9.81
		g_v = [0, 0, -1]
		M = [0, 0, 0, 0]
		K = [0, 0, 0, 0]
		S = [[0, 0, 0, 0];[0, 0, 0, 0];[0, 0, 0, 0]]
		R = [[0, 0, 0, 0];[0, 0, 0, 0];[0, 0, 0, 0]]
		X_h = [0, 1, 0]
		k_h = 0
		d_h = 0
		Lambda = 0.3
		m_f = 0
		I_f = [0, 0, 0]
		X_f = [1, 1, 0]
	end
end