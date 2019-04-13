classdef friEigen
	properties
		faceDatabasePath;
		faceDatabase;
		faceDatabaseSignature;
		testPath;
		testImage;
		V;
		matchedFaceIndex;
		matchedFace;
		meanValue;
		fileCreated
	end

	methods
        function obj = friEigen(faceDatabasePath, testPath) 
            obj.faceDatabasePath = faceDatabasePath;
            obj.testPath = testPath;
            obj.fileCreated = 0;
        	obj.faceDatabase = obj.loadFaceDatabase(obj.faceDatabasePath);
        	[obj.testImage, obj.testPath, obj.fileCreated] = obj.loadTestImage(obj.testPath);
        end
        
        function obj = recognize(obj)
			rImgSignature = 20;
			faceImages = uint8(ones(1,size(obj.faceDatabase,2)));
			obj.meanValue = uint8(mean(obj.faceDatabase,2));
			meanDatabase = obj.faceDatabase - uint8(single(obj.meanValue)*single(faceImages));

			L = single(meanDatabase)' * single(meanDatabase);
			[obj.V,D] = eig(L);
			obj.V = single(meanDatabase) * obj.V;
			obj.V = obj.V(:,end:-1:end-(rImgSignature-1));

			obj.faceDatabaseSignature = zeros(size(obj.faceDatabase,2), rImgSignature);
			for i = 1:size(obj.faceDatabase, 2)
				obj.faceDatabaseSignature(i,:) = single(meanDatabase(:,i))'*obj.V;
			end
			
			s = single(obj.testImage - obj.meanValue)'*obj.V;
			obj.matchedFaceIndex = obj.getMatchedFace(size(obj.faceDatabase, 2), obj.faceDatabaseSignature, s);
			obj.matchedFace = reshape(obj.faceDatabase(:,obj.matchedFaceIndex), 112, 92);
			obj.deleteCreatedFile(obj.fileCreated, obj.testPath);
        end

    end
    
    methods (Access = 'private')
		function matchedFaceIndex = getMatchedFace(obj, N, faceDbS, s)
			weightFaces = [];
			for i = 1:N
				weightFaces = [weightFaces, norm(faceDbS(i, :)-s, 2)];
			end
			[minWeight, matchedFaceIndex] = min(weightFaces);
		end

		function [] = deleteCreatedFile(obj, fileCreated, pathName)
			if fileCreated == 1
				delete(pathName)
			end
		end

		function destImg = transformImage(obj, srcImg)
			srcImg = friFilter.applyGrayscale(srcImg); % A VERIFIER
			srcImg = obj.cropFace(srcImg);
			srcImg = imresize(srcImg, [112, 92]);
			srcImg = reshape(srcImg, size(srcImg,1) * size(srcImg,2),1);
			destImg = uint8(srcImg);
		end

		function destImg = cropFace(obj, srcImg)
			ObjectDetector = vision.CascadeObjectDetector;
			inObject = step(ObjectDetector, srcImg);
			[height, width] = size(srcImg);
			destImg = srcImg;
			if isempty(inObject) == true && height ~= 112 && width ~= 92
				disp("It is not a face !");
				close all;
			elseif isempty(inObject) == false && height > 150 && width > 100
				destImg = imcrop(srcImg, inObject(1, :));
			end
		end

		function [outputFile, fileCreated] = convert2pgm(obj, filename)
			[filepath, name, ext] = fileparts(filename);
			fileCreated = 0;
			outputFile = filename;
			if strcmp(ext, '.pgm') == false
				pgmFile = strrep(filename, ext,'.pgm');
				copyfile(filename, pgmFile);
			    outputFile = pgmFile;
			    fileCreated = 1;
			end
		end
		      
		function [testImage, testPath, fileCreated] = loadTestImage(obj, pathName)
			[testPath, fileCreated] = obj.convert2pgm(pathName);
			testImage = imread(testPath);
			testImage = obj.transformImage(testImage);
		end

		  
		function faceDatabase = loadFaceDatabase(obj, pathName)
			persistent databaseCreated;
			persistent images;

			imgW = 92; 
			imgH = 112;
			trainingFace = 10;

			if(isempty(databaseCreated))
			    cd(pathName);
				dbFolder = dir;
				nbFolder = length(dbFolder)-2;
				images = zeros(imgH * imgW, nbFolder);

				for i = 1:nbFolder
					cd(strcat('s',num2str(i)));

					for j = 1:trainingFace
						img = imread(strcat(num2str(j),'.pgm'));
						if size(img, 3) > 1
							img = rgb2gray(img);
						end
						images(:,(i-1)*10+j) = reshape(img, size(img,1)*size(img,2), 1);
					end

					cd ..;
			    end

			    cd ..;
				images = uint8(images);
			end

			databaseCreated = 1;
			faceDatabase = images;
		end
	end
end
% Croping rectangle
% Face cropping, Color image, Dimensions image, Values, Name

% faceDatabase = loadFaceDatabase('Dataset');
% 
% [randomImage, pathName, fileCreated] = loadTestImage('test.jpg');
% 
% rImgSignature = 20;
% faceImages = uint8(ones(1,size(faceDatabase,2)));
% meanValue = uint8(mean(faceDatabase,2));
% meanDatabase = faceDatabase - uint8(single(meanValue)*single(faceImages));
% 
% L = single(meanDatabase)' * single(meanDatabase);
% [V,D] = eig(L);
% V = single(meanDatabase) * V;
% V = V(:,end:-1:end-(rImgSignature-1));
% 
% faceDatabaseSignature = zeros(size(faceDatabase,2), rImgSignature);
% for i = 1:size(faceDatabase, 2)
% 	faceDatabaseSignature(i,:) = single(meanDatabase(:,i))'*V;
% end
% 
% subplot(121);
% imshow(reshape(randomImage,112,92));
% title('Looking for this Face','FontWeight','bold','Fontsize',16,'color','red');
% 
% s = single(randomImage - meanValue)'*V;
% 
% matchFaceIndex = getMatchedFace(size(faceDatabase, 2), faceDatabaseSignature, s);
% subplot(122);
% imshow(reshape(faceDatabase(:,matchFaceIndex), 112, 92));
% title('Recognition Completed','FontWeight','bold','Fontsize',16,'color','red');
% 
% deleteCreatedFile(fileCreated, pathName);


% function matchFaceIndex = getMatchedFace(N, faceDbS, s)
% 	weightFaces = [];
% 	for i = 1:N
% 		weightFaces = [weightFaces, norm(faceDbS(i, :)-s, 2)];
% 	end
% 	[minWeight, matchFaceIndex] = min(weightFaces);
% end
% 
% function [] = deleteCreatedFile(fileCreated, pathName)
% 	if fileCreated == 1
% 		delete(pathName)
% 	end
% end
% 
% function destImg = transformImage(srcImg)
% 	srcImg = friFilter.applyGrayscale(srcImg); % A VERIFIER
% 	srcImg = cropFace(srcImg);
% 	srcImg = imresize(srcImg, [112, 92]);
% 	srcImg = reshape(srcImg, size(srcImg,1) * size(srcImg,2),1);
% 	destImg = uint8(srcImg);
% end
% 
% function destImg = cropFace(srcImg)
% 	ObjectDetector = vision.CascadeObjectDetector;
% 	inObject = step(ObjectDetector, srcImg);
% 	[height, width] = size(srcImg);
% 	destImg = srcImg;
% 	if isempty(inObject) == true && height ~= 112 && width ~= 92
% 		disp("It is not a face !");
% 		close all;
% 	elseif isempty(inObject) == false && height > 150 && width > 100
% 		destImg = imcrop(srcImg, inObject(1, :));
% 	end
% end
% 
% function [outputFile, fileCreated] = convert2pgm(filename)
% 	[filepath, name, ext] = fileparts(filename);
% 	fileCreated = 0;
% 	outputFile = filename;
% 	if strcmp(ext, '.pgm') == false
% 		pgmFile = strrep(filename, ext,'.pgm');
% 		copyfile(filename, pgmFile);
% 	    outputFile = pgmFile;
% 	    fileCreated = 1;
% 	end
% end
%       
% function [testImage, testPath, fileCreated] = loadTestImage(pathName)
% 	[testPath, fileCreated] = convert2pgm(pathName);
% 	testImage = imread(testPath);
% 	testImage = transformImage(testImage);
% end
% 
%   
% function faceDatabase = loadFaceDatabase(pathName)
% 	persistent databaseCreated;
% 	persistent images;
% 
% 	imgW = 92; 
% 	imgH = 112;
% 	trainingFace = 10;
% 
% 	if(isempty(databaseCreated))
% 	    cd(pathName);
% 		dbFolder = dir;
% 		nbFolder = length(dbFolder)-2;
% 		images = zeros(imgH * imgW, nbFolder);
% 
% 		for i = 1:nbFolder
% 			cd(strcat('s',num2str(i)));
% 
% 			for j = 1:trainingFace
% 				img = imread(strcat(num2str(j),'.pgm'));
% 				if size(img, 3) > 1
% 					img = rgb2gray(img);
% 				end
% 				images(:,(i-1)*10+j) = reshape(img, size(img,1)*size(img,2), 1);
% 			end
% 
% 			cd ..;
% 	    end
% 
% 	    cd ..;
% 		images = uint8(images);
% 	end
% 	
% 	databaseCreated = 1;
% 	faceDatabase = images;
% end