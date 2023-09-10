%% π ’œ¿‡–Õ∑÷Œˆ
clear 
clc
close all
D = []; label = []; 
lib = [8,11,12]'; numel = length(lib);
dlim = 480*ones(1,numel);
tao = 0; dr = 00*ones(1,numel);
type = {45,51,22}
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
d_com = load(strcat('D:\Paper 2\te_process\d',str,'_te.dat'));
d_com = d_com(dr(i)+1:dlim(i)+dr(i),:);
figure()
plot(d_com(:,type{i}));
end