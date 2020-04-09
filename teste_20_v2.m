% Algorithm that solves the problem of degeneration of the k-means
% Analysis of 20 different samples for each method and report
% Data: 24/06/2015
% Autor: Nielsen C. Damasceno

close all; clear; clc;

rng(100)

filename = 'resultados_waveform.tex';

n_vezes = 20; 
tkme = zeros(n_vezes,1); tkmf = zeros(n_vezes,1); tkm = zeros(n_vezes,1);
msscke = zeros(n_vezes,1); mssckf = zeros(n_vezes,1); mssckm = zeros(n_vezes,1);
itekme = zeros(n_vezes,1); itekmf = zeros(n_vezes,1); itekm  = zeros(n_vezes,1);
rein = zeros(n_vezes,1); rein3 = zeros(n_vezes,1);

epsilon = 1e-6; % metodo = 3;
% filename = 'Comparativo6.xlsx';
% sheet = 8;    % Base de dados no excel (Planilha)
% numero = 3;  % A parti da linha (3, 11, 19)
% letra = 'C';  % C para kme   (Celula)
% letra = 'M';   % M para kmf (celula)

instancias = [{[{'Nova com 20/waveform_k500'},{'Nova com 20/waveform_k1000'},{'Nova com 20/waveform_k1500'},{'Nova com 20/waveform_k2000'}]};...
%     {[{'Nova com 20/ruspini_k15'},{'Nova com 20/ruspini_k25'}]};...
%     {[{'Nova com 20/iris_k15'}]};...
%     {[]};...
%     {[{'Nova com 20/cancer_k30'},{'Nova com 20/cancer_k40'}]};...
%     {[]};...
%     {[{'Nova com 20/fort2310_k40'}]};...
%     {[]};...
    ];
% k_values = [{[]},{[15,25]},{[15]},{[]},{[30,40]},{[]},{[40,]},{[]}];
% nomes = [{'Eilon'};{'Ruspini'};{'Iris'};{'Wine'};{'B-Cancer'};{'Reinelt'};{'image segmentation'};{'Waveform'}];
k_values = [{[500,100,1500,2000]}];
% nomes = [{'Eilon'};{'Ruspini'};{'Wine'};{'B-Cancer'};{'Reinelt'};{'image segmentation'}];
% nomes = [{'Wine'};{'B-Cancer'};{'Reinelt'}];
nomes = [{'Waveform'}];
methods = [{'\textsf{Random}'};{'\textsf{Greedy}'};{'$\varepsilon$-\textsf{Random}'};...
    {'$\varepsilon$-\textsf{Greedy}'};{'$\varepsilon$-\textsf{Mixed}'};{'\textsf{DB}'};{'\textsf{DB2}'}];
% d_max = [1,2,4;1,4,11;1,4,10;10,36,81;3,18,53;89,150,268];
d_max = cell(length(instancias),1);
for inst = 1:length(instancias)
    d_max{inst} = zeros(length(k_values{inst}),1);
end

% tabela_kme = zeros(6,3,7,4); % base, k, metodo, [%improv,iter.dev.,dmax,time]
% tabela_kmf = zeros(6,3,7,4); % base, k, metodo, [%improv,iter.dev.,dmax,time]
tabela_kme = cell(length(instancias),1);
tabela_kmf = cell(length(instancias),1);
for inst = 1:length(instancias)
    tabela_kme{inst} = cell(1,length(k_values{inst}));
    tabela_kmf{inst} = cell(1,length(k_values{inst}));
    for kk = 1:length(k_values{inst})
        tabela_kme{inst}{kk} = zeros(7,4); % metodo, [%improv,iter.dev.,dmax,time]
        tabela_kmf{inst}{kk} = zeros(7,4); % metodo, [%improv,iter.dev.,dmax,time]
    end
end
    
for inst = 1:length(instancias)
    for kk = 1:length(k_values{inst})
        load(instancias{inst}{kk});
        dist_matrix = matriz_distancia(x);
%         m=7;
        for m = 1:7
            it = 0;
            for i = 1 : n_vezes
                
                p1 = it * k + 1;
                it = it + 1;
                centros = total_centros( p1: it * k,:);
                
                tic;
                [classes,c,itekme(i),rein(i)] = kme(x,k,centros,epsilon,m,dist_matrix);
                tkme(i) = toc;
                msscke(i) = MSSC(x,classes,c,k);
                
                tic;
                [classes3,c3,itekmf(i),rein3(i)] = kmf(x,k,centros,epsilon,m,dist_matrix);
                tkmf(i) = toc;
                mssckf(i) = MSSC(x,classes3,c3,k);
                
                tic;
                [classes2,c2,itekm(i),~,maxdeg] = km(x,k,centros);
                if maxdeg > d_max{inst}(kk)
                    d_max{inst}(kk) = maxdeg;
                end
                tkm(i) = toc;
                mssckm(i) = MSSCKM(x,classes2,c2,k);
                
                disp(i);
            end
            disp([nomes{inst} ' k=' num2str(k_values{inst}(kk)) ' metodo=' methods{m}])
            fprintf('MSSC KME: %2.4f\n', mean(msscke));
            fprintf('    tempo: %f\n',mean(tkme));
            fprintf('    iteracao: %2.2f\n',mean(itekme));
            fprintf('MSSC KMF: %2.4f\n', mean(mssckf));
            fprintf('    tempo: %f\n',mean(tkmf));
            fprintf('    iteracao: %2.2f\n',mean(itekmf));
            fprintf('MSSC KM: %2.4f\n', mean(mssckm));
            fprintf('    tempo: %f\n',mean(tkm));
            fprintf('    iteracao: %2.2f\n\n',mean(itekm));
            best = improvement(mean(mssckm),mean(msscke));
            fprintf('Melhoria kme: %2.2f%%\n',best);
            best2 = improvement(mean(mssckm),mean(mssckf));
            fprintf('Melhoria kmf: %2.2f%%\n',best2);
            tabela_kme{inst}{kk}(m,1) = best;
            tabela_kme{inst}{kk}(m,2) = mean(itekme)-mean(itekm);
            tabela_kme{inst}{kk}(m,3) = d_max{inst}(kk);
            tabela_kme{inst}{kk}(m,4) = mean(tkme)-mean(tkm);
            
            tabela_kmf{inst}{kk}(m,1) = best2;
            tabela_kmf{inst}{kk}(m,2) = mean(itekmf)-mean(itekm);
            tabela_kmf{inst}{kk}(m,3) = d_max{inst}(kk);
            tabela_kmf{inst}{kk}(m,4) = mean(tkmf)-mean(tkm);
        end
    end
end

%% Escrevendo a tabela

f = fopen(filename,'w');

fprintf(f,'\\documentclass[fleqn]{article}\n\n\\usepackage[brazil]{babel}\n\\usepackage[utf8]{inputenc}\n\\usepackage{amsmath, amssymb, amsfonts}\n\\usepackage{float}\n\\usepackage{graphicx}\n\\usepackage[a4paper,left=3cm,right=2cm,top=3cm,bottom=2cm]{geometry}\n\\usepackage{caption}\n\n\\begin{document}\n');

fprintf(f,'\\begin{table}[!hbt]\n\\centering\n{\\footnotesize\n\\caption{Comparison among the six strategies for 20 distinct runs}\n\\label{results}\n\\begin{tabular}{cccccc|cccc}\n & & \\multicolumn{4}{c}{\\emph{first improving}} & \\multicolumn{4}{|c}{\\emph{last improving}} \\\\ \\cline{3-10}\n$k$ & strategy & \\emph{\\%%improv.} & \\emph{iter.dev.} & $d_{max}$ & \\emph{time} & \\emph{\\%%improv.} & \\emph{iter.dev.} & $d_{max}$ & \\emph{time} \\\\\n\\hline \\hline\n');
for inst = 1:length(instancias)
    fprintf(f,'(%c)\\emph{%s} & & & & & & & & &   \\\\\n',char('a'+inst-1),nomes{inst});
    for kk = 1:length(k_values{inst});
        fprintf(f,'%d',k_values{inst}(kk));
        for m = 1:7
%         m = 7;
            fprintf(f,' & %s & %.2f & %.1f & %d & %.2f & %.2f & %.1f & %d & %.2f \\\\\n',methods{m},...
                tabela_kme{inst}{kk}(m,1),tabela_kme{inst}{kk}(m,2),tabela_kme{inst}{kk}(m,3),...
                tabela_kme{inst}{kk}(m,4),tabela_kmf{inst}{kk}(m,1),tabela_kmf{inst}{kk}(m,2),...
                tabela_kmf{inst}{kk}(m,3),tabela_kmf{inst}{kk}(m,4));
        end
        fprintf(f,'\\hline\n');
    end
    fprintf(f,'\\hline\n');
end
fprintf(f,'\\end{tabular}\n}\n\\end{table}');


% first_por_metodo=cell(1,7);
% last_por_metodo=cell(1,7);
% for inst = 1:6
%     for kk = 1:3
%         for m = 1:7
%             first_por_metodo{m}=[first_por_metodo{m} tabela_kme(inst,kk,m,1)];
%             last_por_metodo{m}=[last_por_metodo{m} tabela_kmf(inst,kk,m,1)];
%         end
%     end 
% end
% 
% dif{1} = last_por_metodo{1} - first_por_metodo{1};
% dif{2} = last_por_metodo{2} - first_por_metodo{2};
% dif{3} = last_por_metodo{3} - first_por_metodo{3};
% dif{4} = last_por_metodo{4} - first_por_metodo{4};
% dif{5} = last_por_metodo{5} - first_por_metodo{5};
% dif{6} = last_por_metodo{6} - first_por_metodo{6};
% dif{7} = last_por_metodo{7} - first_por_metodo{7};
% 
% med(1) = mean(dif{1});
% med(2) = mean(dif{2});
% med(3) = mean(dif{3});
% med(4) = mean(dif{4});
% med(5) = mean(dif{5});
% med(6) = mean(dif{6});
% med(7) = mean(dif{7});
% 
% s2(1) = sum((dif{1}-med(1)).^2)/17;
% s2(2) = sum((dif{2}-med(2)).^2)/17;
% s2(3) = sum((dif{3}-med(3)).^2)/17;
% s2(4) = sum((dif{4}-med(4)).^2)/17;
% s2(5) = sum((dif{5}-med(5)).^2)/17;
% s2(6) = sum((dif{6}-med(6)).^2)/17;
% s2(7) = sum((dif{7}-med(7)).^2)/17;
% 
% s = sqrt(s2);
% 
% t = med*sqrt(18)./s;
% 
% porcento = (tcdf(t,17)-0.5)*2;
% 
% ns = t/sqrt(18);
% 
% gap = 0.05;
% hold on
% p0 = plot([0 8],[0 0],'k');
% set(gca,'YGrid','on');
% for i = 1:7
%     p1(i) = plot(i-gap,med(i),'b.','MarkerSize',15);
%     p2(i) = plot([i i]-gap,[med(i)-s(i) med(i)+s(i)],'b','LineWidth',2);
%     p3(i) = plot(i+gap,med(i),'r.','MarkerSize',15);
%     p4(i) = plot([i i]+gap,[med(i)-s(i)*ns(i) med(i)+s(i)*ns(i)],'r','LineWidth',2);
% end
% set(gca,'XTickLabel',{' ',['Random' sprintf(' (%.2f%%)',100*porcento(1))],['Greedy' sprintf(' (%.2f%%)',100*porcento(2))],['e-Random' sprintf(' (%.2f%%)',100*porcento(3))],['e-Greedy' sprintf(' (%.2f%%)',100*porcento(4))],['e-Mixed' sprintf(' (%.2f%%)',100*porcento(5))],['DB' sprintf(' (%.2f%%)',100*porcento(6))],['DB2' sprintf(' (%.2f%%)',100*porcento(7))],' '});
% legend([p2(1),p4(1)],'Sample standard deviation interval','Standard error interval for a given confidence level','Location','northwest');
% 
% 
% fprintf(f,'\n\\begin{table}[H]\n\\centering\n\\caption{.}\n\\label{tab}\n\\begin{tabular}{|r|c|c|c|c|c|c|c|}\n\\hline\n\\textbf{Método} & Random & Greedy & $\\varepsilon$-Random & $\\varepsilon$-Greedy & $\\varepsilon$-Mixed & DB & DB2 \\\\\\hline\n');
% fprintf(f,'\\textbf{Nível de confiança} & %.2f\\%% & %.2f\\%% & %.2f\\%% & %.2f\\%% & %.2f\\%% & %.2f\\%% \\\\\\hline',100*porcento(1),100*porcento(2),100*porcento(3),100*porcento(4),100*porcento(5),100*porcento(6),100*porcento(7));
% fprintf(f,'\\end{tabular}\n\\end{table}\n\\begin{figure}[H]\n\\centering\n\\includegraphics[scale=0.63]{standard_error_interval.png}\n\\caption{.}\n\\label{fig}\n\\end{figure}\n');


fprintf(f,'\\end{document}');
fclose(f);

save workspace_teste_20_v2_waveform
% exit






% load('rel 8/fort50_k20');
% dist_matrix = matriz_distancia(x);
% it = 0;
% for i = 1 : n_vezes
%     p1 = it * k + 1;
%     it = it + 1; 
%     centros = total_centros( p1: it * k,:);
%     centrosd = total_c( p1 : it * k,:);
%     tic; 		  % inicia contagem
%     [classes,c,itekme(i),rein(i)] = kme(x,k,centros,epsilon,metodo,dist_matrix);% Normal
% %     [classes,c,itekme(i),rein(i)] = kmf(x,k,centros,epsilon,metodo,dist_matrix); % Calcula no final
%     tkme(i) = toc; % marca tempo
%     msscke(i) = MSSC(x,classes,c,k);
%     tic;           % inicia contagem
%     [classes2,c2,itekm(i)] = km(x,k,centros);  % K-means
%     tkm(i) = toc;  % marca tempo
%     mssckm(i) = MSSCKM(x,classes2,c2,k);
%     disp(i);
% end
% fprintf('MSSC KME: %2.4f\n', mean(msscke));
% fprintf('    tempo: %f\n',mean(tkme));
% fprintf('    iteracao: %2.2f\n',mean(itekme));
% fprintf('MSSC KM: %2.4f\n', mean(mssckm));
% fprintf('    tempo: %f\n',mean(tkm));
% fprintf('    iteracao: %2.2f\n\n',mean(itekm));
% best = improvement(mean(mssckm),mean(msscke));
% fprintf('Melhoria: %2.2f%%\n',best);






























%fprintf('Reincid�ncia: %d\n',max(rein));

% Escrever no relat�rio Excel
% KM
% A = {mean(mssckm) max(mssckm) min(mssckm) [] mean(itekm)  1 mean(tkm)};
% xlRange = [letra num2str(numero)];
% xlswrite(filename,A,sheet,xlRange)
% 
% if metodo == 1
%     A = {mean(msscke) max(msscke) min(msscke) best mean(itekme)  1 mean(tkme)};
%     numero = numero + metodo;
%     xlRange = [letra num2str(numero)];
%     xlswrite(filename,A,sheet,xlRange);
% end
% if metodo == 2
%     A = {mean(msscke) max(msscke) min(msscke) best mean(itekme)  1 mean(tkme)};
%     numero = numero + metodo;
%     xlRange = [letra num2str(numero)];
%     xlswrite(filename,A,sheet,xlRange);
% end
% if metodo == 3
%     A = {mean(msscke) max(msscke) min(msscke) best mean(itekme)  1 mean(tkme)};
%     numero = numero + metodo;
%     xlRange = [letra num2str(numero)];
%     xlswrite(filename,A,sheet,xlRange);
% end
% if metodo == 4
%     A = {mean(msscke) max(msscke) min(msscke) best mean(itekme)  1 mean(tkme)};
%     numero = numero + metodo;
%     xlRange = [letra num2str(numero)];
%     xlswrite(filename,A,sheet,xlRange);
% end
% 
% if metodo == 5
% %     metodo = 4;
%     A = {mean(msscke) max(msscke) min(msscke) best mean(itekme)  1 mean(tkme)};
%     numero = numero + metodo;
%     xlRange = [letra num2str(numero)];
%     xlswrite(filename,A,sheet,xlRange);
% end
% 
% if metodo == 6
%     A = {mean(msscke) max(msscke) min(msscke) best mean(itekme)  1 mean(tkme)};
%     numero = numero + metodo;
%     xlRange = [letra num2str(numero)];
%     xlswrite(filename,A,sheet,xlRange);
% end
% 
% if metodo == 7
%     A = {mean(msscke) max(msscke) min(msscke) best mean(itekme)  1 mean(tkme)};
%     numero = numero + metodo;
%     xlRange = [letra num2str(numero)];
%     xlswrite(filename,A,sheet,xlRange);
% end
