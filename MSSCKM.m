% Função custo minimum sum of squares clustering 
% Data: 12/06/2015
% Autor: Nielsen C. Damasceno
function sse = MSSCKM(x,classes,centros,k)
    c = 1 : k;
    ssex = zeros(k,1);
    
    for j = 1 : length(c)
        if ~(isnan(centros(j,:)))
            temp = x(encontrar(classes,c(j)),:);
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