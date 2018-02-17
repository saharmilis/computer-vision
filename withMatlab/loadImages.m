
% Read all images from directoryPath
%
% Arguments: % directoryPath ? A string with the directory path %
% Returns % imgs ? 4 dimensional vector, where imgs(:,:,:,k) is the k?th 
% image in RGB format.
%
function imgs=loadImages(directoryPath)
files = dir(directoryPath);
for i = 3:length(files)
imgs(:, :, :,i-2) = imReadAndConvert([directoryPath '\' files(i).name], 2);
end
end