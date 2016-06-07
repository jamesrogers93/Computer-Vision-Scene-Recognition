function vocab = build_vocabulary_hog( image_paths, vocab_size, cell_size, smoothing, bin_size, magnif, colour_space)

%% Initalise variables
    
    %Get the number of images
    n = size(image_paths, 1);
    
    %Initalise matrix of n
    image_feats = zeros(124, 0);
    
%% Get SIFT features of all images
      
    %Loop over all of the images
    for i = 1 : n

        %Open Image
        img = imread(char(image_paths(i)));
        
        %Smooth the image
        if smoothing
            img = vl_imsmooth(img, sqrt((bin_size / magnif)^2 -0.25));
        end
        
        %Get HOG features
        [HOG_features, ~, ~, ~] = get_hog_features(img, colour_space, cell_size);
        
        %Attach matrix to sift_feats
        image_feats = cat(2, image_feats, HOG_features);
         
    end
    
%% Calculate K-means clustering

    %Calculate centroids
   [vocab, ~] = vl_kmeans(single(image_feats), vocab_size);
   
   %Transpose Vocab matrix
   vocab = vocab';
   
end