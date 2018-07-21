function [NN, Q, new_element_sections] = internal_forces(e, params, element_sections)
%INTERNAL_FORCES Calculate the beam internal force

%Calculate the axial strain and curvature at integration points, and calculate the
%moment and axial force at each section. Then transform the beam local
%force to internal force corresponding to nodal dof
Q = zeros(params.n, 1);
[x5, w5] = gauss_points(5);
for i = 1: params.ne
    e_ele = e(4*i - 3: 4*i+4,1);
    L = params.x(i);
    for j = 1:5
        x = (x5(j) + 1)*L/2;
        strain_x = axial_strain(e_ele, x, L);
        
        phi = curvature(e_ele, x, L);
        
        [M, N, new_element_sections(i).section(j)] = section_analysis(element_sections(i).section(j), phi, strain_x);
        if i == 1 && j == 1
            NN = N;
        end
        Q(4*i - 3: 4*i+4, 1) = Q(4*i - 3: 4*i+4, 1) + w5(j)*L /2*( N * delta_strain_x(e_ele, x, L) + M*delta_curvature(e_ele,x,L));
    end
end


ml = params.ml;
mr = params.mr;
if max(size(ml)) ~=0
    for j = 1: max(size(ml))
        Q(ml(j),1) = 0;
    end
end

if max(size(mr)) ~=0
    ir = params.n - 4;
    for k = 1:max(size(mr))
        Q(mr(k)+ir, 1) = 0;
    end
end 


end