function C = dilate(im, mask)

[H W] = size(im);

% %temporarily reversing image to get 1 in foreground and 0 to background so
% %that operator application is easier and simpler
% %before that make 255 ->1
% tmp = zeros(H,W);
% reverse_im = zeros(H,W);
% tmp(find(im == 255)) = 1;
% reverse_im = 1 - tmp;


%output image same dimension as input image
C = zeros(H,W);   
expanded = zeros(H+2,W+2);  %expanded is also reversed (1 object, 0 background)
expanded(2:H+1, 2:W+1) = im;

one_zero = expanded;
one_zero(find(one_zero > 0)) = 1; 

for i=2:H+1                                     
    for j=2:W+1
        score = mask(1,1)*one_zero(i-1,j-1) + mask(1,2)*one_zero(i-1,j) + mask(1,3)*one_zero(i-1,j+1)+ ...
                mask(2,1)*one_zero(i,j-1) + mask(2,2)*one_zero(i,j) + mask(2,3)*one_zero(i,j+1)+ ...
                mask(3,1)*one_zero(i+1,j-1) + mask(3,2)*one_zero(i+1,j) + mask(3,3)*one_zero(i+1,j+1);
        %dilation: even if 1 pixel matches then apply 1 to final image
        if (score > 0)  
            C(i-1,j-1) = 255;  %foreground (object) color
        else
            C(i-1,j-1) = 0;
        end
    end
end

%finally output image C follows the initial coloring scheme: 
%0 for object and 1 for the background
end