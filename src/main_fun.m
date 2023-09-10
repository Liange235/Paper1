clear
close all
clc
%********training*****************%
D = []; label = [];tao = 0;dlim = 480; grp = []; dr = 0;
lib = [0,4,5]'; numel = length(lib);
% [N_Center,Dx] = mysom_train(1,0.9); 
lg = 0;
for i = 2:numel+1
     str = strcat('f',num2str(lib(i-1)));
     Sf(i) = cellstr(str);
end
for i = 1:numel
str = num2str(lib(i));
if (lib(i)<10)
    str = strcat('0',num2str(lib(i)));
end
d_com = load(strcat('D:\研究生\Paper 2\te_process\d',str,'.dat'));
d_com = d_com(1:480,:);
% d_com = scale(d_com,Dx(1,:),Dx(2,:));
absd_com = zeros(480,52);
% absd_com = [];
for j = 1:lg
    sub = N_Center(j,:);
    stat = sqrt(diag((d_com-sub(ones(size(d_com,1),1),:))*(d_com-sub(ones(size(d_com,1),1),:))'));
    absd_com = absd_com+stat*ones(1,52);
%     absd_com = [absd_com,stat];
%     d_com = d_com-ones(size(d_com,1),1)*sub;
end
d_com = d_com+absd_com;
d_com = d_com(0+dr+1:dr+dlim,:);
dd_com = dynamic(d_com,tao);
D = [D;dd_com];
label_com = lib(i)*ones(size(dd_com,1),1);
grpx = i*ones(size(dd_com,1),1);
label = [label;label_com];
grp = [grp;grpx];
end
% D_y = zeros(size(D,1),numel); 
% for i = 1:numel D_y(label==lib(i),i)=1*ones(sum(label==lib(i)),1);  end

[D,Dx] = mncn(D);
% Wxpca = mypca(D);
% D = D*Wxpca;
% Wxcca = canoncorr(D,D_y);
% t = D*Wxcca;

Wxcca = canonize(D,grp);
t = D * Wxcca(:,1:numel-1);


figure()
myscatter(t,label,lib);
title('train&CVA');
%% 计算每个类别的95%椭圆置信区间%%
mappedX = tsne(t, [], 2, size(t,2), 400);
% load('D:\Paper 1\mappedX0124567');
% save('D:\Paper 1\mappedX047','mappedX');
figure(); hold on
% mapNew = [];
for i = 1:numel
    temp = mappedX(label==lib(i),:);
    [xx,yy,del_row{i}] = clear_d(temp,temp);
    DT{i} = delaunayTriangulation(xx,yy);
    k{i} = convexHull(DT{i});
    bord{i} = [DT{i}.Points(k{i},1),DT{i}.Points(k{i},2)];
    bord{i} = bound_inc(bord{i});
%     temp(del_row{i},:) = [];
%     mapNew = [mapNew;temp];
end
myscatter(mappedX,label,lib);
for i = 1:numel
    temp = bord{i};
    [fdr_tra(i),miss_tra(i)] = miss_cla(mappedX(label==lib(i),:),bord,i);
    plot(temp(:,1),temp(:,2),'k-.','LineWidth',1.5);
    mean1(i) = mean(DT{i}.Points(k{i},1));mean2(i) = mean(DT{i}.Points(k{i},2));
    text(mean1(i),mean2(i),num2str(lib(i)),'FontSize',18);
end
m_far = mean(miss_tra);
% title(strcat('Offline development results&fdr = ',num2str(m_far)),'FontName','Times','FontSize',13.5);
title('Offline development results of FDA-t-SNE','FontName','Times','FontSize',13.5);
xlabel('y1','FontName','Times','Fontsize',14);
ylabel('y2','FontName','Times','Fontsize',14);

% ************bp训练模型*****************%
% ind = floor(linspace(1,size(D,1),0.7*size(D,1)));
% D1 = D(ind,:); mappedX1 = mappedX(ind,:);
% ind = ~ismember([1:size(D,1)],ind);
% D2 = D(ind,:); mappedX2 = mappedX(ind,:);
[train_x,xs]=mapminmax(D',0 ,1);
[train_y,ys]=mapminmax(mappedX',0 ,1);
% for i = 1:40
hiddennum = [5];
%  for j = 1:30
%      clear bpnet
bpnet = newff(train_x,train_y,hiddennum); % fitnet
bpnet.trainParam.lr = 0.1;
[bpnet,~] = train(bpnet,train_x,train_y);
% load('D:\Paper 1\net047');
% save('D:\Paper 1\net047','bpnet');
%% 计算训练误差
% test_x = mapminmax('apply',D2',xs);
% pre_y = sim(bpnet,test_x);
% pre_y = mapminmax('reverse',pre_y,ys);
% pre_y = pre_y';
% mse(j,i) = sqrt(sum(diag((pre_y-mappedX2)*(pre_y-mappedX2)')));
%  end
% end
% figure(); 
% subplot(1,2,1); hold on;plot(mappedX(:,1));plot(pre_y(:,1),'r-')
% subplot(1,2,2);hold on;plot(mappedX(:,2));plot(pre_y(:,2),'r-')
%%%%%%***********test**************%%%%%%%%%%%%%
Dte = []; label_te = []; hits_te = [];  dlim = 800; dr =  0;
for i = 1:numel
str = num2str(lib(i));
if (lib(i)<10)
    str = strcat('0',num2str(lib(i)));
end
d_com = load(strcat('D:\研究生\Paper 2\te_process\d',str,'_te.dat'));
d_com = scale(d_com,Dx(1,:),Dx(2,:));
absd_com = zeros(960,52);
% absd_com = [];
for j = 1:lg
    sub = N_Center(j,:);
    stat = sqrt(diag((d_com-sub(ones(size(d_com,1),1),:))*(d_com-sub(ones(size(d_com,1),1),:))'));
    absd_com = absd_com+stat*ones(1,52);
%      absd_com = [absd_com,stat];
%     d_com = d_com-ones(size(d_com,1),1)*sub;
end
d_com = d_com+absd_com; 
d_com = d_com(160+dr+1:160+dr+dlim,:);
dd_com = dynamic(d_com,tao);
Dte = [Dte;dd_com];
label_com = lib(i)*ones(size(dd_com,1),1);
label_te = [label_te;label_com];
end
% Dte = scale(Dte,Dx(1,:),Dx(2,:));
% Dte = Dte*Wxpca;
test_x = mapminmax('apply',Dte',xs);
pre_y = sim(bpnet,test_x);
pre_y = mapminmax('reverse',pre_y,ys);
t = pre_y';
figure(); hold on
myscatter(t,label_te,lib);
% scatter(t(:,1),t(:,2),140,'k.','LineWidth',0.3);
for i = 1:numel
    temp = bord{i};
    xx = temp(:,1);
    yy = temp(:,2);
    [fdr_tes(i),miss_tes(i)] = miss_cla(t(label_te==lib(i),:),bord,i);
    plot(xx,yy,'k-.','LineWidth',1.5);
    text(mean1(i),mean2(i),num2str(lib(i)),'FontSize',18);
end
m_far = mean(miss_tes);
% title(strcat('Online implementation&fdr = ',num2str(m_far)),'FontName','Times','FontSize',13.5);
title('Online implementation results of FDA-t-SNE','FontName','Times','FontSize',13.5);
% title('Trajectory of fault4 during 8-48h','FontName','Times','FontSize',13.5);
xlabel('y1','FontName','Times','Fontsize',14);
ylabel('y2','FontName','Times','Fontsize',14);

% %%% 单独对每个故障进行在线监控
% d_com = t(label_te==lib(2),:);
% for i = 160:40:960
%     if i+40>960
%         break
%     end
%     draw_arrow([d_com(i,1) d_com(i,2)],[d_com(i+40,1) d_com(i+40,2)],0.1);
% end