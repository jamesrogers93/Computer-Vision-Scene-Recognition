function [locations, SIFT_features, img] = get_sift_features(img, colour_space, step)

    switch lower(colour_space)

        case 'grayscale'
            %Convert RGB image to Grayscale
            img = single(rgb2gray(img));
            
            %Use dsift to get sift features
            [locations, SIFT_features] = vl_dsift(img, 'step', step, 'size', 4);
        case 'rgb'
            %Do not convert colour space as image loaded is already RGB

            %Convert image to single
            img = single(img);
            
            %Use dsift to get sift features for R, G and B channels
            [locations_r, SIFT_features_r] = vl_dsift(img(:, :, 1), 'step', step); 
            [locations_g, SIFT_features_g] = vl_dsift(img(:, :, 2), 'step', step); 
            [locations_b, SIFT_features_b] = vl_dsift(img(:, :, 3), 'step', step); 
            
            %Concatonate features into one matrix
            SIFT_features = cat(2, SIFT_features_r, SIFT_features_g, SIFT_features_b);
            locations = cat(2, locations_r, locations_g, locations_b);
            
        case 'hsv'
            %Convert image to hsv, then single
            img = single(rgb2hsv(img));
            
            %Use dsift to get sift features for R, G and B channels
            [locations_h, SIFT_features_h] = vl_dsift(img(:, :, 1), 'step', step); 
            [locations_s, SIFT_features_s] = vl_dsift(img(:, :, 2), 'step', step); 
            [locations_v, SIFT_features_v] = vl_dsift(img(:, :, 3), 'step', step); 
            
            %Concatonate features into one matrix
            SIFT_features = cat(2, SIFT_features_h, SIFT_features_s, SIFT_features_v);
            locations = cat(2, locations_h, locations_s, locations_v);
            
        case 'hue'
            %Convert image to gray, then single
            img = single(rgb2gray(img));
            
            %Use dsift to get sift features
            [locations, SIFT_features] = vl_dsift(img, 'step', step); 
            
        case 'opponent'
            
            %Convert to double
            img = im2double(img);
            
            %extract each channel
            R  = img(:,:,1);
            G  = img(:,:,2);
            B  = img(:,:,3);

            %Normalise RGB
            R1 = R./mean2(R);
            G1 = G./mean2(G);
            B1 = B./mean2(B);
            
            %convert to opponent space
            o1 = im2single((R1-G1)./sqrt(2));
            o2 = im2single((R1+G1-2*B1)./sqrt(6));
            o3 = im2single((R1+G1+B1)./sqrt(3));
            
            %Use dsift to get sift features for R, G and B channels
            [locations_o1, SIFT_features_o1] = vl_dsift(o1, 'step', step); 
            [locations_o2, SIFT_features_o2] = vl_dsift(o2, 'step', step); 
            [locations_o3, SIFT_features_o3] = vl_dsift(o3, 'step', step); 
            
            %Concatonate features into one matrix
            SIFT_features = cat(2, SIFT_features_o1, SIFT_features_o2, SIFT_features_o3);
            locations = cat(2, locations_o1, locations_o2, locations_o3);
        case 'w'
            
            %Convert to to double
            img = im2double(img);
            
            %extract each channel
            R  = img(:,:,1);
            G  = img(:,:,2);
            B  = img(:,:,3);
            
            %Locally Normalise RGB
            R1 = R./mean2(R);
            G1 = G./mean2(G);
            B1 = B./mean2(B);
            
            %convert to opponent space
            o1 = (R1-G1)./sqrt(2);
            o2 = (R1+G1-2*B1)./sqrt(6);
            o3 = (R1+G1+B1)./sqrt(3);
            
            o1 = im2single(o1./o3);
            o2 = im2single(o2./o3);
            o3 = im2single(o3);
            
            %Use dsift to get sift features for R, G and B channels
            [locations_o1, SIFT_features_o1] = vl_dsift(o1, 'step', step); 
            [locations_o2, SIFT_features_o2] = vl_dsift(o2, 'step', step); 
            [locations_o3, SIFT_features_o3] = vl_dsift(o3, 'step', step); 
            
            %Concatonate features into one matrix
            SIFT_features = cat(2, SIFT_features_o1, SIFT_features_o2, SIFT_features_o3);
            locations = cat(2, locations_o1, locations_o2, locations_o3);
        case 'rg'
            
            %Convert to to double
            img = im2double(img);

            %extract each channel
            R  = img(:,:,1);
            G  = img(:,:,2);
            B  = img(:,:,3);
            
            %Normalise RGB
            R1 = im2single(R./R+G+B);
            G1 = im2single(G./R+G+B);
            
            %Use dsift to get sift features for R, G and B channels
            [locations_R, SIFT_features_R] = vl_dsift(R1, 'step', step); 
            [locations_G, SIFT_features_G] = vl_dsift(G1, 'step', step);
            
            %Concatonate features into one matrix
            SIFT_features = cat(2, SIFT_features_R, SIFT_features_G);
            locations = cat(2, locations_R, locations_G);
    end
end

