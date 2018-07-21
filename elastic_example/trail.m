clc
clear
params = ancf_params();

F = zeros(params.n, 1);
F(params.n-2, 1) = -params.F;

[e, ~] = init_cond(params);


for j = 1:10000
    j
    Qint = zeros(params.n, 1);
    QQ_gradient= zeros(params.n, params.n);

    for i = 1:params.ne
        L = params.x(i);
        istart = 4*i-3;
        iend = 4*i + 4;
        eele = e(istart:iend, 1);
        %q = Q(params.A, params.E, params.I, L, eele);
        q = Fint(eele, params.E, params.A, params.I, L);
        Qint(istart:iend, 1) = Qint(istart:iend,1) + q;
        QQ_gradient(istart:iend, istart:iend) = QQ_gradient(istart:iend, istart:iend) +  Q_gradient(params.A, params.E, params.I, L, eele);
    end

    Qint(1:2,1) = zeros(2,1);
    Qint(4,1) = 0;
%     
%     [U, S,V] = svd(QQ_gradient);
%     Sinv = zeros(8,8);
%     for k = 1:8
%         if abs(S(k, k)) > 10^-3
%             Sinv(k,k) = 1/S(k, k);
%         end
%     end
    k11 = QQ_gradient(3,3);
    k12 = QQ_gradient(3, 5:params.n);
    k21 = QQ_gradient(5:params.n, 3);
    k22 = QQ_gradient(5:params.n, 5:params.n);
    K = [k11, k12; k21, k22];
    Kinv = inv(K);
    
    
    
    delta_e = Kinv*([F(3);F(5:params.n)]-[Qint(3);Qint(5:params.n)]);
    e = e + [zeros(2,1);delta_e(1);0;delta_e(2:max(size(delta_e)))];
end
    

