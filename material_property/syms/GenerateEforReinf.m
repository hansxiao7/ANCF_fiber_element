% Script to generate code for the evaluation of E for reinforcement with
% Menegotto Pinto model

syms b R;
syms strain_0 strain_r;
syms stress_r stress_0;
syms strain stress;

strain_star = (strain - strain_r)/(strain_0 - strain_r);
fx = (b* strain_star + (1-b)*strain_star/(1+strain_star^R)^(1/R)) * (stress_0 - stress_r) + stress_r;
E = simplify(diff(fx, strain));

matlabFunction(E, 'file', 'TangentModulusReinf.m');