function image_feats = get_colour_histograms(image_paths, dim, quant, colour_space)
            
    %Get the number of images
    n = size(image_paths, 1);
    
    %Initalise matrix of n x quant*quant*quant
    image_feats = zeros(n, quant*quant*quant);
    
    %Loop over all images
    parfor i = 1 : n
       
        %Open Image
        img = imread(char(image_paths(i)));
        
        %Resize image
        img = imresize(img, [dim dim]);
        
        %Change colour space if not rgb
        switch lower(colour_space)
            case 'ycbcr'
                img = rgb2ycbcr(img);
            case 'hsv'
                img = rgb2hsv(img);
        end
        
        %Convert image to double
        img = double(img);
        
        %Quantise image
        img = img/255;
        img = round(img*(quant-1)) + 1;
        
        %Initalise histogram
        hh = zeros(quant, quant, quant);
        
        %Increment each histogram index by 1 for each colour in image
        for j = 1 : dim
            for k = 1 : dim
                hh(img(j,k,1), img(j,k,2), img(j,k,3)) = hh(img(j,k,1), img(j,k,2), img(j,k,3)) + 1;
            end
        end

        %Vectorise histogram
        hh = reshape(hh, quant*quant*quant, 1);
        
        %Put histogram into image_feats
        image_feats(i, :) = hh;
    end
end