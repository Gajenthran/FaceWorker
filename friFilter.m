classdef friFilter
    methods(Static)
        function grayImg = applyGrayscale(img)
            R=img(:, :, 1);
            G=img(:, :, 2);
            B=img(:, :, 3);

            height = size(img, 1);
            width = size(img, 2);
            grayImg = zeros(height, width, 'uint8');

            for i=1:height
                for j=1:width
                    grayImg(i, j)=(R(i, j)*0.2989) + (G(i, j)*0.5870) + (B(i, j)*0.114);
                end
            end    
        end

        function histEqImg = applyHistEq(img)
            height = size(img, 1);
            width = size(img, 2);
            histEqImg = zeros(height, width, 'uint8');

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
        
        
        function sobelImg = applySobel(img)
            img = double(rgb2gray(img));
            kernelX = [ 
                -1, 0, 1;
                -2, 0, 2;
                -1, 0, 1
            ];

            kernelY = [
                1, 2, 1;
                0, 0, 0;
                -1, 0, 1
            ];

            height = size(img,1);
            width = size(img,2);
            channel = size(img,3);
            % sobelImg = zeros(height, width);
            
            for i = 2:height - 1
                for j = 2:width - 1
                    for k = 1:channel
                        magx = 0;
                        magy = 0;
                        for a = 1:3
                            for b = 1:3
                                magx = magx + (kernelX(a, b) * img(i + a - 2, j + b - 2, k));
                                magy = magy + (kernelY(a, b) * img(i + a - 2, j + b - 2, k));
                            end
                        end
                        sobelImg(i,j,k) = abs(magx); % + abs(magy); % sqrt(magx^2 + magy^2);
                    end
                end
            end

            sobelImg = abs(sobelImg)/255;

            for i = 1:height - 1
                for j= 1:width - 1
                    if sobelImg(i, j) > 0.5
                        sobelImg(i, j) = 1;
                    else
                        sobelImg(i, j) = 0;
                    end
                end
            end
            % figure, imshow(sobelImg);
        end
    end
end
