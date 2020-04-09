
function centros = init_centros(x,k)
    %x = rand(10,2);
    %k = 4;
    [n,d] = size(x);
    
    classes = zeros(1,n);
    centros = zeros(k,d);
    
    for i = 1:k
        classes(i) = i;
    end
    for i = k+1 : n
        classes(i) = round(1 + (k - 1)*rand);
    end
    
    for j = 1 : k % Pega somente os pontos que corresponde ao centro
        pos = encontrar(classes,j);
        if pos ~=  0 % Se não foi criado aleatóriamente não faça nada
             temp = x(pos,:);
             if size(temp,1) == 1 % Se houve somente uma linha
                 centros(j,:) = temp;% o centro é a própria linha
             else
                 centros(j,:) = sum(temp)/size(temp,1);
             end
        else
%             disp(k)
        end
    end
      
end