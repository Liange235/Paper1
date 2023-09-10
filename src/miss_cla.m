function [fdr,missR] = miss_cla(points,bound,seq)
numl = size(bound,2);
ret = zeros(size(points,1),1);
for i = 1:numl
   xx = bound{i}(:,1);
   yy = bound{i}(:,2);
   temp = inpolygon(points(:,1),points(:,2),xx,yy);
   if i ==seq
       a = sum(temp);
       continue
   end
   ret = ret|temp;
end
fdr = a/size(points,1);
missR = sum(ret)/size(points,1);