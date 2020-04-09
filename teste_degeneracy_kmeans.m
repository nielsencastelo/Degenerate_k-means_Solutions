% Shows the k-means presenting degeneration data
% Data: 07/08/2015
% Autor: Nielsen C. Damasceno

clear; clc; close all;

epsilon = 1e-6;  metodo = 1;

load('Nova com 20\sintetico_k4_kpp.mat');

high = size(x,1);
classe = zeros(high,1);

    var_cond = 0;
    W = 1;
    while W
        % Calculando distância euclidiana entre os centroides e os dados
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
     
        % Guardando classes
        ant_classe = classe;
    
        % Atribuindo as classes para os valores
        for var = 1:high
            [~,indice] = min(dist(var,:));
            classe(var) = indice;
        end
    
        % Mostra resultados visuais iniciais
        %colors = rand(k,3);
        colors = [
            0.6596    0.8003    0.0835
            0.8147    0.1576    0.6557
            0.9730    0.4324    0.1734
            0.2490    0.2253    0.3909];
%             0.2785    0.4218    0.7431];
%         colors = [
%         0.8147    0.1576    0.6557
%         0.9058    0.9706    0.0357
%         0.1270    0.9572    0.8491
%         0.0975    0.1419    0.7577
%         0.6324    0.8003    0.6787
%         0.0975    0.1419    0.7577
%         0.2785    0.4218    0.7431
%         0.5469    0.9157    0.3922
%         0.9575    0.7922    0.6555
%         0.9649    0.9595    0.1712];
%         disp(centros);
        clf;
        plota(x,classe,colors); axis equal;
        pause(0.5);
        plotaCentroide(centros,'r');
        pause(0.5);
        plota_linhas(x,classe,centros,'k--');
        teclar();
        
        
        % Guardando classes
        nov_classe = classe;
        
        % Calculando novos centroides        
        for c = 1:k
            y = x(classe == c,:);
            if size(y,1) > 1
                centros(c,:) = sum(y)/size(y,1);
            elseif size(y,1) == 1
                centros(c,:) = y;
            end
        end
          
        %disp(centros);
        
        % Variavel de laço
        if ant_classe == nov_classe
            W = 0;
        end
    
       
        % Laço
        var_cond = var_cond + 1;
        fprintf('it: %d\n', var_cond);
       
        clf;
        plota(x,classe,colors);axis equal;
        pause(0.5);
        plotaCentroide(centros,'r');
        plota_linhas(x,classe,centros,'k--');
        pause(0.5);
        teclar();
        
        %mssckm = MSSCKM(x,classe,centros,k);
        %fprintf('MSSC KM: %2.4f\n', mssckm);
    end

    % Finalizando
    classe = nov_classe;
    it = var_cond;
    % Mostra resultados visuais
%     figure(2);
%     colors = rand(k,3);
%     colors = [
%             0.6596    0.8003    0.0835
%             0.5186    0.4538    0.1332
%             0.9730    0.4324    0.1734
%             0.2490    0.2253    0.3909];
%     
%     clf;
%     plota(x,classe,colors);
%     plotaCentroide(centros);
   
