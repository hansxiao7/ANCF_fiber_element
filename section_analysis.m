function [M, N, new_section] = section_analysis(section, phi, strain_x)
%counterclockwise is positive for curvature phi
conc_strain = strain_x - section.y_conc.*phi;
steel_strain = strain_x - section.y_steel.*phi;
%deicde the stress of each section
%concrete
for i=1:section.n_conc
    conc_fiber(i)= concrete01(conc_strain(i,1), section.conc_fiber(i).strain_history,...
        section.conc_fiber(i).stress_history,section.conc_fiber(i).fc, ...
        section.conc_fiber(i).strain_0, section.conc_fiber(i).Z,...
        section.conc_fiber(i).strain_u, section.conc_fiber(i).strain_r, section.conc_fiber(i).strain_p);
end

%reinforcement
fy =69;
Es = 29000;
for j = 1:section.n_steel
    %initialization
    if section.steel_fiber(j).strain_history(1) == 0 && section.steel_fiber(j).strain_history(2) == 0 && section.steel_fiber(j).stress_history(1) == 0 && section.steel_fiber(j).stress_history(2) == 0
        if steel_strain(j) >=0
            section.steel_fiber(j).strain_r = -fy/Es;
            section.steel_fiber(j).max_strain_r = fy/Es;
            section.steel_fiber(j).min_strain_r = -fy/Es;
            section.steel_fiber(j).stress_r = -fy;
            section.steel_fiber(j).strain_0 = fy/Es;
            section.steel_fiber(j).stress_0 = fy;
        else
            section.steel_fiber(j).strain_r = fy/Es;
            section.steel_fiber(j).max_strain_r = fy/Es;
            section.steel_fiber(j).min_strain_r = -fy/Es;
            section.steel_fiber(j).stress_r = fy;
            section.steel_fiber(j).strain_0 = -fy/Es;
            section.steel_fiber(j).stress_0 = -fy;
        end
    end
    
    steel_fiber(j) = steel01(steel_strain(j,1),section.steel_fiber(j).strain_history,...
        section.steel_fiber(j).stress_history, section.steel_fiber(j).ita,...
        section.steel_fiber(j).strain_r, section.steel_fiber(j).stress_r,...
        section.steel_fiber(j).strain_0, section.steel_fiber(j).stress_0,...
        section.steel_fiber(j).max_strain_r, section.steel_fiber(j).min_strain_r);
end

new_section = section;
new_section.conc_fiber = conc_fiber;
new_section.steel_fiber = steel_fiber;

%calculate M, N
N_conc = 0;
M_conc = 0;
N_steel = 0;
M_steel = 0;
for k = 1:section.n_conc
    N_conc = N_conc + conc_fiber(k).stress * section.A_conc(k);
    M_conc = M_conc - conc_fiber(k).stress * section.A_conc(k) * section.y_conc(k);
end

for m = 1:section.n_steel
    N_steel = N_steel + steel_fiber(m).stress * section.A_steel(m);
    M_steel = M_steel - steel_fiber(m).stress * section.A_steel(m) * section.y_steel(m);
end

M = M_conc + M_steel;
N = N_conc + N_steel;
%calculate the local stiffness matrix k11 k12 k21 k22

end