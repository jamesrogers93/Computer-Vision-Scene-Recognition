function image_feats = get_spatial_pyramids_hog( image_paths, cell_size, normalise, smoothing, bin_size, magnif, levels, colour_space)

%% Initalise variables

    vocab = load('vocab_hog.mat');
    vocab = vocab.vocab;
    n = length(image_paths);
    [d, ~] = size(vocab);

    %Initalise image_feats matrix
    total_num_bins = 0;
    for i = 0 : levels
       total_num_bins = total_num_bins + 4^(i);
    end
    image_feats = zeros(n, d * total_num_bins);

    %% 

    parfor i = 1 : n

        %Open Image
        img = imread(char(image_paths(i)));
        
        %Smooth the image
        if smoothing
            img = vl_imsmooth(img, sqrt((bin_size / magnif)^2 -0.25));
        end
        
        %Get spatial pyramid features
        hist = get_spatial_pyramid_hog_features(img, vocab, d, cell_size, levels, total_num_bins, colour_space);

        %Put histogram in image feats
        image_feats(i, :) = hist';  
    end

    %Normalize image_feats as number of features in each image is different
    if normalise
        image_feats = normr(image_feats);
    end

end