function sift_features = get_image_section_features(img, step)
        
    [~, sift_features] = vl_dsift(img, 'fast', 'step', step, 'size', 4);
end