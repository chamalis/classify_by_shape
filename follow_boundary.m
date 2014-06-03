function [U, exit_code] = follow_boundary(b)

[H,W] = size(b);

white_pos = find(b~=0);
num_whites = length(white_pos);
starting_pixel_pos = white_pos(ceil( rand(1,1) * num_whites ));
startx = mod(starting_pixel_pos, H);
starty = ceil(starting_pixel_pos / H);

visited = zeros(H,W);
u = zeros(1, num_whites);

i = 0;
nextx = startx; nexty = starty;
exit_code = 1;

bc = b;

while 1==1
    
    x = nextx;  y = nexty;
        x 
        y 
        bc(x-3:x+3, y-3:y+3)
        pause()
    if bc(x-1, y+1) > 0  && visited(x-1, y+1) ~= 1 %NE
        nextx = x-1;
        nexty= y+1;
    elseif bc(x,y+1) > 0 && visited(x, y+1) ~= 1  %E
        nexty = y+1;
    elseif bc(x+1,y+1) > 0 && visited(x+1, y+1) ~= 1 %SE
        nextx = x+1;
        nexty = y+1;
    elseif bc(x+1, y) > 0 && visited(x+1, y) ~= 1 %S
        nextx = x+1;
    elseif bc(x+1, y-1) > 0 && visited(x+1, y-1) ~= 1 %SW
        nextx = x+1;
        nexty = y-1;
    elseif bc(x, y-1) > 0  && visited(x, y-1) ~= 1 %W
        nexty = y-1;
    elseif bc(x-1, y-1) > 0 && visited(x-1, y-1) ~= 1 %NW
        nextx = x-1;
        nexty = y-1;
    elseif bc(x-1, y) > 0 && visited(x-1, y) ~= 1 %N
        nextx = x-1;
    else
        disp('Error tracking boundary: path broken before finish (reach the starting point)');
        finished = 1;
        exit_code = -1;
        startx
        starty
        x 
        y 
        bc(x-3:x+3, y-3:y+3)
        pause()
        break;
    end
    
    if (nextx == startx && nexty == starty)
        if i > 2
            break;
        else
            continue;
        end
    end
    if i > num_whites+2
        disp('Counted more white pixels than the boundary is and didnt reach the starting');
        exit_code = -1;
        startx
        starty
        x
        y 
        bc(x-3:x+3, y-3:y+3)
        pause()
        break;
    end
    
    visited(nextx, nexty) = 1;
    i = i+1;
    u(i) = nextx + nexty*1j;
    bc(nextx, nexty) = 666;
    
end
    
    
    


U = u;


