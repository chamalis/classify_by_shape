function B = boundary(im, mask)

%% Implementing contourc technique %%
erosed = erose(im, mask);
B = double(im) - double(erosed);
