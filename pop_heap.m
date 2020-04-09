function index_vector = pop_heap(index_vector,n,values_vector)

index_vector(1) = index_vector(n);
index_vector(n) = 0;
n = n-1;
i = 1;
while i*2 <= n
    if i*2+1 > n
        maxChild = i*2;
    elseif values_vector(index_vector(i*2)) > values_vector(index_vector(i*2+1))
        maxChild = i*2;
    else
        maxChild = i*2+1;
    end
    if values_vector(index_vector(i)) < values_vector(index_vector(maxChild))
        tmp = index_vector(i);
        index_vector(i) = index_vector(maxChild);
        index_vector(maxChild) = tmp;
        i = maxChild;
    else
        break;
    end
end

end