function [K_total,w_max] = elastic_k(params)
%x is a vector, represent the length of element in each section
x= params.x;
rho = params.rho;
E = params.Ec;
I = params.I;
A = params.A;
[x3, w3] = gauss_points(3);
[x2, w2] = gauss_points(2);
for i = 1:max(size(x))
    L = x(i);
    M = rho* A * L * mass(L);
    kfe = zeros(8,8);
    for j = 1:2
        xx = (1+x2(j))*L/2;
        Sxx = shape_fun(xx, L, 2);
        Sxx = [Sxx(1)*eye(2), Sxx(2)*eye(2), Sxx(3)*eye(2), Sxx(4)*eye(2)];
        kfe = kfe + w2(j)* (Sxx')* Sxx * L /2;
    end
    kfe = E * I * kfe;
    
    kle = zeros(8,8);
    for k = 1:3
        xxx= (1+x3(k))*L/2;
        Sx = shape_fun(xxx, L, 1);
        Sx = [Sx(1)*eye(2), Sx(2)*eye(2), Sx(3)*eye(2), Sx(4)*eye(2)];
        kle = kle + w3(k)* (Sx')* Sx* L /2;
    end
    strain_u = 0.21;
    kle = E * A * strain_u * kle;
    
    K(:,:,i) = kfe;
    K_total((4*i-3):(4*i+4),(4*i-3):(4*i+4)) = kfe;
    w_max(i) = sqrt(max(eig((M)\K(:,:,i))));
end
end