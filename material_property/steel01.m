%This function is to build the reinforcement hysteresis model by Menegotto
%and Pinto 
%addpath syms;
function steel = steel01(strain, strain_history, stress_history, ita,...
    strain_r, stress_r, strain_0, stress_0, max_strain_r, min_strain_r)
%parameters
a1 = 18.5;
a2 = 0.15;
a3 = 0;
a4 = 0;
R0 = 20;
E0 = 29000; %elastic modulus

%material property
fy = 69;
fu = 94;
strain_u = 0.21;
strain_y = fy / E0;
E = (fu-fy)/(strain_u - strain_y);%hardened modulus
b = E / E0; %hardening ratio

if strain_history(1) == 0 && strain_history(2) == 0  %initial loading
    flag = 1; %the flag for loading (1) or unloading (2)
    steel.stress_0 = stress_0;
    steel.strain_0 = strain_0;
    steel.stress_r = stress_r;
    steel.strain_r = strain_r;
    steel.max_strain_r = max_strain_r;
    steel.min_strain_r = min_strain_r;
    steel.ita = ita;
elseif (strain_history(2)-strain_history(1)) * (strain - strain_history(2)) < 0 %unloading
    flag = 2;
    steel.max_strain_r = max_strain_r;
    steel.min_strain_r = min_strain_r;
    steel.strain_r = strain_history(2);
    steel.stress_r = stress_history(2);
    if (strain - strain_history(2)) > 0 %interact with line a
        steel.strain_0 =(fy - E * strain_y + E0 * steel.strain_r - steel.stress_r)/(E0 - E);
        steel.ita = abs(steel.strain_0 - max_strain_r)/strain_y;
    else %interact with line b
        steel.strain_0 =(-fy + E * strain_y + E0 * steel.strain_r - steel.stress_r)/(E0 - E);
        steel.ita = abs(steel.strain_0 - min_strain_r)/strain_y;
    end
    steel.stress_0 = E0 * steel.strain_0 + steel.stress_r - E0 * steel.strain_r;
    
    if steel.strain_r > steel.max_strain_r
        steel.max_strain_r = steel.strain_r;
    end 
    if steel.strain_r < steel.min_strain_r
        steel.min_strain_r = steel.strain_r;
    end
elseif strain_history(1) == strain_history(2) && strain < strain_history(2)
    flag = 2;
    steel.max_strain_r = max_strain_r;
    steel.min_strain_r = min_strain_r;
    steel.strain_r = strain_history(2);
    steel.stress_r = stress_history(2);
    if (strain - strain_history(2)) > 0 %interact with line a
        steel.strain_0 =(fy - E * strain_y + E0 * steel.strain_r - steel.stress_r)/(E0 - E);
        steel.ita = abs(steel.strain_0 - max_strain_r)/strain_y;
    else %interact with line b
        steel.strain_0 =(-fy + E * strain_y + E0 * steel.strain_r - steel.stress_r)/(E0 - E);
        steel.ita = abs(steel.strain_0 - min_strain_r)/strain_y;
    end
    steel.stress_0 = E0 * steel.strain_0 + steel.stress_r - E0 * steel.strain_r;
    
    if steel.strain_r > steel.max_strain_r
        steel.max_strain_r = steel.strain_r;
    end 
    if steel.strain_r < steel.min_strain_r
        steel.min_strain_r = steel.strain_r;
    end
else
    flag = 1; %loading
    steel.stress_0 = stress_0;
    steel.strain_0 = strain_0;
    steel.stress_r = stress_r;
    steel.strain_r = strain_r;
    steel.max_strain_r = max_strain_r;
    steel.min_strain_r = min_strain_r;
    steel.ita = ita;
end

R = R0 - a1*steel.ita/(a2+steel.ita);

strain_star = (strain - steel.strain_r)/(steel.strain_0 - steel.strain_r);
stress_star = b*strain_star + (1-b)*strain_star/(1+strain_star^R)^(1/R);

stress = stress_star * (steel.stress_0 - steel.stress_r) + steel.stress_r;
if isreal(stress_star) == 0
    ita
    b
    strain_star
    R
    error('aaa');
end

steel.stress = stress;

steel.strain_history = [strain_history(2), strain];
steel.stress_history = [stress_history(2), stress];
steel.R = R;
steel.E = TangentModulusReinf(steel.R,b,strain,steel.strain_0,steel.stress_0,steel.strain_r,steel.stress_r);

end