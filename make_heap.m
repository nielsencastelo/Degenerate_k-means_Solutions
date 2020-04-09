function index_vector = make_heap(index_vector,n,values_vector)

i = floor(n/2);
while i > 0
    j = i;
    while j*2 <= n
        if j*2+1 > n
            maxChild = j*2;
        elseif values_vector(index_vector(j*2)) > values_vector(index_vector(j*2+1))
            maxChild = j*2;
        else
            maxChild = j*2+1;
        end
        if values_vector(index_vector(j)) < values_vector(index_vector(maxChild))
            tmp = index_vector(j);
            index_vector(j) = index_vector(maxChild);
            index_vector(maxChild) = tmp;
            j = maxChild;
        else
            break;
        end
    end
    i = i-1;
end

end