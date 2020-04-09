% Método 1: Gera um ponto aleatório no conjunto de dados.
% Data: 11/06/2015
% Autor: Nielsen Castelo Damasceno
% Entrada: x são as amostras, centros, a posição dos cluster, e o grau
% Saída: Novos centros
function centros = randomico(x,centros,cluster,gr)
    low = 1;
    high = size(x,1);
    % Estabelecendo os centros aleatórios
    for var = 1 : gr
        indice = round(low + (high - low)*rand);
        centros(cluster(var),:) = x(indice,:);
    end
end