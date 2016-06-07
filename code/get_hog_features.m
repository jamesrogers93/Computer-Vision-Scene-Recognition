function [HOG_features, locations, dim, img] = get_hog_features(img, colour_space, cell_size)

    switch lower(colour_space)

        case 'grayscale'
            %Convert to greyscale and single
            img = single(rgb2gray(img));
            
            %Get HOG features
            hog_features = vl_hog(img, cell_size);

            %2x2 neighbour stack features for denser descriptors
            HOG_features = get_HOG_2x2_neighbours(hog_features);
            
            %Create locations matrix
            locations = get_locations(HOG_features);
            locations = reshape(locations,[],size(locations,3),1)';
            
            %Set dimensions
            [x, y, ~] = size(HOG_features);
            dim(1) = x;
            dim(2) = y;
            
            %Reshape 3D matrix to 2D so that the cells are aligned along the 
            % columns, and the feature data is aligned down the rows
            HOG_features = reshape(HOG_features,[],size(HOG_features,3),1)';
        
        case 'rgb'
            %Convert to single
            img = single(img);
            
            %Get HOG features for each channel
            HOG_features_R = vl_hog(img(:, :, 1), cell_size);
            HOG_features_G = vl_hog(img(:, :, 2), cell_size);
            HOG_features_B = vl_hog(img(:, :, 3), cell_size);

            %2x2 neighbour stack features for denser descriptors
            % for each channel
            HOG_features_R = get_HOG_2x2_neighbours(HOG_features_R);
            HOG_features_G = get_HOG_2x2_neighbours(HOG_features_G);
            HOG_features_B = get_HOG_2x2_neighbours(HOG_features_B);
            
            %Create locations matrix
            locations = get_locations(HOG_features_R);
            locations = reshape(locations,[],size(locations,3),1)';
            locations = cat(2, locations, locations, locations);
            
            %Set dimensions
            [x, y, ~] = size(HOG_features_R);
            dim(1) = x;
            dim(2) = y;
            
            %Reshape 3D matrix to 2D so that the cells are aligned along the 
            % columns, and the feature data is aligned down the rows
            HOG_features_R = reshape(HOG_features_R,[],size(HOG_features_R,3),1)';
            HOG_features_G = reshape(HOG_features_G,[],size(HOG_features_G,3),1)';
            HOG_features_B = reshape(HOG_features_B,[],size(HOG_features_B,3),1)';
            
            %Concatonate features into one matrix
            HOG_features = cat(2, HOG_features_R,HOG_features_G, HOG_features_B);
    end
end

function HOG_2x2_features = get_HOG_2x2_neighbours(HOG_features)

    %Get dimensions of hog matrix
    [x, y, ~] = size(HOG_features);
    
    %Initalise HOG feature matrix
    HOG_2x2_features = zeros(x,y,124);

    %Stack 4 neighbours on top of each other
    for r = 1 : x - 1
       for c = 1 : y - 1

           %Get HOG features from neighbours
           hog_feat_1 = HOG_features(r, c, :);
           hog_feat_2 = HOG_features(r+1, c, :);
           hog_feat_3 = HOG_features(r, c+1, :);
           hog_feat_4 = HOG_features(r+1, c+1, :);

           %Concatonate the neighbours into 1 matrix
           HOG_2x2_features(r, c, :) = cat(3, hog_feat_1, hog_feat_2, hog_feat_3, hog_feat_4);
        end
    end
end

function locations = get_locations(HOG_features)

    %Create locations
    [x, y, ~] = size(HOG_features);
    locations = zeros(x, y, 2);
    for r = 1 : x
       for c = 1 : y
           locations(r, c, 1) = r;
           locations(r, c, 2) = c;
       end
    end
end

