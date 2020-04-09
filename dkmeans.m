% Degeneracy k-means Algorithm
% Autor: Nielsen Castelo Damasceno
% Date: 01/05/2016
% Input:  x - samplers
%         k - number centers
%         method - Type of method used (1 Randon, 2 Greedy, 3 e-Ramdon, 
%                                       4 e-Greedy, 5 Mixed, 6 DB)
%         epsilon - value of epsilon
%         type - (1: strategy Firt improving. 2: strategy Last
%         improving)
% Output:    
%         classes - position vector where the elements were found
%         centros- matrix centers
%         it - number of iteration
%         mssc - value mssc
function [classes,centros,it,mssc] = dkmeans(x,k,method,epsilon,type)

    if nargin == 3
        epsilon = 1e-6; 
        type = kme;
    end
    if nargin == 2
        method = 2;
        type = 1;
        epsilon = 1e-6;
    end
    
    % initiating centers by the traditional method
    centros = init_centros(x,k); 
    
    %generating the distance matrix
    dist_matrix = matriz_distancia(x);
    
    if type == 1 % Run First Improving strategy
        [classes,centros,it,~] = kme(x,k,centros,epsilon,method,dist_matrix);
        mssc = MSSC(x,classes,centros,k);
    end
    if type == 2 % Run Last Improving strategy
        [classes,centros,it,~] = kmf(x,k,centros,epsilon,method,dist_matrix);
        mssc = MSSC(x,classes,centros,k);
    end
end