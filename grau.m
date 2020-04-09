% Verifica o graus da degenera��o e ver qual classes
% Data: 11/06/2015
% Autor: Nielsen Castelo Damasceno
% Entrada: Centros
% Sa�da: os cluster que s�o NaN; e gr � o grau
function [cluster,gr] = grau(centros)
    [x,~] = size(centros);

    cluster = zeros(1);
    cont = 1;
    for i = 1 : x
        if isnan(centros(i,:))
            cluster(cont) = i;
            cont = cont + 1;
        end
    end
    
    gr = length(cluster);
    if cluster == 0 % Garante que n�o tem cluster
        gr = 0;
    end
end