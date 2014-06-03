function C = erose(im, mask)


[H W] = size(im);

%temporarily reversing image to get 1 in foreground and 0 to background so
%that operator application is easier and simpler
%before that make 255 ->
% tmp = zeros(H,W);
% reverse_im = zeros(H,W);
% tmp(find(im == 255)) = 1;
% reverse_im = 1 - tmp;


%output image same dimension as input image and white background so
%initialize to 1 (white == background)
C = zeros(H,W);   

%Parakatw metatrepoume ta 255 se assous ... gt .. akouson akouson
%TO apisteuto matlab OTAN KANAME PRAKSEIS score =... me 255ria/0 times tote
%an eixame ola 0 epestrefe 0 ok .. alla OTAN eixame 1 eite 2 eite 9 255ria 
%sto parathiro edine apantisi panta score = 255 anti 255*2, 255*9 klp! 
%apisteuto ki omws alithino. matlab rocks!
one_zero = im;
one_zero(find(one_zero > 0)) = 1;   

%Given our assumption about erosion first/last row/column (picture's boundaries)
%will always be background value, so we dont even access C(0,:) or C(H,:)
%C(:,0) and C(:, W)
for i=2:H-1                                       
    for j=2:W-1
        score = mask(1,1)*one_zero(i-1,j-1) + mask(1,2)*one_zero(i-1,j) + mask(1,3)*one_zero(i-1,j+1) + ...
                mask(2,1)*one_zero(i,j-1) + mask(2,2)*one_zero(i,j) + mask(2,3)*one_zero(i,j+1) + ...
                mask(3,1)*one_zero(i+1,j-1) + mask(3,2)*one_zero(i+1,j) + mask(3,3)*one_zero(i+1,j+1);
        %Erosion demands that all the pixels of the mask match the ones of
        %the picture
        if (score == numel(mask))      %whole mask matched  %edw yphrxe 255*numel..!!
            C(i,j) = 255;              %foreground (object) color
        else
            C(i,j) = 0;  %background (white) color
%         else       %WTF!? 
%             score                        %0 or 255 only ...
%             mask                         %all 1...
%             one_zero(i-1:i+1, j-1:j+1)   %all 255 sometimes...
%             pause()                      %but score = 255 instead of 9*255
        end
        
    end
end

C(find(C==1)) = 255; %not necessary 

%finally output image C follows the initial coloring scheme: 
%0 for object and 1 for the background
end