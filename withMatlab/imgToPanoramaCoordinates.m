function Tout = imgToPanoramaCoordinates(Tin)
% Tout{k} transforms image i to the coordinates system of the Panorama Image.
% Arguments:
% Tin ? A set of transformations (cell array) such that T i transfroms
% image i+1 to image i.
% Returns:
% Tout ? a set of transformations (cell array) such that T i transforms
% image i to the panorama corrdinate system which is the the corrdinates
% system of the ?rst image. 
Tout = cell(1,size(Tin,2));
Tout{1} = Tin{1};
for i = 2 : size(Tin,2)
   Tout{i} = Tin{i} * Tout{i-1};
end
