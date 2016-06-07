function image_feats = get_tiny_images (image_paths, dimension, colour_space)
    
    %Initalise size of matrix column dimension
    switch lower(colour_space)
        case 'grayscale'
            d = dimension*dimension;
        otherwise
            d = dimension*dimension*3;
    end
    
    %Get the number of images
    n = size(image_paths, 1);
    
    %Initalise matrix of n x d
    image_feats = zeros(n, d);

    %Loop over all of the images
    parfor i = 1 : n

        %Open Image
        img = imread(char(image_paths(i)));
        
        %Resize image
        img = imresize(img, [dimension dimension]);

        %Convert to specified colour space (if rgb specified, no 
        % conversion needed)
        switch lower(colour_space)
            case 'grayscale'
                img = rgb2gray(img);
            case 'ycbcr'
                img = rgb2ycbcr(img);
            case 'hsv'
                img = rgb2hsv(img);
        end
        
        %Zero mean
        img = double(img)-mean(double(img(:)));

        %Normalise
        img = mat2gray(img);
        
        %Vertorise and put image in image_feats matrix
        image_feats(i, :) = reshape(img, d, 1);
 
    end
          
end