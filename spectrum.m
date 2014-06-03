function S = spectrum(targets, dataset, num_similar, mask)

perc = 0.95;     % pososto pou xrisimopoihte gia to rotate tis eikonas
shift_i = 100;   % metavlites metatopisis tis eikonas 
iters = 10;      % 10 closings, 10 openings
num_dataset = length(dataset);  %number of all the pictures (100)
num_targets = length(targets);  %number of pictures to be searched (10)

%make a 100x(iters+1) vector that:
%holds the spectrums(sum of black(foreground) pixels) for each image
%after each opening , closing and the initial snapshot in the middle position
spectrums = zeros(num_dataset, 2*iters +1);

%% for every picture calculate its spectrum and store it to the
%  corresponding row of spectrums array.
for i=1:num_dataset
    
    %firstly we open the i-th image of our interest
    im = dataset{i};
    
    % Opening
    [w spectrums(i, 1:iters)] = my_opening(im, mask, iters);
    
    %initial image in the middle
    spectrums(i, iters+1) = length(find(im == 255)); %spectrum of im (#white_pixels)
    
    % Closing
    [w spectrums(i, iters+2:(2*iters)+1)] = my_closing(w, mask, iters);
    
    %so at this point a single row of spectrums' array has the following structure:
    %[open1 open2 ... open10 initial_image close1 close2 ... close10]   
end


%% For each picture of our interest (ids stored in targets) calculate the
%  euclidean distance from the rest of the num_similar-1 (99) pictures
% and store its value (distance - a float) into the corresponding
% cell(column), so that if input image is id:5 the distance(5,1) holds the
% distance value between spectrum(5,:) and spectrum(1,:), distance(5,5) is 0 etc...
% Thus distances' rows are parallel associated with targets array
distances = zeros(num_targets, num_dataset);    %9x100

for i=1: num_targets               %i = 1 to 10
    for j=1:num_dataset            %j = 1 to 100
        if j ~= targets(i)         %dont compare with ourself doesnt matter cause result will be 0 
            distances(i, j) = euclidean_distance(spectrums(targets(i)), spectrums(j));
        end
    end
end


%% S structure: every row (i,:) contains the ids of num_similar(9) most 
%similar pictures for picture i . Thus S is (num_targets x num_similar) aka (9x9)
S = zeros(num_targets, num_similar);
for i=1: num_targets
    %sort each line that contains the distances from each picture and get
    %their values(not_used) and their initial positions(column) which is
    %what we want since it represents their id
    [values, positions] = sort(distances(i,:), 'ascend');
  
    %Get the num_similar(10) closer pictures (ids) but exclude the 1st one
    %cause it is itself.
    S(i,:) = positions(2:num_similar+1);
end
%carefull: S holds the id's of the most similar pictures, not the image 
%arrays themselves
        
    


