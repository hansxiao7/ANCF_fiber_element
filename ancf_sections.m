function element_sections = ancf_sections(params)
%this function is to define the element sections. Each element has same
%section properties, and have 5 sections (Gauss points) for analysis

%n_sec = params.ne * 5;
for m = 1:params.ne
    for i = 1:5
        element_sections(m).section(i).n_conc_core = 10; %number of concrete fibers
        element_sections(m).section(i).n_conc_cover = 12;
        element_sections(m).section(i).n_conc = element_sections(m).section(i).n_conc_core + element_sections(m).section(i).n_conc_cover;
        element_sections(m).section(i).n_steel = 2;
        element_sections(m).section(i).y_conc_core = [9; 7; 5; 3; 1; -1; -3; -5; -7; -9];
        element_sections(m).section(i).y_conc_cover = [11.5; 9; 7; 5; 3; 1; -1; -3; -5; -7; -9; -11.5];
        element_sections(m).section(i).y_conc = [element_sections(m).section(i).y_conc_core; element_sections(m).section(i).y_conc_cover];
        element_sections(m).section(i).y_steel = [10; -10];

        element_sections(m).section(i).A_conc_core = [28*2; 28*2; 28*2; 28*2; 28*2; 28*2; 28*2; 28*2; 28*2; 28*2];
        element_sections(m).section(i).A_conc_cover = [34*3; 6*2; 6*2; 6*2;6*2;6*2;6*2;6*2;6*2;6*2;6*2;34*3];
        element_sections(m).section(i).A_conc = [element_sections(m).section(i).A_conc_core; element_sections(m).section(i).A_conc_cover];
        element_sections(m).section(i).A_steel = [3.14; 3.14];

        %fiber concrete properties
        fc_cover = -5.2;
        strain_0_cover = -0.002;
        strain_u_cover = -0.018;
        Z_cover = 420;
        
        fc_core = -5.6;
        strain_0_core = -0.0022;
        strain_u_core = -0.018;
        Z_core = 53.485;

        %fiber reinf properties-- built in steel01 model


        %define the fibers
        %concrete
        for j = 1:element_sections(m).section(i).n_conc
            if j <= element_sections(m).section(i).n_conc_core
                element_sections(m).section(i).conc_fiber(j).fc = fc_core;
                element_sections(m).section(i).conc_fiber(j).strain_0 = strain_0_core;
                element_sections(m).section(i).conc_fiber(j).strain_u = strain_u_core;
                element_sections(m).section(i).conc_fiber(j).Z = Z_core;
            else
                element_sections(m).section(i).conc_fiber(j).fc = fc_cover;
                element_sections(m).section(i).conc_fiber(j).strain_0 = strain_0_cover;
                element_sections(m).section(i).conc_fiber(j).strain_u = strain_u_cover;
                element_sections(m).section(i).conc_fiber(j).Z = Z_cover;
            end
            element_sections(m).section(i).conc_fiber(j).strain_history = [0,0];
            element_sections(m).section(i).conc_fiber(j).stress_history = [0,0];
            element_sections(m).section(i).conc_fiber(j).strain_r = 0;
            element_sections(m).section(i).conc_fiber(j).strain_p = 0;
            section(m).conc_fiber(j).E = 0;
        end

        %reinf
        for k = 1:element_sections(m).section(i).n_steel
            element_sections(m).section(i).steel_fiber(k).strain_history = [0,0];
            element_sections(m).section(i).steel_fiber(k).stress_history = [0,0];
            element_sections(m).section(i).steel_fiber(k).ita = 0;
            section(m).steel_fiber(k).E = 0;
        end


    end
    for i = 1:5
        [~, ~, element_sections(m).section(i)] = section_analysis(element_sections(m).section(i), 0, 0);
    end
end
end