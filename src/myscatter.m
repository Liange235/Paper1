%%**plot a picture involving different clusters according to the labels
function [] = myscatter(data,label,lib)
cluster_no = length(lib);
color = hsv;
color = color(ceil(linspace(1,33,cluster_no)),:);


type = 'opx*s^+dh.>';
hold on
for i = 1:cluster_no
    m = '.';
    ind = find(label == lib(i));
    c = repmat(color(i,:),length(ind),1);
    scatter(data(ind,1),data(ind,2),140,c,m,'LineWidth',0.3);
end
legend(num2str(lib));