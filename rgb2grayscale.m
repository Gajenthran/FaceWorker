img = imread('toto.jpg');
% grayImg = tiGrayscale(img);
histEqImg = tiHistEq(img);
figure, imshow(histEqImg);

%% Transformation d'une image en nuance de gris
function grayImg = tiGrayscale(img)
    R=img(:, :, 1);
    G=img(:, :, 2);
    B=img(:, :, 3);
         
    height = size(img, 1);
    width = size(img, 2);
    grayImg = zeros(height, width, 'uint8');

    for i=1:height
        for j=1:width
            grayImg(i, j)=(R(i, j)*0.2989)+(G(i, j)*0.5870)+(B(i, j)*0.114);
        end
    end    
end

%% Egalisation d'histogramme permettant d'améliorer la qualité d'une image
function histEqImg = tiHistEq(img)
    I = test; 

    height = size(I, 1);
    width = size(I, 2);

    histEqImg = uint8(zeros(height, width));

    nbPixels = height*width;

    occ = zeros(256,1);
    prob_occ = zeros(256,1);

    for i = 1:height
        for j = 1:width
            pix = I(i,j);
            occ(pix+1) = occ(pix+1)+1;
            prob_occ(pix+1) = occ(pix+1)/nbPixels;
        end
    end

    prob_cum = zeros(256,1);
    cum = zeros(256,1);
    hist = zeros(256,1);
    sum = 0;

    for i = 1:size(prob_occ)
        sum = sum + occ(i);
        cum(i) = sum;
        prob_cum(i) = cum(i)/nbPixels;
        hist(i) = round(prob_cum(i)*255);
    end

    for i = 1:height
        for j = 1:width
            histEqImg(i,j) = hist(I(i,j)+1);
        end
    end
end
