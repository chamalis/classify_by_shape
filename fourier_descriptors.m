function [F_coords, F_angle] = fourier_descriptors(targets, dataset, num_similar, mask)

%% Parameters 

%to change parameters:
num_coef = 200;

%constant parameters
num_dataset = length(dataset);
num_targets = length(targets);


%% Arrays
magnitudes = zeros(num_dataset, num_coef);
magnitudes_norm = zeros(num_dataset, num_coef-2);
%magnitudes_kept = zeros(num_dataset, num_coef-2-ceil(num_coef/4));
boundaries = cell(1, num_dataset);
Z = zeros(num_dataset, num_coef); 

%% For each image do the following: %%
for i=1:num_dataset
    

    %% 1. Find the boundary of the image.
    b = boundary(dataset{i}, mask);

    %% 2. Convert the x, y coordinates in the contour to a one-dimensional vector
    %  by treating them as a complex pair. That is: U(n) = X(n) + i * Y(n).
    
    %U = follow_boundary(b)  %U(n) = x(n) + y(n)  %our attempt failed due
    %to fuzzy path returned from boundary (contourc techique)
    
    [x0, y0] = find_a_starting_point(b);
    P = bwtraceboundary(b, [x0, y0], 'N', 8, Inf, 'clockwise');
    boundaries{1, i} = P;  %for later use (2nd fourier approach)
   % P = B{1};  %1st object (the only one)
    num_BP = size(P,1);
    
    U = zeros(num_BP, 1);
    U(:) = P(:,1) + P(:,2)*1j;
    U = U';  %1xnum_BP
    
    if(num_coef > num_BP)
        disp('Too many fourier coefficients for this dataset');
        return;
    end
    Z(i, :) = fft(U(:), num_coef);
    
    for j=1: num_coef
        magnitudes(i, j) = sqrt( real(Z(i,j))^2 + imag(Z(i,j))^2 );
    end
    magnitudes(i, :);
    
    %normalize
    magnitudes_norm(i,:) = magnitudes(i,3:num_coef)./(magnitudes(i,2));
    %magnitudes_kept(i,:) = magnitudes_norm(i, 1: num_coef-2-ceil(num_coef/4));
end

%% For each picture of our interest (ids stored in targets) calculate the
%  euclidean distance from the rest of the (99) pictures
% and store its value (distance - a float) into the corresponding
% cell(column), so that if input image is id:5 the distance(5,1) holds the
% distance value between spectrum(5,:) and spectrum(1,:), distance(5,5) is 0 etc...
% Thus distances' rows are parallel associated with targets array
distances = zeros(num_targets, num_dataset);    %10x100

for i=1: num_targets               %i = 1 to 9
    for j=1:num_dataset            %j = 1 to 100
        %if j ~= targets(i)        %dont compare with ourself dont care result is 0 either way
            distances(i, j) = euclidean_distance(magnitudes_norm(targets(i)), magnitudes_norm(j));
        %end
    end
end


%% S structure: every row (i,:) contains the ids of num_similar(9) most 
%similar pictures for picture i . Thus S is (num_targets x num_similar) aka (9x9)
F_coords = zeros(num_targets, num_similar);
for i=1: num_targets
    %sort each line that contains the distances from each picture and get
    %their values(not_used) and their initial positions(column) which is
    %what we want since it represents their id
    [values, positions] = sort(distances(i,:), 'ascend');
  
    %Get the num_similar(9) closer pictures (ids) but exclude the 1st one
    %cause it is itself.
    F_coords(i,:) = positions(2:num_similar+1);  % (2:num_similar+1);
end
%carefull: F holds the id's of the most similar pictures, not the image 
%arrays themselves



%% 2.2 Fourier - angle %%

% For each image do the following: 
for i=1:num_dataset
    
    P = boundaries{1,i};  
    num_BP = size(P,1);
 
    th = zeros(1, num_BP);  z = zeros(1, num_BP);    
    for j=1: num_BP-1
        x = P(j,1);          y=P(j,2);
        nextx = P(j+1,1);    nexty=P(j+1,2);
        
        if nextx > x
            if nexty >y
                th(j) = 7*pi/4;
            elseif nexty <y
                th(j) = 5*pi/4;
            else
                th(j) = 6*pi/4;
            end
        elseif nextx < x
            if nexty >y
                th(j) = pi/4;
            elseif nexty <y
                th(j) = 3*pi/4;
            else
                th(j) = 2*pi/4;
            end
        else
            if nexty > y
                th(j) = 0;
            else
                th(j) = pi;
            end
        end
        
        z(j) = th(j) - 2*pi*j / num_BP;  %meaningless if we consider the derivative!
    end
            
%         th(j) = abs(P(j,2)-P(j+1,2)) / abs(P(j,1)-P(j+1,1));  %tan

    dth = zeros(1, num_BP);
    for j =1:num_BP-1
        dth(j) = z(j+1) - z(j);  %same as th(j+1) - th(j)
    end
    dth(num_BP) = z(1) - z(num_BP);
    dth = dth - 2*pi*(dth>pi);  %relative angle (e.g 0, then 7pi/8 -> -pi/8)
    dth = dth + 2*pi*(dth<-pi);  
    
%     disp('dth')
%     printmat(dth(1:14))
%     pause()
    
    Z(i, :) = fft(dth, num_coef);

%     disp('Z (fourier) ')
%     printmat(Z(i,1:14))
%     pause()

    magnitudes(i,:) = abs(Z(i,:));

%     disp('magnitudes')
%     printmat(magnitudes(i,:))
%     pause()
    
    %normalize
    magnitudes_norm(i,:) = magnitudes(i,3:num_coef)./(magnitudes(i,2));
    %magnitudes_kept(i,:) = magnitudes_norm(i, 1: num_coef-2-ceil(num_coef/4));
end


%% For each picture of our interest (ids stored in targets) calculate the
%  euclidean distance from the rest of the (99) pictures
% and store its value (distance - a float) into the corresponding
% cell(column), so that if input image is id:5 the distance(5,1) holds the
% distance value between spectrum(5,:) and spectrum(1,:), distance(5,5) is 0 etc...
% Thus distances' rows are parallel associated with targets array
distances = zeros(num_targets, num_dataset);    %10x100

for i=1: num_targets               %i = 1 to 9
    for j=1:num_dataset            %j = 1 to 100
        %if j ~= targets(i)        %dont compare with ourself dont care result is 0 either way
        distances(i, j) = euclidean_distance(magnitudes_norm(targets(i)), magnitudes_norm(j));
        %end
    end
end


%% F structure: every row (i,:) contains the ids of num_similar(9) most 
%similar pictures for picture i . Thus F is (num_targets x num_similar) aka (9x9)
F_angle = zeros(num_targets, num_similar);
for i=1: num_targets
    %sort each line that contains the distances from each picture and get
    %their values(not_used) and their initial positions(column) which is
    %what we want since it represents their id
    [values, positions] = sort(distances(i,:), 'ascend');
  
    %Get the num_similar(9) closer pictures (ids) but exclude the 1st one
    %cause it is itself.
    F_angle(i,:) = positions(2:num_similar+1);% (2:num_similar+1);
end
%carefull: F holds the id's of the most similar pictures, not the image 
%arrays themselves

