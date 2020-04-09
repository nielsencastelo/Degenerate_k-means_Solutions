% k-means Algorithm
% Autor: Nielsen Castelo Damasceno
% Based on the original article de J. MacQueen. Some methods for classification and analysis of multivariate
% observations. In Proceedings of the Fifth Berkeley Symposium on Mathematics, Statistics and Probability, 
% Vol. 1, pages 281-296, 1968
% Input:  x - samplers
%         k - number centers
%         centros - generating centers degeneration           
% Output:    
%         classe - position vector where the elements were found
%         centros- matrix centers
%         it - number of iteration
%         maxdeg  - maximum number of degeneration
function [classe,centros,it,contadeg,maxdeg] = km(x,k,centros)
    maxdeg = 0;
    high = size(x,1);
    contadeg = 0;
    
    classe = zeros(high,1);
    
    var_cond = 1;
    W = 1;
    while W
        contadeg = 0;
        % Computing the Euclidean distance between the centroids and the data
        dist = zeros(high,k);
        for var = 1:high
            for c = 1:k
                soma = 0;
                for s = 1:size(x,2)
                    soma = soma + (x(var,s) - centros(c,s)).^2;
                end
                dist(var,c) = sqrt(soma);
            end
        end
     
        % saving classes
        ant_classe = classe;
    
        % Assigning classes
        for var = 1:high
            [~,indice] = min(dist(var,:));
            classe(var) = indice;
        end
    
              
        % saving classes
        nov_classe = classe;
        
        % Calculating new centroids
       for c = 1:k
            y = x(classe == c,:);
            if size(y,1) > 1
                centros(c,:) = sum(y)/size(y,1);
            elseif size(y,1) == 1
                centros(c,:) = y;
            elseif size(y,1) == 0
                contadeg = contadeg + 1;
            end
        end
        if contadeg > maxdeg
            maxdeg = contadeg;
        end
           
        
        % Variable loop
        if ant_classe == nov_classe
            W = 0;
        end
    
       
        var_cond = var_cond + 1;
        %fprintf('it: %d\n', var_cond);
       
    end

    % finalizing
    classe = nov_classe;
    it = var_cond;
    
    for c = 1:k
        y = x(classe == c,:);
        if size(y,1) ~= 1
            centros(c,:) = sum(y)/size(y,1);
        else
            centros(c,:) = y;
        end
    end

end