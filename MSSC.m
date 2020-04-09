% Função custo minimum sum of squares clustering 
% Data: 12/06/2015
% Autor: Nielsen C. Damasceno
function sse = MSSC(x,classes,centros,k)
    c = 1 : k;
    ssex = zeros(k,1);
    
    for j = 1 : length(c)
        test = encontrar(classes,c(j)); % Verifica se existe os índeces
        if test ~= 0                    % Se houver
            temp = x(test,:);           % Pega os indices referente as amostras
            [tam,~] = size(temp);
            for m = 1 : tam
                %ssex(j) = ssex(j) + norm((temp(m,:) - centros(j,:)) * (temp(m,:) - centros(j,:))');
                %ssex(j) = norm(temp(m,:) - centros(j,:))^2;
                ssex(j) = ssex(j) + (temp(m,:) - centros(j,:)) * (temp(m,:) - centros(j,:))';
            end   
        end
    end
    sse = sum(ssex);
end