function dataset = preprocess(read_dir, filetype, number_of_images)

%Make a collection to store the images for later usage. RAM KILLER
imcell = cell(1, number_of_images);
for i = 1:number_of_images
    
    filename = strcat(read_dir, num2str(i));
    filename = strcat(filename, '.', filetype);
    
    im = imread(filename);
    
    %now make the image binary - where not black(not 0) take the value 255
    %and REVERSE the array making 0(foreground)->255 and 255(background) -> 0
    %so that since now white is the object(foreground) and black is the
    %background
    im = quantize_and_reverse(im);
        
    imcell{1, i} = im;
    
end

dataset = imcell;