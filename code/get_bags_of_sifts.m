% Implementated according to the starter code prepared by James Hays, Brown University
% Michal Mackiewicz, UEA, March 2015

function image_feats = get_bags_of_sifts(image_paths, step, normalise, smoothing, bin_size, magnif, colour_space)
% image_paths is an N x 1 cell array of strings where each string is an
% image path on the file system.

% This function assumes that 'vocab.mat' exists and contains an N x 128
% matrix 'vocab' where each row is a kmeans centroid or visual word. This
% matrix is saved to disk rather than passed in a parameter to avoid
% recomputing the vocabulary every time at significant expense.

% image_feats is an N x d matrix, where d is the dimensionality of the
% feature representation. In this case, d will equal the number of clusters
% or equivalently the number of entries in each image's histogram.

% You will want to construct SIFT features here in the same way you
% did in build_vocabulary.m (except for possibly changing the sampling
% rate) and then assign each local feature to its nearest cluster center
% and build a histogram indicating how many times each cluster was used.
% Don't forget to normalize the histogram, or else a larger image with more
% SIFT features will look very different from a smaller version of the same
% image.

%{
Useful functions:
[locations, SIFT_features] = vl_dsift(img) 
 http://www.vlfeat.org/matlab/vl_dsift.html
 locations is a 2 x n list list of locations, which can be used for extra
  credit if you are constructing a "spatial pyramid".
 SIFT_features is a 128 x N matrix of SIFT features
  note: there are step, bin size, and smoothing parameters you can
  manipulate for vl_dsift(). We recommend debugging with the 'fast'
  parameter. This approximate version of SIFT is about 20 times faster to
  compute. Also, be sure not to use the default value of step size. It will
  be very slow and you'll see relatively little performance gain from
  extremely dense sampling. You are welcome to use your own SIFT feature
  code! It will probably be slower, though.

D = vl_alldist2(X,Y) 
   http://www.vlfeat.org/matlab/vl_alldist2.html
    returns the pairwise distance matrix D of the columns of X and Y. 
    D(i,j) = sum (X(:,i) - Y(:,j)).^2
    Note that vl_feat represents points as columns vs this code (and Matlab
    in general) represents points as rows. So you probably want to use the
    transpose operator '  You can use this to figure out the closest
    cluster center for every SIFT feature. You could easily code this
    yourself, but vl_alldist2 tends to be much faster.
%}

%% Initalise variables

    vocab = load('vocab_sift.mat');
    vocab = vocab.vocab;
    n = length(image_paths);
    [d, ~] = size(vocab);

    image_feats = zeros(n, d);
    image_feats_hue = zeros(n, 8);
    %% 

    parfor i = 1 : n

        %Open Image
        img = imread(char(image_paths(i)));

        %Smooth the image
        if smoothing
            img = vl_imsmooth(img, sqrt((bin_size / magnif)^2 -0.25));
        end

        [~, SIFT_features, ~] = get_sift_features(img, colour_space, step);

        %Compute distances between sift features and words in vocab
        D = vl_alldist2(single(SIFT_features), vocab');

        %Get the minimum distance indices from each word
        [~,I] = min(D,[],2);

        %Create a 2D histogram of the closest words
        hist = accumarray(I, 1, [d 1])';
        
        %Put histogram in image feats
        image_feats(i, :) = hist;  
        
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


