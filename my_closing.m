function [w spectrum] = my_closing(im, mask, iters)

%% for each image create the spectrum array 
spectrum = zeros(1,iters);

w = dilate(im, mask);
w = erose(w, mask);
spectrum(1)=length(find(w==255));

for i=2:iters
    w = dilate(w, mask);
    w = erose(w, mask);
    spectrum(i)=length(find(w==255));
end
