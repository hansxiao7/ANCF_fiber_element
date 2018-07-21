function [x,w] = lobatto_points(N)
%LOBATTO_POINTS Nodes and weights for Lobatto quadrature integration in [-1,1]
% [x,w] = LOBATTO_POINTS(N) returns the nodes x (in [-1,1]) and weigths w to
% evaluate the integrals using Lobatto quadrature of order N.
% 
% Then, for a continuous function f, its integral over [-1,1] can be
% calculated as sum(F.*w), where F(i) = f(x(i)).

switch N
    case 3
        x = [-1; 0; 1];
        w = [1/3; 4/3; 1/3];
    case 4
        x = [-1; -sqrt(5)/5; sqrt(5)/5; 1];
        w = [1/6; 5/6; 5/6; 1/6];
    case 6
        x = [sqrt((7-2*sqrt(7))/21); -sqrt((7-2*sqrt(7))/21);
            sqrt((7+2*sqrt(7))/21); -sqrt((7+2*sqrt(7))/21);
            1; -1];
        w = [(14+sqrt(7))/30; (14+sqrt(7))/30;
            (14-sqrt(7))/30; (14-sqrt(7))/30;
            1/15; 1/15];
end