function write_results(output_base_dir, filetype, dataset, S, targets, num_similar, folder)

%% S structure: every row (i,:) contains the ids of num_similar(10) most 
%similar pictures for picture i . Thus S is (num_targets x num_similar) aka (10x10)

num_targets = length(targets);    

%%Create the output directory
out_path = strcat(output_base_dir, folder);
status = mkdir(out_path);
if status == 0
    print "Error creating output directory: results. Ensure that the user ...
        executing the program holds the appropriate permissions";
end

for i=1:num_targets
    
    %Firstly write the target(i) image (e.g 5.pgm)
    target_im = dataset{ targets(i) };
    %already binary just reverse it to initial scheme. Reverse is local
    %so the dataset is not altered in the main program
    target_im = quantize_and_reverse(target_im);
    %create the full filaname and write to dsik
    filename = strcat(out_path, num2str(targets(i)), '.', filetype);
    imwrite(target_im, filename, filetype);
    
    %then write the num_similar(10) associated pictures named like
    %this: 5_1.pgm, 5_2.pgm ... 5_10.pgm
    for j=1:num_similar
        im = dataset{ S(i,j) };
        im = quantize_and_reverse(im);  %already binary just reverse it to initial scheme
        filename = strcat(out_path, num2str(targets(i)), '_', num2str(j), ...
            '_', num2str(S(i,j)), '.', filetype);
        imwrite(im, filename, filetype);
    end
end


 