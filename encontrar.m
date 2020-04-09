% Fun��o que faz a mesma a��o da fun��o find do Matlab
% Encontra o elemento no vetor e retorna sua posi��o
% Data: 15/12/2013
% Autor: Nielsen C. Damasceno
% Entrada:  ca - � o vetor de pesquisa
%           it - � o valor que deseja encontrar no vetor
% Sa�da:    
%           out - vetor posi��o onde os elementos foram encontrados
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