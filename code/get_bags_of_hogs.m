function image_feats = get_bags_of_hogs(image_paths, cell_size, normalise, smoothing, bin_size, magnif, colour_space)

%% Initalise variables

    vocab = load('vocab_hog.mat');
    vocab = vocab.vocab;
    n = length(image_paths);
    [d, ~] = size(vocab);

    image_feats = zeros(n, d);

%% 

    parfor i = 1 : n

        %Open Image
        img = imread(char(image_paths(i)));

        %Smooth the image
        if smoothing
            img = vl_imsmooth(img, sqrt((bin_size / magnif)^2 -0.25));
        end
        
        %Get the HOG features
        [HOG_features, ~, ~, ~] = get_hog_features(img, colour_space, cell_size);
        
        %Compute distances between sift features and words in vocab
        D = vl_alldist2(single(HOG_features), vocab');

        %Get the minimum distance indices from each word
        [~,I] = min(D,[],2);

        %Create a 2D histogram of the closest words
        hist = accumarray(I, 1, [d 1])';

        %Put histogram in image feats
        image_feats(i, :) = hist;  
    end

    %Normalize image_feats as number of features in each image is different
    if normalise
        image_feats = normr(image_feats);
    end
end

