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
            img = double(rgb2gray(img)); %% applyGrayscale(img);
            kernelX = [ 
                -1, 0, 1;
                -2, 0, 2;
                -1, 0, 1
            ];

            kernelY = [ 
                -1, -2, -1;
                0, 0, 0;
                1, 2, 1
            ];

            height = size(img,1);
            width = size(img,2);
            channel = size(img,3);
            % sobelImg = zeros(height, width);
            
            for i = 2:height - 1
                for j = 2:width - 1
                    for k = 1:channel
                        Gx = 0;
                        Gy = 0;
                        for a = 1:3
                            for b = 1:3
                                Gx = Gx + (kernelX(a, b) * img(i + a - 2, j + b - 2, k));
                                Gy = Gy + (kernelY(a, b) * img(i + a - 2, j + b - 2, k));
                            end
                        end
                        sobelImg(i,j,k) = abs(Gx) + abs(Gy); % sqrt(Gx^2 + Gy^2);
                    end
                end
            end

            sobelImg = abs(sobelImg)/255;

            %for i = 1:height - 1
            %    for j= 1:width - 1
            %        if sobelImg(i, j) > 0.5
            %            sobelImg(i, j) = 1;
            %        else
            %            sobelImg(i, j) = 0;
            %        end
            %    end
            %end
        end
        
        function prewittImg = applyPrewitt(img)
            img = double(rgb2gray(img));
            kernelX = 1/3 * [-1, 0, 1;  -1, 0, 1; -1, 0, 1];
            kernelY = 1/3 * [-1, -1, -1;  0, 0, 0; 1, 1, 1];

            height = size(img,1);
            width = size(img,2);
            channel = size(img,3);
            prewittImg = img;

            for i = 2:height-1
                for j = 2:width-1
                    for k = 1:channel
                        Gx = 0;
                        Gy = 0;
                        for a = 1:3
                            for b = 1:3
                                Gx = Gx + (kernelX(a, b) * img(i + a - 2, j + b - 2, k));
                                Gy = Gy + (kernelY(a, b) * img(i + a - 2, j + b - 2, k));
                            end
                        end
                        prewittImg(i,j,k) = sqrt(Gx.^2+ Gy.^2); % abs(Gx) + abs(Gy);
                    end
                end
            end

            prewittImg = abs(prewittImg)/255;
        end
    
        function sepiaImg = applySepia(img)
            sepiaImg = img;
            R=img(:, :, 1);
            G=img(:, :, 2);
            B=img(:, :, 3);

            newR = (R * .393) + (G * .769) + (B * .189);
            newG = (R * .349) + (G * .686) + (B * .168);
            newB = (R * .272) + (G * .534) + (B * .131);

            height = size(img, 1);
            width = size(img, 2);
            sepiaImg(:, :, 1) = newR;
            sepiaImg(:, :, 2) = newG;
            sepiaImg(:, :, 3) = newB;
        end

        function brightnessImg = applyBrightness(img, value)
            if value < 0
                value = 30;
            end

            brightnessImg = img + value;
        end

        function averageImg = applyAverage(img)
            height = size(img, 1);
            width = size(img, 2);
            averageImg = zeros(height, width, 'uint8');
            % averageImg = double(averageImg);

            for i = 2:height-1
                for j = 2:width-1
                    averageImg(i, j) = (img(i - 1, j - 1) + img(i - 1, j) + img(i - 1, j + 1) + img(i + 1, j - 1) + img(i + 1, j) + img(i + 1, j + 1) + img(i, j) + img(i, j - 1) + img(i, j + 1)) / 9;
                end
            end
        end
    end
end
