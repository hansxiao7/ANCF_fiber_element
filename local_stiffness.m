function k = local_stiffness(section)

k = zeros(2,2);

for i = 1: section.n_conc
    k(1,1) = k(1,1) + section.conc_fiber(i).E * section.A_conc(i);
    k(1,2) = k(1,2) - section.conc_fiber(i).E * section.A_conc(i) * section.y_conc(i);
    k(2,1) = k(2,1) - section.conc_fiber(i).E * section.A_conc(i) * section.y_conc(i);
    k(2,2) = k(2,2) + section.conc_fiber(i).E * section.A_conc(i) * (section.y_conc(i) ^ 2);
end

for j = 1: section.n_steel
    k(1,1) = k(1,1) + section.steel_fiber(j).E * section.A_steel(j);
    k(1,2) = k(1,2) - section.steel_fiber(j).E * section.A_steel(j) * section.y_steel(j);
    k(2,1) = k(2,1) - section.steel_fiber(j).E * section.A_steel(j) * section.y_steel(j);
    k(2,2) = k(2,2) + section.steel_fiber(j).E * section.A_steel(j) * (section.y_steel(j) ^ 2);
end

end