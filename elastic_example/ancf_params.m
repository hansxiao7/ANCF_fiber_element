function p = ancf_params()
%ANCF_PARAMS Problem specification, define the sections

L = 2;   % noodle length
ne = 100;    % number of beam elements
p.ne = ne;         % number of ANCF elements per noodle
for i = 1:p.ne
    p.x(i) = L/p.ne;   % noodle length
end


p.n = 4*(p.ne+1);  % number of nodal coordinates
p.E = 2.07e11;         % elasticity modulus
p.A = 0.1*0.1;    % cross-section area
p.I = 0.1*0.1^3/12; % second moment of area
p.rho = 7200;      % density

p.F = 3*p.E*p.I/L^2/4;

% specify constraints at the noodle ends
%the element in vector represent which dof is constrained, from 1 to 4
p.ml = [1,2,4]; %left end
p.mr = [];%right end
end