x = [];
y = [];

for i = 1:params.ne
    istart = 4*i -3;
    iend = 4*i+4;
    eele = e(istart:iend, 1);
    L = params.x(i);
    for j = 1:2001
        x = [x; (j-1)*L/2000 + (i-1)*L];
        S = shape_fun((j-1)*L/2000, L, 0);
        S = [S(1)*eye(2), S(2)*eye(2), S(3)*eye(2), S(4)*eye(2)];
        xx = S*eele;
        y = [y;xx(2)];
    end
end
    