function [stereoVid] = createStereoVideo(imgDirectory, nViews)
% This function gets an image directory and create a stereo movie with
% nViews. It does the following
%
% 1. Match transform between pairs of images.
% 2. Convert the transfromations to a common coordinate system.
% 3. Determine the size of each panoramic frame.
% 4. Render each view.
% 5. Create a movie from all the views.
% Returns:
% stereoVid  a movie which includes all the panoramic views

imgs = loadImages(imgDirectory);
[hight, width, ~, m] = size(imgs); %hight image ,width image,~ rgb,m number of pic
Tin = cell (1, m); % create arr with m cells for the transformtions
Tin{1} = eye(3);    % for each the transformtion[3][3]
pos = cell (1,m); % create arr of positions with m cells
desc = cell(1,m); % create arr with m cells for descs

for i = 1 : m % find feachers for each image
    im = imgs(:,:,:,i); % take the i image 
    I1 = rgb2gray(im); % convert to gray 
    points1 = detectHarrisFeatures(I1);
    [pos{i},desc{i}] = extractFeatures(I1,points1);
end

% find transformation and the min and max y for the size of the panorama
for i = 2 : m 
    maxDy = 0;
    minDy = 0;
    desc1 = desc{i};
    desc2 = desc{i-1};
    pos1 = pos{i};
    pos2 = pos{i-1};
    indexPairs = matchFeatures(pos1,pos2);
    matchedPoints1 = desc1(indexPairs(:,1),:);
    matchedPoints2 = desc2(indexPairs(:,2),:);
    [transform,inliers,~] = estimateGeometricTransform(matchedPoints1,matchedPoints2,'similarity');
    T = transform.T;
    
    % find min and max dy transformation
    maxDy = max(T(3,2),maxDy) ;% T(3,2) dy
    minDy = min(T(3,2), minDy);
    Tin {i} =  T;
end

% the real pos in the panoram transformation *
Tout = imgToPanoramaCoordinates(Tin);

% get rid from bad images
j = 0;
for i = 2 : m 
    if(i < m - j)
        if (Tout{i-1}(3,1) > Tout{i}(3,1)) % wrong direction
            imgs = imgs(:,:,:,[1:i-1,i+1:end]);
            j = j+1;
            Tout = Tout([1:i-1, i+1:end]);
        end
    end
end

maxDx = Tout{end}(3,1); % T(3,1) dx

%find all centers
widthP = width/nViews;

%EQUATION boundaries between strips i and i + 1 is (x^center i + x^center i+1 )/2. 

c1 = 1:widthP:width - widthP+1;
c2 = c1 + widthP -1;
centers = ceil((c1+c2)/2);

%With col from where to take the strips  0-640 px
centers1 = [146 468];


%build the panorama
Imout = cell(1, 1); %create empty cell for the image
index = 1;
stereoVid = struct('cdata', 1, 'colormap', cell([nViews 1])); %create stract that save the nviews panoramas in color

for i = 1 : numel(centers1)
    [im,frameNotOK] = renderPanoramicFrame([round(hight+maxDy-minDy), round(maxDx+widthP- Tin{end}(3,1))],imgs,Tout,ones(1, m)*centers1(i),ceil(widthP/2));
    if ( ~frameNotOK) %frame ok
        stereoVid(index)= im;
        index = index + 1;
    end
end
stereoVid = stereoVid(1:index-1);
