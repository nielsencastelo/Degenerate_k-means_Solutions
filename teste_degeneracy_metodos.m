% Data: 07/08/2015
% Autor: Nielsen C. Damasceno
% Shows the methods correcting degeneration

clear; clc; close all;

epsilon = 3;  
metodo = 6;   % set method

load('Nova com 20\sintetico_k4_kpp.mat');

dist_matrix = matriz_distancia(x);

high = size(x,1);
classe = zeros(high,1);

var_cond = 0;
W = 1;
while W
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

% Atribuindo as classes para os valores
for var = 1:high
    [~,indice] = min(dist(var,:));
    classe(var) = indice;
end

% Initial results show visual
%colors = rand(k,3);
colors = [
    0.6596    0.8003    0.0835
    0.8147    0.1576    0.6557
    0.9730    0.4324    0.1734
    0.2490    0.2253    0.3909];

clf;
plota(x,classe,colors);
pause(0.5);
plotaCentroide(centros,'b');
pause(0.5);
plota_linhas(x,classe,centros,'k--');
teclar();

nov_classe = classe;

% Calculating new centroids
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


% Variavel de laço
if ant_classe == nov_classe
    W = 0;
end

var_cond = var_cond + 1;
fprintf('it: %d\n', var_cond);

clf;
plota(x,classe,colors);
pause(0.5);
plotaCentroide(centros,'blue');
plota_linhas(x,classe,centros,'black');
pause(0.5);
teclar();

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

if  gr ~= 0 % Qtd de centros que foi degenerado
    W = 1;
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
mssckm = MSSCKM(x,classe,centros,k);
fprintf('MSSC KM: %2.4f\n', mssckm);

classe = nov_classe;
it = var_cond;