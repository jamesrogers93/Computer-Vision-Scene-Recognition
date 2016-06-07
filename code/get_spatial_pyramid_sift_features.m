function image_feats = get_spatial_pyramid_sift_features( img, vocab, d, step, levels, total_num_bins, colour_space)

    %Initalise feature vector to size of vocab size x total number of bins
    image_feats = zeros(1, d * total_num_bins);
    
    %Previous index is initalised to the first element in the vector
    prev_index = 1;
    
    %Use dsift to get sift features and compute distances
    [locations, SIFT_features, img] = get_sift_features(img, colour_space, step);
    D = vl_alldist2(single(SIFT_features), vocab');
    [~,I] = min(D,[],2);

    %Loop over all levels
    for L = 0 : levels
        
        %Get number of bins of current level
        num_bins = 4^L;
        
        if L == 0
            %Calculate weighted increment value
            inc = 0.25;
            
            %Find number of bins across dimension
            bins_per_dim = 1;
        else
            %Calculate weighted increment value
            inc = L * 0.25;
            
            %Find number of bins across dimension
            bins_per_dim = L * 2;
        end
        
        %Get bin dimensions
        switch lower(colour_space)
            case 'grayscale'
                [bin_width, bin_height] = size(img);
            otherwise
                [bin_width, bin_height, ~] = size(img);
        end
        
        bin_width = floor(bin_width  / bins_per_dim);
        bin_height = floor(bin_height / bins_per_dim);
        
        %Loop over all features
        for i = 1 : length(I)
            
            %Get correct bin index
            index = prev_index;
            
            %Get sift location
            feat_loc_r = locations(1, i);
            feat_loc_c = locations(2, i);
            
            %Set flag to break out of nested for loop when bin has been
            % found
            flag = 0;
            
            %Find which bin feat location falls in
            for r = 1 : bins_per_dim
                
                %Get indices of bin along the row
                r_end = r * bin_width;
                r_start = r_end - bin_width + 1;
                
                for c = 1 : bins_per_dim
                    
                    %Get indices of bin along the column
                    c_end = c * bin_height;
                    c_start = c_end - bin_height + 1;
                    
                    %Check if feature location falls inside indices
                    if feat_loc_r >= r_start && feat_loc_r < r_end
                        if feat_loc_c >= c_start && feat_loc_c < c_end
                            
                            %Point falls in this space
                            
                            %Get histogram index
                            start_hist_idx = index * d - d;
                            hist_idx = start_hist_idx + I(i);
                            
                            %increment histogram index
                            image_feats(1, hist_idx) = image_feats(1, hist_idx) + inc;
                            
                            %Now that correct section has been found, break
                            % out of nested for loop
                            flag = 1;
                            break;
                        end
                    end
                    
                    %Increment index along histogram
                    index = index + 1; 
                end
                
                %Break out of loop if flag has been set
                if flag
                    break;
                end
            end
        end
       
        %Set previous index for the next level
        prev_index = prev_index + num_bins; 
    end
end

