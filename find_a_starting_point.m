function [x, y] = find_a_starting_point(im)

flag  = 0;
for i =1:size(im,1)
    for j=1:size(im,2)
        if(im(i,j) ~= 0)
            x = i;
            y = j;
            flag = 1;
            break;
        end
    end
    if flag == 1
        break
    end
end

     