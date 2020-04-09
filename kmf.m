% The k-means algorithm with iterative Last Improving to remove the degeneracy
% Autor: Nielsen Castelo Damasceno
% Data: 25/06/2015
% Input:  x - samplers
%         k - number centers
%         centros - generating centers degeneration  
%         epsilon - value of epsilon
%         metodo - Type Method
%         dist_matrix - distance matrix
% Output:    
%         classe - position vector where the elements were found
%         centros- matrix centers
%         it - number of iteration

function [classe,centros,it,rein] = kmf(x,k,centros,epsilon,metodo,dist_matrix)

    [n,d] = size(x);
    rein = 0;
    
    classe = zeros(n,1);

    var_cond = 1;
    flag = true;
    while flag
        flag = false;
        W = 1;
        while W
            %Computing the Euclidean distance between the centroids and the data
            dist = zeros(n,k);
            for var = 1:n
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

            for p = 1:n
                [di,c] = min(dist(p,:));
                classe(p) = c;
            end

            nov_classe = classe;
            
            % Calculating new centroids
            cluster_length = zeros(k,1);
            for c = 1:k
                y = x(classe == c,:);
                cluster_length(c) = size(y,1);
                if cluster_length(c) > 1
                    centros(c,:) = sum(y)/cluster_length(c);
                elseif cluster_length(c) == 1
                    centros(c,:) = y;
                end
            end

            if ant_classe == nov_classe
                W = 0;
            end

       
            var_cond = var_cond + 1;
            %fprintf('it: %d\n', var_cond);

        end
        % Finalizando
        
        classe = nov_classe;
        it = var_cond;
        
        cluster_length = zeros(k,1);
        for c = 1:k
            y = x(classe == c,:);
            cluster_length(c) = size(y,1);
            if cluster_length(c) ~= 1
                centros(c,:) = sum(y)/cluster_length(c);
            else
                centros(c,:) = y;
            end
        end
        
        % Checks for cluster Degenerative
        [cluster,gr] = grau(centros);
        
        if gr ~= 0
            ponto_mais_distante = zeros(k,d);
            dist_do_ponto_mais_distante = zeros(k,1) -1;
            cluster_cost = zeros(k,1);
            for p = 1:n
                c = classe(p);
                di = sqrt(sum((x(p,:)-centros(c,:)).^2));
                cluster_cost(c) = cluster_cost(c) + di;
                if di >= dist_do_ponto_mais_distante(c)
                    dist_do_ponto_mais_distante(c) = di;
                    ponto_mais_distante(c,:) = x(p,:);
                end
            end
        end
        
        if  gr ~= 0 % Number of centers was degenerated
            flag = true;
            rein = rein + 1;    
            switch metodo
                case 1     % Randon
                    centros = randomico(x,centros,cluster,gr);
                case 2     % Greedy
                    centros = centro_cluster(x,classe,k,centros,cluster,gr,ponto_mais_distante,dist_do_ponto_mais_distante,cluster_length);  
                case 3     % e-Ramdon
                    centros = randomico_epsilon(x,classe,k,centros,cluster,epsilon,gr,cluster_length);
                case 4     % e-Greedy
                    centros = epsilon_greedy(x,classe,k,centros,cluster,epsilon,gr,cluster_cost,ponto_mais_distante,cluster_length);                 
                case 5     % Mixed
                    centros = mixed(x,classe,k,centros,cluster,epsilon,gr,cluster_cost,cluster_length);
                case 6     % DB
                    centros = DB(x,classe,k,centros,cluster,gr,dist_matrix,cluster_cost,cluster_length);
            end
        end
    end
end