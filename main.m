
% f = uifigure('Name', 'Face recognition');
% m = uimenu('Text','Options');

h = uifigure('NumberTitle', 'off', 'Name', 'This is the figure title');
% mitem = uimenu(m,'Text','Reset');
hp = uipanel(h, 'Title','Main Panel','FontSize',12,...
             'BackgroundColor','white',...
             'Position',[.25 .1 .67 .67]);
hsp = uipanel('Parent',hp,'Title','Subpanel','FontSize',12,...
              'Position',[.4 .1 .5 .5]);
hbsp = uicontrol('Parent',hsp,'String','Push here',...
              'Position',[18 18 72 36]);
          
choice = menu('Choose an option :', 'grayscale', 'histogram eq');

img = imread('toto.jpg');
filteredImg = img;

if choice == 1
    filteredImg = tiGrayscale(img);
else
    filteredImg = tiHistEq(img);
end

% grayImg = tiGrayscale(img);
% histEqImg = tiHistEq(img);
figure, imshow(filteredImg);

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
    height = size(img, 1);
    width = size(img, 2);

    histEqImg = uint8(zeros(height, width));

    nbPixels = height*width;

    occ = zeros(256,1);
    prob_occ = zeros(256,1);

    for i = 1:height
        for j = 1:width
            pix = img(i,j);
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
            histEqImg(i,j) = hist(img(i,j)+1);
        end
    end
end
