%% Charger les images sources du dossier 'img_src'
srcImg = imageSet('img_src','recursive');

%% Afficher l'ensemble des images sources
figure;
montage(srcImg(1).ImageLocation);
title('Images of Single Face');

%% Charger une image en entrée et reconnaître seulement le visage
ObjectDetector = vision.CascadeObjectDetector;
inputImg = read(srcImg(1),1);

% Transformation de l'image en noir et blanc
if(size(inputImg, 3) > 1)
    inputImg = rgb2gray(inputImg);
end

% Detection des visages
inObject = step(ObjectDetector, inputImg);
inputImg = imcrop(inputImg, inObject(1, :));
% imwrite(inFace, 'face.jpg');
imshow(inputImg), title('Face cropping');


%% Extraction de caracteristiques avec HoG (Histogram of Gradient)
[hogFeature, hogImg] = ...
    extractHOGFeatures(inputImg);
figure;
subplot(1,2,1);imshow(inputImg);title('Input image');
subplot(1,2,2);plot(hogImg);title('HoG image');



