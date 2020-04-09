% Fun��o que calcula a melhoria do algoritmo baseado no MSSC
% Minimizar o MSSC
% Data: 12/06/2015
% Autor: Nielsen Castelo Damasceno
% mssc1 � o maior valor
% mssc2 � o menor valor
function best = improvement(mssc1,mssc2)
    diferenca = mssc1 - mssc2;
    porcentagem = diferenca * 100;
    best = porcentagem / mssc2;
end