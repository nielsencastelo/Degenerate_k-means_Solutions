function index_vector = push_heap(index_vector,n,index,values_vector)

n = n+1;
index_vector(n) = index;
while floor(n/2)>0
    if values_vector(index_vector(n)) > values_vector(index_vector(floor(n/2)))
        tmp = index_vector(n);
        index_vector(n) = index_vector(floor(n/2));
        index_vector(floor(n/2)) = tmp;
        n = floor(n/2);
    else
        break;
    end
end

end