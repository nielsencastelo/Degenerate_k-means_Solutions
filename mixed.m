function centros = mixed(x,classe,k,centros,cluster,epsilon,gr,cluster_cost,cluster_length)
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
    centros_heap = make_heap(centros_heap,k-gr,cluster_cost);

    for g = 1:gr
        c = centros_heap(1);
        while cluster_length(c) <= 1
            centros_heap = pop_heap(centros_heap,k-gr+g-1,cluster_cost);
            cluster_cost(c) = 0;
            centros_heap = push_heap(centros_heap,k-gr+g-2,c,cluster_cost);
            c = centros_heap(1);
        end
        centros_heap = pop_heap(centros_heap,k-gr+g-1,cluster_cost);
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
        cluster_cost(c) = 0;
        cluster_cost(cg) = 0;
        for i = 1:n
            if classe(i) == c
                cluster_cost(c) = cluster_cost(c) + sum((x(i,:)-centros(c,:)).^2);
            elseif classe(i) == cg
                cluster_cost(cg) = cluster_cost(cg) + sum((x(i,:)-centros(cg,:)).^2);
            end
        end
        cluster_cost(c) = sqrt(cluster_cost(c));
        cluster_cost(cg) = sqrt(cluster_cost(cg));
        centros_heap = push_heap(centros_heap,k-gr+g-2,c,cluster_cost);
        centros_heap = push_heap(centros_heap,k-gr+g-1,cg,cluster_cost);
    end
end