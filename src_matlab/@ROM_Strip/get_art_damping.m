function [out] = get_art_damping(p,U,t)
%GET_ART_DAMPING Summary of this function goes here
out = - U(p.DoFs+1:p.DoFs*2) .* p.artifical_damping;
out = out(:);
end

