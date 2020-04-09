% M�todo 1: Gera um ponto aleat�rio no conjunto de dados.
% Data: 11/06/2015
% Autor: Nielsen Castelo Damasceno
% Entrada: x s�o as amostras, centros, a posi��o dos cluster, e o grau
% Sa�da: Novos centros
function centros = randomico(x,centros,cluster,gr)
    low = 1;
    high = size(x,1);
    % Estabelecendo os centros aleat�rios
    for var = 1 : gr
        indice = round(low + (high - low)*rand);
        centros(cluster(var),:) = x(indice,:);
    end
end