% Função que faz a mesma ação da função find do Matlab
% Encontra o elemento no vetor e retorna sua posição
% Data: 15/12/2013
% Autor: Nielsen C. Damasceno
% Entrada:  ca - é o vetor de pesquisa
%           it - é o valor que deseja encontrar no vetor
% Saída:    
%           out - vetor posição onde os elementos foram encontrados
function out = encontrar(ca,it)
    
    out = zeros(1,1);
    ele = 1;
    for j = 1 : length(ca)
        if (ca(j) == it)
            out(ele) = j;
            ele = ele + 1;
        end
    end
end