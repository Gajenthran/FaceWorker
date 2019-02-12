ObjectDetector = vision.CascadeObjectDetector;
% shapeInserter = vision.ShapeInserter('BorderColor','Custom','CustomBorderColor',[0 255 255]);

I = imread('img/hazard.jpg');

% Transformation de l'image en noir et blanc
if(size(I, 3) > 1)
    I = rgb2gray(I);
end;

% Detection des visages
IObject = step(ObjectDetector, I);
% I = insertShape(I, 'Rectangle', IObject);
% bbox = step(shapeInserter, I, int32(IObject));
IFaces = imcrop(I, IObject(1, :));
imwrite(IFaces, 'face.jpg');

% Affichage de l'image
imshow(I), title('Face recognition');

imshow(img);

