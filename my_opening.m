function [w spectrum] = my_opening(im, mask, iters)

%% for each image create the spectrum array 
spectrum = zeros(1,iters);

w = erose(im, mask);
w = dilate(w, mask);
spectrum(1)=length(find(w==255));

for i=2:iters
    w = erose(w, mask);
    w = dilate(w, mask);
    spectrum(i)=length(find(w==255));
end
