function k = global_stiffness(e, params, sections)

[x5,w5] = gauss_points(5);
k= zeros(params.n,params.n);

for i = 1:params.ne
    e_ele = e(4*i-3:4*i+4,1);
    L = params.x(i);
    A = zeros(2,8);
    for j = 1:5
        section = sections(i).section(j);
        k_local = local_stiffness(section);
        Sx = shape_fun(x5(j), L, 1);
        Sx = [Sx(1)*eye(2),Sx(2)*eye(2),Sx(3)*eye(2),Sx(4)*eye(2)];
        A1 = e_ele'*(Sx)'*Sx;
        A2 = delta_curvature(e_ele, x5(j), L);
        A = [A1;A2'];
        k(4*i-3:4*i+4,4*i-3:4*i+4) = k(4*i-3:4*i+4,4*i-3:4*i+4)+ w5(j)* A'*k_local*A * L /2;
    end
end