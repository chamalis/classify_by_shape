function I = quantize_and_reverse(im)

%Quantization to binary image and reversing foreground/background color 
%If the image is already binary then it's just reversed the same way. 
I = im;
I(find(I > 0))  = 1;
I(find(I == 0)) = 255;
I(find(I == 1)) = 0;
