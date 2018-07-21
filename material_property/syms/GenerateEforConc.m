% Script to generate code for the evaluation of E concrete in backbone
syms fc Z strain_0;
syms strain;

assumeAlso(strain, 'real');
assumeAlso(strain_0, 'real');

stress = fc * (1- Z * (abs(strain) - abs(strain_0)));


E = simplify(diff(stress, strain));

matlabFunction(E, 'file', 'TangentModulusConcBackbone2.m')