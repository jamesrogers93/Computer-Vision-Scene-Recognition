function hist = get_hue_histogram(img)

    %Convert image to HSV
    img = rgb2hsv(img);
    
    %Quantise image
    H = round(img(:,:,1).*(8-1)) + 1;
    
    %Initalise histogram
    [x, y] = size(H);
    hist = zeros(1, 8);

    H = im2single(H);
    %Increment each histogram index by 1 for each colour in image
    for j = 1 : x
        for k = 1 : y
            %Weight histogram by multipling Hue by Saturation
           %w = img(j,k,1) * img(j,k,2);
           w = 0.0001;
           hist(H(j,k)) = hist(H(j,k)) + w;
        end
    end
end