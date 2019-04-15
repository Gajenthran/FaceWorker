% Classe permettant de reconnaitre une image dans la base 
% de donnees en utilisant la methode d'Eigenfaces
classdef fwEigen
	properties
		faceDatabasePath; % chemin menant vers la base de donnees
		faceDatabase; % les images presents dans la base de donnees
		faceDatabaseSignature; % les valeurs des images dans la base de donnees
		testPath; % chemin menant vers l'image a reconnaitre
		testImage; % l'image a reconnaitre
		V; % eigenvectors afin de reconnaitre l'image
		matchedFaceIndex; % l'indice de l'image reconnue dans la base de donnees
		matchedFace; % l'image reconnue dans la base de donnees
		meanValue; % la valeur moyenne
		fileCreated; % booleen pour savoir si une nouvelle image a ete creee
		% NB : Si le fichier a reconnaitre n'est pas dans le bon format (.pgm), on convertit le fichier
		% en .pgm. Une fois l'application terminee, il faut supprimer le fichier cree.
	end

	methods
		% Constructeur : generation de la base de donnees et de l'image a reconnaitre
		function obj = fwEigen(faceDatabasePath, testPath) 
			obj.faceDatabasePath = faceDatabasePath;
			obj.testPath = testPath;
			obj.fileCreated = 0;
			obj.faceDatabase = obj.loadFaceDatabase(obj.faceDatabasePath);
			[obj.testImage, obj.testPath, obj.fileCreated] = obj.loadTestImage(obj.testPath);
		end
		
		% Reconnaissance de l'image grace a la base de donnees
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
		% Retourne l'image dans la BDD qui matche avec l'image selectionnee
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

		% Transforme l'image pour faciliter le deroulement d'Eigenfaces
		function destImg = transformImage(obj, srcImg)
			srcImg = fwFilter.applyGrayscale(srcImg);
			% srcImg = obj.cropFace(srcImg);
			srcImg = imresize(srcImg, [112, 92]);
			srcImg = reshape(srcImg, size(srcImg,1) * size(srcImg,2), 1);
			destImg = uint8(srcImg);
		end

		% Detecte le visage dans l'image et coupe l'image pour conserver
		% seulement le visage. 
		% Pour l'instant, inutiliser.
		function destImg = cropFace(obj, srcImg)
			ObjectDetector = vision.CascadeObjectDetector;
			inObject = step(ObjectDetector, srcImg);
			[height, width] = size(srcImg);
			destImg = srcImg;
			if isempty(inObject) == true && height ~= 112 && width ~= 92
				disp("It is not a face !");
				close all;
			elseif isempty(inObject) == false && height > 111 && width > 90
				destImg = imcrop(srcImg, inObject(1, :));
			end
		end

		% Convertit l'image en .pgm 
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
			  
		% Charge l'image a tester
		function [testImage, testPath, fileCreated] = loadTestImage(obj, pathName)
			[testPath, fileCreated] = obj.convert2pgm(pathName);
			testImage = imread(testPath);
			testImage = obj.transformImage(testImage);
		end

		% Charge les images presents dans la base de donnees
		function faceDatabase = loadFaceDatabase(obj, pathName)
			persistent databaseCreated;
			persistent images;

			imgW = 92;
			imgH = 112;

			if(isempty(databaseCreated))
				faceSet = imageSet(pathName, 'recursive');
				dbFolder = dir;
				nbFolder = length(dbFolder)-2;
				images = zeros(imgW * imgH, nbFolder)

				for i = 1:size(faceSet,2)
					for j = 1:faceSet(i).Count
						img = read(faceSet(i), j);
						[height, width] = size(img);
						if size(img, 3) > 1
							img = rgb2gray(img);
						end
						% img = obj.cropFace(img);
						if height ~= 112 && width ~= 92
							img = imresize(img, [112, 92]);
						end

						images(:,(i-1)*10+j) = reshape(img, size(img,1)*size(img,2), 1);
					end
				end
				images = uint8(images);
			end
			databaseCreated = 1;
			faceDatabase = images;
		end

		% Charge les images presents dans la base de donnees grace 
		% a la commande cd (change directory)
		% Inutiliser car remplacer par loadFaceDatabase
		function faceDatabase = loadFaceDatabaseCD(obj, pathName)
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
					cd(strcat('s', num2str(i)));

					for j = 1:trainingFace
						img = imread(strcat(num2str(j), '.pgm'));
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