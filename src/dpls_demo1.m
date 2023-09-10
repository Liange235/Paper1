clear
close all
clc
%********training*****************%
D = []; label = [];tao = 8;dlim = 50;
lib = [3,4,11]'; numel = length(lib);
d00 = load('D:\Paper 2\te_process\d00.dat');
[d00,Dx] = mncn(d00);
for i = 2:numel+1
     str = strcat('f',num2str(lib(i-1)));
     Sf(i) = cellstr(str);
end
for i = 1:numel
dd_y = zeros(dlim,numel);
str = num2str(lib(i));
if (lib(i)<10)
    str = strcat('0',num2str(lib(i)));
end
d_com = load(strcat('D:\Paper 2\te_process\d',str,'.dat')); 
d_com = d_com(1:dlim,:);
d_com = scale(d_com,Dx(1,:),Dx(2,:));
dd_com = dynamic(d_com,tao);
D = [D;dd_com];
label_com = lib(i)*ones(size(dd_com,1),1);
label = [label;label_com];
end
D_y = zeros(size(D,1),numel); 
for i = 1:numel D_y(label==lib(i),i)=1*ones(sum(label==lib(i)),1);  end
[Wxcca,Wycca] = canoncorr(D,D_y);
t = D*Wxcca;

%********CVA ¶¯Ì¬·ÖÎö*****************%
%********t-sneÏÔÊ¾*****************%
% mappedX = tsne(t, label, 2, 2, 50);
% plot(mappedX(:,1),mappedX(:,2),'ko');
%%%%%%***********test**************%%%%%%%%%%%%%
Dte = []; label_te = []; hits_te = [];  
for i = 1:numel
str = num2str(lib(i));
if (lib(i)<10)
    str = strcat('0',num2str(lib(i)));
end
d_com = load(strcat('D:\Paper 2\te_process\d',str,'_te.dat'));
d_com = d_com(160+1:160+dlim,:);
d_com = scale(d_com,Dx(1,:),Dx(2,:));
dd_com = dynamic(d_com,tao);
Dte = [Dte;dd_com];
label_com = lib(i)*ones(size(dd_com,1),1);
label_te = [label_te;label_com];
end
t = Dte*Wxcca;
mappedX = tsne(t, label, 2, 2, 50);
figure()
myscatter(mappedX,label_te,lib);
legend('1','2','3');