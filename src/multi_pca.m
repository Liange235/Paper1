clear 
clc
close all
% global shift
%% data preparation
D = []; label = []; 
lib = [1,2,4,5]'; numel = length(lib);
dlim = 480*ones(1,numel);
% shift = [zeros(1,9),2,0,1,0,0,6];
tao = 0; dr = 00*ones(1,numel);  
Sf = cell(1,numel+1);
Sf(1) = {''};
for i = 2:numel+1
     str = strcat('f',num2str(lib(i-1)));
     Sf(i) = cellstr(str);
end
for i = 1:numel
str = num2str(lib(i));
if (lib(i)<10)
    str = strcat('0',num2str(lib(i)));
end
d_com = load(strcat('D:\Paper 2\te_process\d',str,'.dat'));
d_com = d_com(dr(i)+1:dlim(i)+dr(i),:);
D = [D;d_com];
label_com = i*ones(size(d_com,1),1);
label = [label;label_com];
end
[D,Dx] = mncn(D);
% for i = 1:numel
%     d_com = D(label==i,:);
%     temp = mypca(d_com);
%     for j = 1:52
%         W = temp(:,1:j);
%         pcaC = cov(d_com*W);
%         for k = 1:size(d_com,1)
%             Df(k) = 1/2*d_com(k,:)*W*inv(pcaC)*W'*d_com(k,:)'+1/2*log(det(pcaC));
%         end
%         r(j) = mean(Df);
%     end
%     [~,ind] = min(r);
%     Wxpca{i} = temp(:,1:ind);
%     pcaCov{i} = cov(d_com*Wxpca{i});
% end
for i = 1:numel
    d_com = D(label==i,:);
    Wxpca{i} = mypca(d_com);
    pcaCov{i} = cov(d_com*Wxpca{i});
end

%%%%%%***********test**************%%%%%%%%%%%%%
Dte = []; label_te = []; hits_te = []; 
dlim = 100*ones(1,numel); dr =  20*ones(1,numel);
for i = 1:numel
str = num2str(lib(i));
if (lib(i)<10)
    str = strcat('0',num2str(lib(i)));
end
d_com = load(strcat('D:\Paper 2\te_process\d',str,'_te.dat'));
d_com = d_com(160+dr(i)+1:160+dlim(i)+dr(i),:);
Dte = [Dte;d_com];
label_com = i*ones(size(d_com,1),1);
label_te = [label_te;label_com];
end
Dte = scale(Dte,Dx(1,:),Dx(2,:));
for i = 1:size(Dte,1)
    for j = 1:size(Wxpca,2)
       Df(j) = 1/2*Dte(i,:)*Wxpca{j}*inv(pcaCov{j})*Wxpca{j}'*Dte(i,:)'+1/2*log(det(pcaCov{j}));
    end
    [~,pre_label(i)] = min(Df);
end
for i = 1:numel
    fdr(i) = sum(pre_label(label_te==i)==i)/dlim(1);
end


