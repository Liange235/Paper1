function bord_after = bound_inc(bord_before)
bord_mean = mean(bord_before);
flag(:,1) = bord_before(:,1)>bord_mean(1);
flag(:,2) = bord_before(:,2)>bord_mean(2);
flag = flag(:,1)*10+flag(:,2);
xl = 0.2*(max(bord_before(:,1))-min(bord_before(:,1)));
yl = 0.2*(max(bord_before(:,2))-min(bord_before(:,2)));
for i = 1:size(flag,1)
    temp = flag(i);
    switch temp
        case 11
          bord_after(i,:) = [bord_before(i,1)+xl,bord_before(i,2)+yl];
        case 01
          bord_after(i,:) = [bord_before(i,1)-xl,bord_before(i,2)+yl];
        case 00
          bord_after(i,:) = [bord_before(i,1)-xl,bord_before(i,2)-yl];
        case 10
          bord_after(i,:) = [bord_before(i,1)+xl,bord_before(i,2)-yl];
          
    end
end