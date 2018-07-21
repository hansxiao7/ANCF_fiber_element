%this code is to test the concrete model%
addpath syms;
fc = -5.2;
strain_0 = -0.002;
strain_u = -0.005;
Z = 400;
x = [];
y = [];
E = [];

concrete.strain_history = [0,0];
concrete.stress_history = [0,0];
concrete.strain_r = 0;
concrete.strain_p = 0;

for i = 1:30
    concrete = concrete01( i * -0.0001, concrete.strain_history, concrete.stress_history,...
        fc, strain_0, Z, strain_u, concrete.strain_r, concrete.strain_p);
    x = [x; i*-0.0001];
    y = [y; concrete.stress];
    E = [E; concrete.E];
end

for j = 1:40
    concrete = concrete01( -0.003+ j * 0.0001, concrete.strain_history, concrete.stress_history,...
        fc, strain_0, Z, strain_u, concrete.strain_r, concrete.strain_p);
    x = [x; -0.003+ j * 0.0001];
    y = [y; concrete.stress];
    E = [E; concrete.E];
end

for k = 1:50
        concrete = concrete01( 0.001- k * 0.0001, concrete.strain_history, concrete.stress_history,...
        fc, strain_0, Z, strain_u, concrete.strain_r, concrete.strain_p);
    x = [x; 0.001- k * 0.0001];
    y = [y; concrete.stress];
    E = [E; concrete.E];
end

for m = 1:40
    concrete = concrete01( -0.004+m*0.0001, concrete.strain_history, concrete.stress_history,...
        fc, strain_0, Z, strain_u, concrete.strain_r, concrete.strain_p);
    x = [x;  -0.004+m*0.0001];
    y = [y; concrete.stress];
    E = [E; concrete.E];
end
