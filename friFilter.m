classdef friFilter
    methods(Static)

        function result = isGray(img)
            result = true
            if size(img, 3) > 1
                result = false;
            end
        end

        function grayImg = applyGrayscale(img)
            grayImg = img;
            if friFilter.isGray(img) == false
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
        end

        function complementBinaryImg = applyComplementBinary(img)
            img = friFilter.applyBinary(img);
            height = size(img, 1);
            width = size(img, 2);
            complementBinaryImg = zeros(height, width);

            for i = 1:height
                for j = 1:width
                    complementBinaryImg(i, j) = 1 - img(i, j);
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
            img = double(friFilter.applyGrayscale(img)); %% rgb2gray(img);
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
        end
        
        function prewittImg = applyPrewitt(img)
            img = double(friFilter.applyGrayscale(img)); % rgb2gray(img);
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

        function laplacianImg = applyLaplacian(img)
            img = double(friFilter.applyGrayscale(img)) % rgb2gray(img);
            height = size(img, 1);
            width = size(img, 2);
            laplacianImg = img;
            kernel  = [ 
                -1, -1, -1;
                -1, 8, -1;
                -1, -1, -1;
            ];

            for i = 2:height-1
                for j= 2:width-1
                    G = 0;
                    for a = 1:3
                        for b = 1:3
                            G = G + img(i + a - 2, j + b - 2) * kernel(a, b);
                        end
                    end
                    laplacianImg(i, j) = G;
                end
            end
        end


        function sharpenImg = applySharpen(img)
            img = double(friFilter.applyGrayscale(img)) % rgb2gray(img);
            height = size(img, 1);
            width = size(img, 2);
            sharpenImg = img;
            kernel  = [ 
                0, -1, 0;
                -1, 5, -1;
                0, -1, 0;
            ];

            for i = 2:height-1
                for j= 2:width-1
                    G = 0;
                    for a =1:3
                        for b = 1:3
                            G = G + img(i + a - 2, j + b - 2) * kernel(a, b);
                        end
                    end
                    sharpenImg(i, j) = G;
                end
            end
        end

        function averageImg = applyAverage(img)
            img = double(friFilter.applyGrayscale(img));
            height = size(img, 1);
            width = size(img, 2);
            averageImg = zeros(height, width, 'uint8');

            for i = 2:height-1
                for j = 2:width-1
                    averageImg(i, j) = (img(i - 1, j - 1) + img(i - 1, j) + img(i - 1, j + 1) + img(i + 1, j - 1) + img(i + 1, j) + img(i + 1, j + 1) + img(i, j) + img(i, j - 1) + img(i, j + 1)) / 9;
                end
            end
        end

        function medianImg = applyMedian(img)
            img = double(friFilter.applyGrayscale(img));
            height = size(img, 1);
            width = size(img, 2);
            medianImg = zeros(height, width, 'uint8');

            for i = 2:height-1
                for j = 2:width-1
                    N = [img(i - 1, j - 1) img(i - 1, j) img(i - 1, j + 1) img(i + 1, j - 1) img(i + 1, j) img(i + 1, j + 1) img(i, j) img(i, j - 1) img(i, j + 1)];
                    N = sort(N);
                    medianImg(i, j) = N(5);
                end
            end
        end

        function invertImg = applyInvert(img)
            invertImg = img;
            R=img(:, :, 1);
            G=img(:, :, 2);
            B=img(:, :, 3);

            newR = 255 - R;
            newG = 255 - G;
            newB = 255 - B;

            invertImg(:, :, 1) = newR;
            invertImg(:, :, 2) = newG;
            invertImg(:, :, 3) = newB;
        end

        function swirlImg = applySwirl(img, degValue)
            % On limite les valeurs à 100 pour reconnaitre un minimum l'image
            degree = min(max(0, degValue), 100) / 1000.0;

            height = size(img, 1);
            width = size(img, 2);
            channel = size(img, 3);

            centerH = height / 2;
            centerW = width / 2;
            swirlImg = zeros(height, width, 'uint8');

            for i = 1:height
                for j = 1:width
                    for k = 1:channel
                        offsetY = i - centerH;
                        offsetX = j - centerW;

                        radian = atan2(offsetY, offsetX);
                        radius = sqrt(offsetX.^2 + offsetY.^2);

                        x = uint8(radius * cos(radian + radius * degree) + centerW);
                        y = uint8(radius * sin(radian + radius * degree) + centerH);

                        x = min(max(1, x), width - 1);
                        y = min(max(1, y), height - 1);

                        swirlImg(i, j, k) = img(y, x, k);
                    end
                end
            end
        end

        function mosaicImg = applyMosaic(img)
            blockSZ = 32;

            height = size(img, 1);
            width = size(img, 2);
            channel = size(img, 3);

            mosaicImg = zeros(height, width, 'uint8');


            for i = 1:height
                for j= 1:width
                    rsum = 0; gsum = 0; bsum = 0;
                    SZ = blockSZ * blockSZ;
                    ip = i + blockSZ;
                    jp = j + blockSZ;

                    for a = ip:min(ip + blockSZ, height)
                        for b = jp:(min(jp + blockSZ, width))
                            rsum = rsum + img(ip, j, 1);
                            gsum = gsum + img(ip, j, 2);
                            bsum = bsum + img(ip, j, 3);
                        end
                    end

                    rave = uint8(rsum / SZ);
                    gave = uint8(gsum / SZ);
                    bave = uint8(bsum / SZ);

                    for a = ip:min(ip + blockSZ, height)
                        for b = jp:(min(jp + blockSZ, width))
                            mosaicImg(ip, j, 1) = rave;
                            mosaicImg(ip, j, 2) = gave;
                            mosaicImg(ip, j, 3) = bave;
                        end
                    end
                end
            end
        end

        function [matX, matY] = myMeshgrid(x, y)
            rows = length(y);
            columns = length(x);
            matX = zeros(rows, columns);
            matY = zeros(rows, columns);
            for i = 1:columns
                matX(:, i) = x(i);
                matY(:, i) = y;
            end
        end

        function channelValue = bilateralChannel(wSz, sigmaR, sigmaS, channel)
            [X, Y] = friFilter.myMeshgrid(-wSz:wSz, -wSz:wSz);
            domainFilter = exp(-(X.^2+Y.^2)/(2*sigmaS^2));
            height = size(channel, 1);
            width = size(channel, 2);
            channelValue = zeros(size(channel));
            for i=1:height
                for j=1:width

                    iMin=max(i-wSz,1);
                    iMax=min(i+wSz,height);
                    jMin=max(j-wSz,1);
                    jMax=min(j+wSz,width);

                    I=channel(iMin:iMax,jMin:jMax);
                    rangeFilter=exp(-(I-channel(i,j)).^2/(2*sigmaR^2));
                    bFilter=rangeFilter.*domainFilter((iMin:iMax)-i+wSz+1,(jMin:jMax)-j+wSz+1);
                    fNorm=sum(bFilter(:));
                    channelValue(i,j)=sum(sum(bFilter.*I))/fNorm;
                end
            end
        end

        function bImg = applyBilateralRGB(img)
            img = double(img);
            img = img/255;
            bImg = img;

            R=img(:, :, 1);
            G=img(:, :, 2);
            B=img(:, :, 3);

            wSz = 9;
            newR = friFilter.bilateralChannel(wSz, 30, 1, R);
            newG = friFilter.bilateralChannel(wSz, 30, 1, G);
            newB = friFilter.bilateralChannel(wSz, 30, 1, B);

            bImg(:, :, 1) = newR;
            bImg(:, :, 2) = newG;
            bImg(:, :, 3) = newB;
        end
 
        function binaryImg = applyBinary(img)
            height = size(img, 1); 
            width = size(img, 2); 
            if friFilter.isGray(img) == false
                img = rgb2gray(img);
            end

            img = double(img);
            sumGray = 0; 

            for i = 1:height 
                for j = 1:width 
                    sumGray = sumGray + img(i, j); 
                end
             end

            threshold = sumGray/(width*height); 
            binaryImg = zeros(height, width); 
   
            for i = 1:height 
                for j = 1:width 
                    if img(i, j) >= threshold 
                        binaryImg(i, j) = 1; 
                    else
                        binaryImg(i, j) = 0; 
                    end
                end
            end
        end
        
        function mirrorImg = applyMirror(img)
            height = size(img, 1);
            width = size(img, 2);

            for i = 1:height
                w = width;
                for j = 1:width
                    if w > 1
                        w = w - 1;
                    end
                    mirrorImg(i, j, :) = img(i, w, :);
                end
            end
        end
    end
end