function [x,y,del_row] = clear_d(ta,tb)
 d_mat = som_eucdist2(ta,tb);
 d_vec = sort(unique(d_mat(:)));
 d_vec(1) = [];
 [fun,varx] = ksdensity(d_vec,'bandwidth',0.1,'function','cdf');
  ind = min(find(fun>0.3));
  threshold = varx(ind);
  d_mat = d_mat>threshold;
  del_row = [];
 for i = 1:size(d_mat,1)
     temp = d_mat(i,:);
    if sum(temp)/size(ta,1)>0.8
        del_row = [del_row,i];
    end
 end
 ind = 1:size(ta,1);
ta(del_row,:) = [];
x = ta(:,1);
y = ta(:,2);