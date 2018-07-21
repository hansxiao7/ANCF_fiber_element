clc
clear
%this code is for implicit static analysis with ANCF
params = ancf_params();
element_sections = ancf_sections(params);

[e, ~] = init_cond(params);

% external force
rho_g = 84e-6;
rho_g = rho_g + 80.88e-6;
Qe = gravity_force(params, rho_g);

for j = 1:10000
    [~, Qint, new_element_sections] = internal_forces(e, params, element_sections);
    k = global_stiffness(e, params, element_sections);
    k11 = k(3,3);
    k12 = k(3,5:params.n-4);
    k13 = k(3,params.n-1);
    k21 = k(5:params.n-4,3);
    k22 = k(5:params.n-4,5:params.n-4);
    k23 = k(5:params.n-4,params.n-1);
    k31 = k(params.n-1,3);
    k32 = k(params.n-1,5:params.n-4);
    k33 = k(params.n-1,params.n-1);
    K = [k11,k12,k13;k21,k22,k23;k31,k32,k33];
    delta_e = inv(K)*([Qe(3);Qe(5:params.n-4);Qe(params.n-1)]-[Qint(3);Qint(5:params.n-4);Qint(params.n-1)]);
    e = e + [zeros(2,1);delta_e(1);0;delta_e(2:max(size(delta_e))-1);zeros(2,1);delta_e(max(size(delta_e)));0];
end
    