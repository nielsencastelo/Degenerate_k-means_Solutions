% função que plota linhas
% Exemplo de chamada: plota_linhas(x,classe,centros,'k--');
function plota_linhas(x,classe,centros,cor)
    n = length(classe); % Pega a qtd de amostras
    figure(1);
    hold on;
           
    for i = 1 : n
        pos = classe(i);
        plot([x(i,1),centros(pos,1)], [x(i,2), centros(pos,2)],cor);
        pause(0.05);
    end
    
end