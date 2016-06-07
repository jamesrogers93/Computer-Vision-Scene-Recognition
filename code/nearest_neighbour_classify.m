function predicted_categories = nearest_neighbour_classify (train_image_feats, train_labels, test_image_feats, k, DISTANCE_METRIC)
    
    %Pre calculate size of test and train matricies
    n = size(test_image_feats, 1);
    
    %Initalise predicted cell vector
    predicted_categories = cell(n,1);
    
    %Loop over all of the test data
    parfor i = 1 : n
       
        %Get test image
        test_img = test_image_feats(i,:);
        
        %Find distance between this image and all images in training
        diff = zeros(n, 1);
        for j = 1 : n
            diff(j, 1) = pdist2(test_img, train_image_feats(j, :), DISTANCE_METRIC);
        end
        
        %Sort differences into acending order
        % ind = new column vector containing previous indicies
        [~, ind] = sort(diff);
        
        %Get the k-nn categories
        cats = train_labels(ind(1:k));
        
        %Find most common category.
        %If there are an equal number of votes, the first will be picked
        [unique_cats, ~, cat_map]=unique(cats);
        most_common_cat=unique_cats(mode(cat_map));
        
        %Store prediction in predicted_categories
        predicted_categories(i) = most_common_cat;

    end

end