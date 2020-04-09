% epsilon-Random
function centros =  randomico_epsilon(x,classe,k,centros,cluster,epsilon,gr,cluster_length)

[n,d] = size(x);
kk = k-gr;
centros_not_nan = zeros(k,1);
j = 1;
for i = 1:k
    if ~isnan(centros(i,1))
        centros_not_nan(j) = i;
        j = j+1;
    end
end

for g = 1:gr
    c = centros_not_nan(randi(kk+g-1));
    while cluster_length(c) <= 1
        c = centros_not_nan(randi(kk+g-1));
    end
    cg = cluster(g);
    centros(cg,:) = centros(c,:) + epsilon*(randi(2,1,d)*2-3);
    sum_c = zeros(1,d);
    sum_cg = zeros(1,d);
    n_c = 0;
    n_cg = 0;
    for i = 1:n
        if classe(i)==c
            if sum((x(i,:)-centros(c,:)).^2) > sum((x(i,:)-centros(cg,:)).^2)
                classe(i) = cg;
                sum_cg = sum_cg + x(i,:);
                n_cg = n_cg+1;
            else
                sum_c = sum_c + x(i,:);
                n_c = n_c+1;
            end
        end
    end
    cluster_length(c) = n_c;
    cluster_length(cg) = n_cg;
    centros(c,:) = sum_c/n_c;
    centros(cg,:) = sum_cg/n_cg;
    if n_c == 0
        centros(c,:) = centros(cg,:);
    end
    if n_cg == 0
        centros(cg,:) = centros(c,:);
    end
    centros_not_nan(kk+g) = cg;
end

end