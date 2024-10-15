function out = get_hda(p,U)
	%GET_HDA Auto-generated function from moyra
	%
	%	Created at : Tue Oct 15 11:55:06 2024 
	%	Created with : moyra https://pypi.org/project/moyra/
	%
	%% extract required parameters from structure
	R = p.R;
	%% create common groups
	%% create output vector
	out = R(1,1).*U(1) + R(1,2).*U(2) + R(1,3).*U(3) + R(1,4).*U(4);
end