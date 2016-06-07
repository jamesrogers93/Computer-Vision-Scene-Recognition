function image_feats = get_spatial_pyramids_sift( image_paths, step, normalise, smoothing, bin_size, magnif, levels, colour_space)

%% Initalise variables

    vocab = load('vocab_sift.mat');
    vocab = vocab.vocab;
    n = length(image_paths);
    [d, ~] = size(vocab);

    %Initalise image_feats matrix
    total_num_bins = 0;
    for i = 0 : levels
       total_num_bins = total_num_bins + 4^(i);
    end
    image_feats = zeros(n, d * total_num_bins);
    image_feats_hue = zeros(n, 8);

    %% 

    parfor i = 1 : n

        %Open Image
        img = imread(char(image_paths(i)));
        
        %Smooth the image
        if smoothing
            img = vl_imsmooth(img, sqrt((bin_size / magnif)^2 -0.25));
        end
        
        %Get spatial pyramid features
        hist = get_spatial_pyramid_sift_features(img, vocab, d, step, levels, total_num_bins, colour_space);

        %Put histogram in image feats
        image_feats(i, :) = hist';  
        
        %Append Hue histogram if colour space is hueSIFT
        if strcmp('hue', colour_space)
            hue_hist = get_hue_histogram(img);
            image_feats_hue(i, :) = hue_hist;  
        end
    end

    %Normalize image_feats as number of features in each image is different
    if normalise
        image_feats = normr(image_feats);
    end
    
    %Append hue histogram onto SIFT histogram
    if strcmp('hue', colour_space)
        image_feats = cat(2, image_feats, image_feats_hue); 
    end

end