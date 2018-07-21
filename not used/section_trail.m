clc
clear
%This file is to define the section%
section1.n_conc = 10; %number of concrete fibers
section1.n_steel = 2;
section1.y_conc = [11.7; 9.1; 6.5; 3.9; 1.3; -1.3; -3.9; -6.5; -9.1; -11.7];
section1.y_steel = [10; -10];

section1.A_conc = [34*2.6; 34*2.6; 34*2.6; 34*2.6; 34*2.6; 34*2.6; 34*2.6; 34*2.6; 34*2.6; 34*2.6];
section1.A_steel = [3.14; 3.14];

%fiber concrete properties
fc = -5.2;
strain_0 = -0.002;
strain_u = -0.005;
Z = 400;

%fiber reinf properties-- built in steel01 model


%define the fibers
%concrete
for i = 1:section1.n_conc
    section1.conc_fiber(i).fc = fc;
    section1.conc_fiber(i).strain_0 = strain_0;
    section1.conc_fiber(i).strain_u = strain_u;
    section1.conc_fiber(i).Z = Z;
    section1.conc_fiber(i).strain_history = [0,0];
    section1.conc_fiber(i).stress_history = [0,0];
    section1.conc_fiber(i).strain_r = 0;
    section1.conc_fiber(i).strain_p = 0;
end

%reinf
for j = 1:section1.n_steel
    section1.steel_fiber(j).strain_history = [0,0];
    section1.steel_fiber(j).stress_history = [0,0];
    %the sign of the following parameters should be decided at first
    %analysis
    %section.steel_fiber(i).strain_r = -69/29000;
    %section.steel_fiber(i).max_strain_r = -69/29000;
    %section.steel_fiber(i).min_strain_r = -69/29000;
    %section.steel_fiber(i).stress_r = -69;
    %section.steel_fiber(i).strain_0 = 69/29000;
    %section.steel_fiber(i).stress_0 = 69;
    section1.steel_fiber(j).ita = 0;
end

MM =[];
NN =[];
X = [];
for k = 1:200
    [M, N, section1]=section_analysis(section1, k*1e-6, 0);
    MM=[MM;M];
    NN=[NN;N];
    X = [X; k*1e-6];
end

for m = 1:400
    [M, N, section1] = section_analysis(section1, 0.0002 - m*1e-6, 0);
    MM = [MM;M];
    NN = [NN;N];
    X = [X;0.0002 - m*1e-6];
end

for n = 1:500
    [M, N, section1] = section_analysis(section1, -0.0002 + n*1e-6, 0);
    MM = [MM;M];
    NN = [NN;N];
    X = [X;-0.0002+n*1e-6];
end

for o = 1:600
    [M, N, section1] = section_analysis(section1, 0.0003 - o*1e-6, 0);
    MM = [MM;M];
    NN = [NN;N];
    X = [X; 0.0003 - o*1e-6];
end

for p = 1:700
    [M, N, section1] = section_analysis(section1, -0.0003 + p*1e-6, 0);
    MM = [MM;M];
    NN = [NN;N];
    X = [X; -0.0003 + p*1e-6];
end
result = [X, MM];