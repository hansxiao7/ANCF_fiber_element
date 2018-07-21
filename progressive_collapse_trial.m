clc
clear
%this code is for dynamic progressive collapse analysis after the
%quasi-static analysis
tend = 0.5;

params = ancf_params();
strain_u = 0.21;
[~,w_max] = elastic_k(params);
delta_t = 2/max(abs(w_max)) * 0.8;

nout = floor(tend/delta_t) + 1;
data.t = zeros(1, nout);
data.e = zeros(params.n, nout);

% Initial conditions (t=0)
e = load('C:\Users\hxiao\Desktop\validation_opensees\ANCF transitions\ANCF_gravity_e');
e = e.ans;
element_sections = load('C:\Users\hxiao\Desktop\validation_opensees\ANCF transitions\ANCF_static_sections');
element_sections = element_sections.new_sections;

% Store data at t0
data.t(1) = 0;
data.e(:,1) = e;

% Mass matrix (constant)
M = mass_matrix(params);
M(params.n-2, params.n-2) = M(params.n-2, params.n-2) + 0.0128;
Minv = M^(-1);

% external force
rho_g = 84e-6;
rho_g = rho_g + 80.88e-6;
Qe = gravity_force(params, rho_g);
Qe(params.n-2,1) = Qe(params.n-2,1) -4.95;

old_e = e;

% Loop over all output times.
hw = waitbar(0,'Initializing waitbar...');

old_sections = element_sections;
NNN = [];
for i = 1:nout-1
    [NN, Qs, new_sections] = internal_forces(e, params, old_sections);
    NNN = [NNN;NN];
    temp = e;
    e = delta_t^2 * Minv * (Qe - Qs) - old_e + 2*e;
    old_e = temp;
    
    temp2 = old_sections;
    old_sections = new_sections;
    
    data.e(:,i+1) = e;
    data.t(i+1) = data.t(i) + delta_t;
    t_str = sprintf('t = %.4f', i*delta_t);
    waitbar(i/(nout-1),hw,t_str);
end
close(hw);