%part1 Take four photograph pairs or sets of 4
%S1-im1,2,3,4
img1_part_1 = my_resize_img('img1_1.png', 750, 'S1-im1.png');
img1_part_2 = my_resize_img('img1_2.png', 750, 'S1-im2.png');
img1_part_3 = my_resize_img('img1_3.png', 750, 'S1-im3.png');
img1_part_4 = my_resize_img('img1_4.png', 750, 'S1-im4.png');

%S2-im1,2,3,4
img2_part_1 = my_resize_img('img2_1.png', 750, 'S2-im1.png');
img2_part_2 = my_resize_img('img2_2.png', 750, 'S2-im2.png');
img2_part_3 = my_resize_img('img2_3.png', 750, 'S2-im3.png');
img2_part_4 = my_resize_img('img2_4.png', 750, 'S2-im4.png');

%S3-im1,2,3,4
img3_part_1 = my_resize_img('img3_1.png', 750, 'S3-im1.png');
img3_part_2 = my_resize_img('img3_2.png', 750, 'S3-im2.png');
img3_part_3 = my_resize_img('img3_3.png', 750, 'S3-im3.png');
img3_part_4 = my_resize_img('img3_4.png', 750, 'S3-im4.png');

%S4-im1,2,3,4
img4_part_1 = my_resize_img('img4_1.png', 750, 'S4-im1.png');
img4_part_2 = my_resize_img('img4_2.png', 750, 'S4-im2.png');
img4_part_3 = my_resize_img('img4_3.png', 750, 'S4-im3.png');
img4_part_4 = my_resize_img('img4_4.png', 750, 'S4-im4.png');


%part2 FAST feature detector
timesFAST=zeros(2,1); 
%S1-fast
tic;
[corners, v] = my_fast_detector(img1_part_1);
img_after_fast1_1 = insert_mark_to_img(corners, img1_part_1);
imwrite(img_after_fast1_1, 'S1-fast.png');
timesFAST(1) = toc;

%S2-fast
tic
[corners, v] = my_fast_detector(img2_part_1);
img_after_fast2_1 = insert_mark_to_img(corners, img2_part_1);
imwrite(img_after_fast2_1, 'S2-fast.png');
timesFAST(2)=toc;

meanFASTtime = mean(timesFAST);
disp("Average runtime for FAST = "+meanFASTtime+" seconds");

%part3 
timesFASTR=zeros(2,1); 
%S1-fastR
tic
corners_fastR = detectHarrisFeatures(imresize(im2double(rgb2gray(imread('img1_1.png'))), [750 750]), "MinQuality", 0.03);
img_after_fastR1_1 = insert_fastR_to_img(corners_fastR.Location, img1_part_1);
imwrite(img_after_fastR1_1, 'S1-fastR.png');
timesFASTR(1)=toc;
%S2-fastR
tic
corners_fastR = detectHarrisFeatures(imresize(im2double(rgb2gray(imread('img2_1.png'))), [750 750]), "MinQuality", 0.03);
img_after_fastR2_1 = insert_fastR_to_img(corners_fastR.Location, img2_part_1);
imwrite(img_after_fastR2_1, 'S2-fastR.png');
timesFASTR(2)=toc;

meanFASTtime = mean(timesFASTR);
disp("Average runtime for FASTR = "+meanFASTtime+" seconds");



%part4 Point description and matching
%S1-fastMatch
timesMatch=zeros(4,1);
tic
[corners, v] = my_fast_detector(img1_part_2);
img_after_fast1_2 = insert_mark_to_img(corners, img1_part_2);

gray_1 = rgb2gray(img_after_fast1_1);
gray_2 = rgb2gray(img_after_fast1_2);
orb_points_1 = detectSURFFeatures(gray_1);
orb_points_2 = detectSURFFeatures(gray_2);
[feature_1, valid_points_1] =  extractFeatures(gray_1, orb_points_1);
[feature_2, valid_points_2] =  extractFeatures(gray_2, orb_points_2);
indexPairs = matchFeatures(feature_1,feature_2);
matchedPoints1 = valid_points_1(indexPairs(:,1));
matchedPoints2 = valid_points_2(indexPairs(:,2));
showMatchedFeatures(gray_1,gray_2,matchedPoints1,matchedPoints2);
timesfastMatch(1)=toc;

%S1-fastRMatch
tic
corners_fastR = detectHarrisFeatures(imresize(im2double(rgb2gray(imread('img1_2.png'))), [750 750]), "MinQuality", 0.03);
img_after_fastR1_2 = insert_fastR_to_img(corners_fastR.Location, img1_part_2);
gray_1 = rgb2gray(img_after_fastR1_1);
gray_2 = rgb2gray(img_after_fastR1_2);
orb_points_1 = detectSURFFeatures(gray_1);
orb_points_2 = detectSURFFeatures(gray_2);
[feature_1, valid_points_1] =  extractFeatures(gray_1, orb_points_1);
[feature_2, valid_points_2] =  extractFeatures(gray_2, orb_points_2);
indexPairs = matchFeatures(feature_1,feature_2);
matchedPoints1 = valid_points_1(indexPairs(:,1));
matchedPoints2 = valid_points_2(indexPairs(:,2));
showMatchedFeatures(gray_1,gray_2,matchedPoints1,matchedPoints2);
timesfastRMatch(1)=toc;

%S2-fastMatch
% tic
% [corners, v] = my_fast_detector(img2_part_2);
% img_after_fast2_2 = insert_mark_to_img(corners, img2_part_2);
% 
% gray_1 = rgb2gray(img_after_fast2_1);
% gray_2 = rgb2gray(img_after_fast2_2);
% orb_points_1 = detectSURFFeatures(gray_1);
% orb_points_2 = detectSURFFeatures(gray_2);
% [feature_1, valid_points_1] =  extractFeatures(gray_1, orb_points_1);
% [feature_2, valid_points_2] =  extractFeatures(gray_2, orb_points_2);
% indexPairs = matchFeatures(feature_1,feature_2);
% matchedPoints1 = valid_points_1(indexPairs(:,1));
% matchedPoints2 = valid_points_2(indexPairs(:,2));
% showMatchedFeatures(gray_1,gray_2,matchedPoints1,matchedPoints2);
% timesfastMatch(2)=toc;

%S2-fastRMatch
tic
corners_fastR = detectHarrisFeatures(imresize(im2double(rgb2gray(imread('img2_2.png'))), [750 750]), "MinQuality", 0.03);
img_after_fastR2_2 = insert_fastR_to_img(corners_fastR.Location, img2_part_2);
gray_1 = rgb2gray(img_after_fastR2_1);
gray_2 = rgb2gray(img_after_fastR2_2);
orb_points_1 = detectSURFFeatures(gray_1);
orb_points_2 = detectSURFFeatures(gray_2);
[feature_1, valid_points_1] =  extractFeatures(gray_1, orb_points_1);
[feature_2, valid_points_2] =  extractFeatures(gray_2, orb_points_2);
indexPairs = matchFeatures(feature_1,feature_2);
matchedPoints1 = valid_points_1(indexPairs(:,1));
matchedPoints2 = valid_points_2(indexPairs(:,2));
showMatchedFeatures(gray_1,gray_2,matchedPoints1,matchedPoints2);
timesfastRMatch(2)=toc;

meanfastMatchtime = mean(timesfastMatch);
meanfastRMatchtime = mean(timesfastRMatch);
disp("Average runtime for fast Match = "+meanfastMatchtime+" seconds");
disp("Average runtime for fastR Match = "+meanfastRMatchtime+" seconds");


%part5 RANSAC and Panoramas
% S1-panorama
% pano_part_1_1 = get_panorama(img1_part_1, img1_part_2);
% pano_part_1_2 = get_panorama(pano_part_1_1, img1_part_3);
% pano_part_1_3 = get_panorama(pano_part_1_2, img1_part_4);
% imwrite(pano_part_1_3, 'S1-panorama.png')
% 
% S2-panorama
% pano_part_2_1 = get_panorama(img2_part_1, img2_part_2);
% pano_part_2_2 = get_panorama(pano_part_2_1, img2_part_3);
% pano_part_2_3 = get_panorama(pano_part_2_2, img2_part_4);
% imwrite(pano_part_2_3, 'S2-panorama.png')
% 
% S3-panorama
% pano_part_3_1 = get_panorama(img3_part_1, img3_part_2);
% pano_part_3_2 = get_panorama(pano_part_3_1, img3_part_3);
% pano_part_3_3 = get_panorama(pano_part_3_2, img3_part_4);
% imwrite(pano_part_3_3, 'S3-panorama.png')
% 
% S3-panorama
% pano_part_4_1 = get_panorama(img4_part_1, img4_part_2);
% pano_part_4_2 = get_panorama(pano_part_4_1, img4_part_3);
% pano_part_4_3 = get_panorama(pano_part_4_2, img4_part_4);
% imwrite(pano_part_4_3, 'S4-panorama.png')


function resized_img = my_resize_img(img_file_name, dim, out_file_name)
    resized_img = imresize(im2double(imread(img_file_name)), [dim dim]);
    imwrite(resized_img, out_file_name);
end

function panorama = get_panorama(img_part_1, img_part_2)
    I = img_part_1;
    grayImage = im2gray(I);
    points = detectSURFFeatures(grayImage);
    [features, points] = extractFeatures(grayImage,points);
    numImages = 2;
    tforms(numImages) = rigid2d(eye(3));
    imageSize = zeros(numImages,2);
        pointsPrevious = points;
        featuresPrevious = features;
        I = img_part_2;
        grayImage = im2gray(I);    
        imageSize(2,:) = size(grayImage);
        points = detectSURFFeatures(grayImage);    
        [features, points] = extractFeatures(grayImage, points);
        indexPairs = matchFeatures(features, featuresPrevious, 'Unique', true);
        matchedPoints = points(indexPairs(:,1), :);
        matchedPointsPrev = pointsPrevious(indexPairs(:,2), :);        
        [tforms(2), idx] = estimateGeometricTransform2D(matchedPoints, matchedPointsPrev,...
           'rigid', 'Confidence', 99.9, 'MaxNumTrials', 10000);
        tforms(2).T = tforms(2).T * tforms(2-1).T; 
    for i = 1:2           
        [xlim(i,:), ylim(i,:)] = outputLimits(tforms(i), [1 imageSize(i,2)], [1 imageSize(i,1)]);    
    end
    avgXLim = mean(xlim, 2);
    [~,idx] = sort(avgXLim);
    centerIdx = floor((numel(tforms)+1)/2);
    centerImageIdx = idx(centerIdx);
    Tinv = invert(tforms(centerImageIdx));
    for i = 1:2    
        tforms(i).T = tforms(i).T * Tinv.T;
    end

    for i = 1:2           
        [xlim(i,:), ylim(i,:)] = outputLimits(tforms(i), [1 imageSize(i,2)], [1 imageSize(i,1)]);
    end
    maxImageSize = max(imageSize);
    xMin = min([1; xlim(:)]);
    xMax = max([maxImageSize(2); xlim(:)]);
    yMin = min([1; ylim(:)]);
    yMax = max([maxImageSize(1); ylim(:)]);
    width  = round(xMax - xMin);
    height = round(yMax - yMin);

    panorama = zeros([height width 3], 'like', I);
    blender = vision.AlphaBlender('Operation', 'Binary mask', ...
        'MaskSource', 'Input port');  

    xLimits = [xMin xMax];
    yLimits = [yMin yMax];
    panoramaView = imref2d([height width], xLimits, yLimits);
    for i = 1:numImages
        if i == 1
            I = img_part_1;
        warpedImage = imwarp(I, tforms(i), 'OutputView', panoramaView);
        mask = imwarp(true(size(I,1),size(I,2)), tforms(i), 'OutputView', panoramaView);
        panorama = step(blender, panorama, warpedImage, mask);
        end
        if i == 2
            I = img_part_2;
        warpedImage = imwarp(I, tforms(i), 'OutputView', panoramaView); 
        mask = imwarp(true(size(I,1),size(I,2)), tforms(i), 'OutputView', panoramaView);
        panorama = step(blender, panorama, warpedImage, mask);
        end
    end
end

function img_with_fastR_points = insert_fastR_to_img(locations, img)
    img_with_fastR_points = insertMarker(img, locations, 'x', 'color', 'white', 'size', 8);
end

function img_with_fast_points = insert_mark_to_img(corners, img)
    fast_size= 0;
    for row = 1:750
        for col = 1:750
            if corners(row, col) == 1
                fast_size = fast_size + 1;
            end
        end
    end
    fast_pos = zeros(fast_size, 2);
    fast_pos_index = 1;
    for col = 1:750
        for row = 1:750
            if corners(row, col) == 1
                fast_pos(fast_pos_index,:) = [col, row];
                fast_pos_index = fast_pos_index + 1;
            end
        end
    end
    img_with_fast_points = insertMarker(img, fast_pos, 'x', 'color', 'white', 'size', 8);
end
    
function [corners, visual] = my_fast_detector(img)
        thresholdDet=0.08;
        thresholdMax=0.09;
        [sizeX, sizeY, ~] = size(img);
        gray_I = rgb2gray(img);
        corners = 0*gray_I;
        tempCorners = [];
        [a, b] = size(img);
        for y=4:sizeY-3
            for x=4:sizeX-3
                mid_point=gray_I(x, y);
                pixel={16};
                pixel{1}=gray_I(x, y-3);
                pixel{2}=gray_I(x+1, y-3);
                pixel{3}=gray_I(x+2, y-2);
                pixel{4}=gray_I(x+3, y-1);
                pixel{5}=gray_I(x+3, y);
                pixel{6}=gray_I(x+3, y+1);
                pixel{7}=gray_I(x+2, y+2);
                pixel{8}=gray_I(x+1, y+3);
                pixel{9}=gray_I(x, y+3);
                pixel{10}=gray_I(x-1, y+3);
                pixel{11}=gray_I(x-2, y+2);
                pixel{12}=gray_I(x-3, y+1);
                pixel{13}=gray_I(x-3, y);
                pixel{14}=gray_I(x-3, y-1);
                pixel{15}=gray_I(x-2, y-2);
                pixel{16}=gray_I(x-1, y-3);
%           for i = 4:a-4
%                 for j = 4:b-4
%                     p0 = img(i,j);                    
%                     p = [];
%                     p(end+1)=img(i-3,j);  
%                     p(end+1)=img(i-3,j+1);  
%                     p(end+1)=img(i-2,j+2);  
%                     p(end+1)=img(i-1,j+3);  
%                     p(end+1)=img(i,j+3);  
%                     p(end+1)=img(i+1,j+3);  
%                     p(end+1)=img(i+2,j+2); 
%                     p(end+1)=img(i+3,j+1);  
%                     p(end+1)=img(i+3,j);  
%                     p(end+1)=img(i+3,j-1);  
%                     p(end+1)=img(i+2,j-2);  
%                     p(end+1)=img(i+1,j-3);  
%                     p(end+1)=img(i,j-3);  
%                     p(end+1)=img(i-1,j-3);  
%                     p(end+1)=img(i-2,j-2);  
%                     p(end+1)=img(i-3,j-1);  
%                     thr=thresholdDet*p0;
%                     %featureFlag = FastFeaturePointDetect(p0,p,thr,obj.numInChain);
% %                     if featureFlag == 1 || featureFlag == 2  
% %                         
% %                         tempCorners(end + 1).x = j;
% %                         tempCorners(end).y = i;
% %                         tempCorners(end).val = val;
% %  
% %                     end
%                 end
%              end
                    if (mid_point-thresholdDet<=pixel{1}||pixel{1}<=mid_point+thresholdDet)&&(mid_point-thresholdDet<=pixel{9}||pixel{9}<=mid_point+thresholdDet)
                        count=0;
                        j=1;
                        for l=1:4
                             if (mid_point-thresholdDet<=pixel{j}||pixel{j}<=mid_point+thresholdDet)
                                 count=count+1;
                             end
                             j=j+4;
                        end                     
                        if count >= 3                           
                            count1 = 0;
                            for i=1:16
                                if pixel{i}>mid_point+thresholdDet
                                    count1=count1+1;
                                end
                            end                           
                            count2=0;
                            for i=1:16
                                if pixel{i}<mid_point-thresholdDet
                                    count2=count2+1;
                                end
                            end                            
                            if count1>=12||count2>=12
                                corners(x,y,:)=mid_point;
                            end
                        end
                    end
            end
        end
        localmax=imdilate(corners,ones(3));
        corners=((corners==localmax) .* (corners>thresholdMax));
        visual=repmat(gray_I, [1 1 3]);
        for y=4:sizeY-3
            for x=4:sizeX-3
                if corners(x, y) ~= 0 
                    visual(x, y, :) = [0, 255, 0];
                end
            end
        end
%         for i=1:16
%     if p(i)-p0>thr
%         counter=1;
%         for j=1:numInChain - 1
%             k=i + j;
%             if p(mod(k-1,length(p))+1) - p0 > thr
%                 counter = counter + 1;
%             else
%                 break;
%             end
%         end
%         if counter == numInChain
%             flag = 1;
%             return
%         end
%     else
%         continue;
%     end
% end
% for i=1:16
%     if p0-p(i)>thr
%         counter=1;
%         for j=1:numInChain - 1
%             k=i+j;
%             if  p0 - p(mod(k-1,length(p))+1) > thr
%                 counter = counter + 1;
%             else
%                 break;
%             end
%         end
%         if counter == numInChain
%             flag=2;
%          
%         end
%     else
%         continue;
%     end
%   end
end