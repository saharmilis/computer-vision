% A function that reads a given image and converts it into 
% a given representation.
% filename - string containing the image ?lename to read.
% representation - representation code, either 1 or 2 defining if the output
% should be either a grayscale image (1) or an RGB image (2).

function [im] = imReadAndConvert(filename, representation)
    im = imread(filename);
    % a matrix of double , normalized to range [0,1]  
    if (representation == 1 && size(im, 3) == 3)
        % an RGB inage, and needed to convert to grayscale
        im = rgb2gray(im);
    end
    im = double(im)/255;
end
    