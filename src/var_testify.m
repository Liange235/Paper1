clear
close all
clc
global shift
%********training*****************%
D = [];label = [];dlim = 200;  
lib = [0:7]'; num = length(lib);
for i = 1:num
str = num2str(lib(i));
if (lib(i)<10)
    str = strcat('0',num2str(lib(i)));
end
d_com = load(strcat('D:\Paper 2\te_process\d',str,'.dat'));
d_com = d_com(1:dlim,:);
D = [D;d_com];
label_com = i*ones(size(d_com,1),1);
label = [label;label_com];
end
% D = mncn(D);
for i = 1:num
d_com = D(label==i,:);
   for j = 1:52
      [~,index] = corr_hypo(d_com,j-1);
      Vmap{j,i} = index;
      Map(j,i) = size(index,2);
   end
end
for i = 1:52
var_com = [];
for j = 1:num
    var_com = [var_com,Vmap{i,j}];
end
temp{i} = sort(unique(var_com));
ind(i) = length(temp{i});
end
figure()
plot(ind,'b*-');
[~,a] = min(ind);
shift = temp{a};