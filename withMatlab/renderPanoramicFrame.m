function [panoramaFrame,frameNotOK]=renderPanoramicFrame(panoSize,imgs,T,imgSliceCenterX,halfSliceWidthX)
%
% The function render a panoramic frame. It does the following:
% 1. Convert centers into panorama coordinates and find optimal width of
% each strip.
% 2. Each strip from image to the panorama frames
%
% Arguments:
% panoSize [yWidth,xWidth] of the panorama frame
% imgs - The set of M images
% T - The set of transformations (cell array) from each image to
% the panorama coordinates
% imgSliceCenterX - A vector of 1xM with the required center of the strip
% in each of the images. This is given in image coordinates.
% sliceWidth - The suggested width of each strip in the image
%
% Returns:
% panoramaFrame - the rendered frame
% frameNotOK - in case of errors in rednering the frame, it is true.

[rows, cols, ~, M] = size(imgs);
frameNotOK = 0; % ok

for i = 1:M
    
    Tr = T{i};
    cords(i) =  imgSliceCenterX(i) + Tr(3,1);% add the transformtion to the orginal centers
    
end

%ceil rounds each element
b = ceil((cords(1:end-1)+cords(2:end))/2); % avrage between to slices
bound = [b(1) - halfSliceWidthX, b, b(end) + halfSliceWidthX];

% first row is the start of stich and second row is its end
xBound = [[bound(1), bound(2:end-1)]; bound(2:end)]; % bounds in the x dim for each pic for stiching
panoramaFrame = zeros(panoSize(1),panoSize(2), 3);% create panorame with the sizes that we check in rgb

for i = 1:M
    Tr = T{i};
    x = xBound (1,i): xBound(2,i);
    y = 1: panoSize(1);
    [Xp, Yp] = meshgrid(x, y);%  returns 2-D grid coordinates based on the coordinates contained
                               %in vectors x and y. X is a matrix where each row is a copy of x, 
                               %and Y is a matrix where each column is a copy of y. The grid represented
                               %by the coordinates X and Y has length(y) rows and length(x) columns.
    Xp = single(Xp);
    Xp = Xp - Tr(3,1);
    Yp = Yp - Tr(3,2);
    
    if (~isempty(Xp(Xp<0)) || ~isempty(Xp(Xp > cols)))
        frameNotOK = 1;% not ok
        return;
    end
     
    r = interp2(imgs(:, :, 1, i),Xp,Yp) ; %change the coordinates doing it for r g b
    g = interp2((imgs(:, :, 2, i)),Xp,Yp) ;
    b = interp2((imgs(:, :, 3, i)),Xp,Yp) ;
    [m,n]=size(r); % take the sizes
    im=zeros(m,n,3); %initialize the image
    im(:,:,1)= r;
    im(:,:,2)= g;
    im(:,:,3)= b;
    
    bb = (xBound(1,i) : xBound(2,i)) - xBound(1) + 1;
    panoramaFrame(:, bb, 1:3 ) = im;
end
panoramaFrame(isnan(panoramaFrame))=0;

panoramaFrame = im2frame(panoramaFrame);

end


