function Q = gravity_force(params, rho_g)
    Q = zeros(params.n, 1);
    [x5, w5] = gauss_points(5);
    
    for i = 1:params.ne
        L = params.x(i);
        for j = 1:5
            x = (x5(j) + 1)*L/2;
            w = w5(j);
            S = shape_fun(x, L, 0);
            S = [S(1)*eye(2), S(2)*eye(2), S(3)*eye(2), S(4)*eye(2)];
            Q(4*i - 3: 4*i+4, 1) = Q(4*i - 3: 4*i+4, 1) + w*L/2* S' * [0; -rho_g *params.A];
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