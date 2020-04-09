% Método 2: pegar o ponto que estão mais distante em relação ao seu centro
% de todos os cluster. Selecione o registro que for mais distante.
% Data: 12/06/2015
% Autor: Nielsen Castelo Damasceno
% Entrada: x s�o as amostras, centros, a posi��o dos cluster, e o grau
% Sa�da: Novos centros

function centros = centro_cluster(x,classe,k,centros,cluster,gr,ponto_mais_distante,dist_do_ponto_mais_distante,cluster_length)

[n,d] = size(x);

not_deg = ones(1,k);
for g = 1:gr
    not_deg(cluster(g)) = 0;
end
centros_heap = zeros(1,k);
i = 1;
for j = 1:k
    if not_deg(j) == 1
        centros_heap(i) = j;
        i = i+1;
    end
end
centros_heap = make_heap(centros_heap,k-gr,dist_do_ponto_mais_distante);

for g = 1:gr
    c = centros_heap(1);
    while cluster_length(c) <= 1
        centros_heap = pop_heap(centros_heap,k-gr+g-1,dist_do_ponto_mais_distante);
        dist_do_ponto_mais_distante(c) = 0;
        centros_heap = push_heap(centros_heap,k-gr+g-2,c,dist_do_ponto_mais_distante);
        c = centros_heap(1);
    end
    centros_heap = pop_heap(centros_heap,k-gr+g-1,dist_do_ponto_mais_distante);
    cg = cluster(g);
    centros(cg,:) = ponto_mais_distante(c,:);
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
    dist_do_ponto_mais_distante(c) = -1;
    dist_do_ponto_mais_distante(cg) = -1;
    for i = 1:n
        if classe(i) == c
            di = sqrt(sum((x(i,:)-centros(c,:)).^2));
            if di > dist_do_ponto_mais_distante(c)
                dist_do_ponto_mais_distante(c) = di;
                ponto_mais_distante(c,:) = x(i,:);
            end
        elseif classe(i) == cg
            di = sqrt(sum((x(i,:)-centros(cg,:)).^2));
            if di > dist_do_ponto_mais_distante(cg)
                dist_do_ponto_mais_distante(cg) = di;
                ponto_mais_distante(cg,:) = x(i,:);
            end
        end
    end
    centros_heap = push_heap(centros_heap,k-gr+g-2,c,dist_do_ponto_mais_distante);
    centros_heap = push_heap(centros_heap,k-gr+g-1,cg,dist_do_ponto_mais_distante);
end

end