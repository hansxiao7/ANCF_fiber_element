function p = ancf_params()
%ANCF_PARAMS Problem specification, define the sections

L = 206;%total beam length;
p.ne = 1;% number of beam elements
for i = 1:p.ne
    p.x(i) = L/p.ne;   % noodle length
end

p.n = 4*(p.ne+1);  % number of nodal coordinates
p.A = 34 * 26;    % cross-section area
p.rho = 2.17e-7;      % density k/in^3
p.Ec = 57*sqrt(5200);
p.I = 34*26^3/12;


% specify constraints at the noodle ends
%the element in vector represent which dof is constrained, from 1 to 4
p.ml = [1,2,4]; %left end
p.mr = [1,2,4];%right end
end