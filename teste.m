close all; clear; clc;

load('Nova com 20/fort50_k10');
k = 10;
dist_matrix = matriz_distancia(x);
metodo = 6; % Set Method
epsilon = 1e-6;  
centros = total_centros(1:k,:);
[classes1,c1,itekme,rein1] = kme(x,k,centros,epsilon,metodo,dist_matrix);
msscke = MSSC(x,classes1,c1,k);

[classes2,c2,itekmf,rein2] = kmf(x,k,centros,epsilon,metodo,dist_matrix);
mssckf = MSSC(x,classes2,c2,k);

[classes3,c3,itekm,~,maxdeg] = km(x,k,centros);
mssckm = MSSCKM(x,classes3,c3,k);

fprintf('MSSC KME: %2.4f\n', msscke);
fprintf('    iteration: %2.2f\n',itekme);
fprintf('MSSC KMF: %2.4f\n', mssckf);
fprintf('    iteration: %2.2f\n',itekmf);
fprintf('MSSC KM: %2.4f\n', mssckm);
fprintf('    iteration: %2.2f\n\n',itekm);
best = improvement(mssckm,msscke);
fprintf('Improvement kme: %2.2f%%\n',best);
best2 = improvement(mssckm,mssckf);
fprintf('Improvment kmf: %2.2f%%\n',best2);