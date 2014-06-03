%% Machine Vision - Project 2 - Shape Recognition %%
%% December 2013 %%
%% author: Stelios Barberakis - chefarov@gmail.com %%

%% Main file - Runner
clear all;
close all;
clc;

%% Parameters
dataset_dir = 'Dataset/';
output_dir = 'results/';
targets = [1 13 27 36 43 54 66 79 89];     %Oi 10 eikones pou tha psaksoume
num_dataset=100;                           %Me poses tha sigrinoume mesa sto fakelo
num_similar = 9;                           %how many pictures to keep as similar
filetype = 'pgm';
mask = [1 1 1; 1 1 1; 1 1 1];   %erode/dilation operator

%% Create the output directory
status = mkdir(output_dir);
if status == 0
    print "Error creating output directory: results. Ensure that the user ... 
           executing the program holds the appropriate permissions";
end

%% Preprocess the dataset, making the images binary 
% (0-black(foreground) / 255-white(background)), and storing them in a data
% collection (dataset) so that we don't have to reopen them each time.
% Time complexity falls but we have huge RAM demands (hundreds of MB)
dataset = preprocess(dataset_dir, filetype, num_dataset);


%% Ektelesi tis pattern spectrum gia oles tis eikones kai epistrofi enos
% dianysmatos num_similar x num_similar (9x9)
% opou se kathe (i,:) einai oi omoies eikones pou epilexthikan
% gia kathe eikona(i). H apodosi ypologizetai apo to
% xristi explicitly me elegxo dias8itika me tis eikonesp ou blepei sto fakelo
S = spectrum(targets, dataset, num_similar, mask);
write_results(output_dir, filetype, dataset, S, targets, num_similar, 'spectrum/');


%% Finding the similarity matrix based on fourier descriptors technique
[F_coords, F_angle] = fourier_descriptors(targets, dataset, num_similar, mask);
write_results(output_dir, filetype, dataset, F_coords, targets, num_similar, 'fourier_coords/');
write_results(output_dir, filetype, dataset, F_angle,  targets, num_similar, 'fourier_angle/');


%% SCALE and repeat the process 

%firstly build the appropriate dataset where the target images are  scaled
%and the rest are intact (initial form).
dataset_scaled = cell(1, num_dataset);
for i=1:num_dataset
    if any(targets == i) %if i exists in targets array
        dataset_scaled{i} = imresize(dataset{i}, 0.5);
    else                 %just copy the image from the existing dataset
        dataset_scaled{i} = dataset{i};
    end
end

%Then repeat the spectrum and fourier processes

S_scaled = spectrum(targets, dataset_scaled, num_similar, mask);
write_results(output_dir, filetype, dataset_scaled, S_scaled, targets, num_similar, 'spectrum_scaled/');

[F_coords_scaled, F_angle_scaled] = fourier_descriptors(targets, dataset, num_similar, mask);
write_results(output_dir, filetype, dataset_scaled, F_coords_scaled, targets, num_similar, 'fourier_coords_scaled/');
write_results(output_dir, filetype, dataset_scaled, F_angle_scaled,  targets, num_similar, 'fourier_angle_scaled/');


%% ROTATE and repeat the process

%firstly build the appropriate dataset where the target images are  rotated
%and the rest are intact (initial form).
dataset_rotated = cell(1, num_dataset);
for i=1:num_dataset
    if any(targets == i) %if i exists in targets array
        dataset_rotated{i} = imrotate(dataset{i}, 90);
    else                 %just copy the image from the existing dataset
        dataset_rotated{i} = dataset{i};
    end
end

%Then repeat the spectrum and fourier processes

S_rotated = spectrum(targets, dataset_rotated, num_similar, mask);
write_results(output_dir, filetype, dataset_rotated, S_rotated, targets, num_similar, 'spectrum_rotated/');

[F_coords_rotated, F_angle_rotated] = fourier_descriptors(targets, dataset, num_similar, mask);
write_results(output_dir, filetype, dataset_rotated, F_coords_rotated, targets, num_similar, 'fourier_coords_rotated/');
write_results(output_dir, filetype, dataset_rotated, F_angle_rotated,  targets, num_similar, 'fourier_angle_rotated/');
