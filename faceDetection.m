%% Charger les fichiers
path = 'att_faces';
faceGallery = imageSet(path, 'recursive');
galleryNames = {faceGallery.Description};
% displayFaceGallery(faceGallery,galleryNames);

%% Charger les sets d'entrainements (2);
% [training,test] = partition(faceGallery,[0.8 0.2]);
% trainingFeatures = zeros(19,10404);
% trainingFeatures = zeros(size(training,2)*training(1).Count,10000);

featureCount = 1;
for i=1:size(faceGallery,2)
    for j = 1:faceGallery(i).Count
        a = read(faceGallery(i),j);
        if(size(a, 3)) > 1
            a = rgb2gray(a);
        end
        sizeNormalizedImage = imresize(a,[150 150]);
        trainingFeatures{featureCount}.image = sizeNormalizedImage;
        trainingFeatures{featureCount}.label = faceGallery(i).Description;
        trainingFeatures{featureCount}.vector = [];
        for k=1:size(trainingFeatures{featureCount}.image,1)
            trainingFeatures{featureCount}.vector = [trainingFeatures{featureCount}.vector trainingFeatures{featureCount}.image(k,:)]; 
        end
        trainingFeatures{i}.features = [];
        % trainingLabel{featureCount} = faceGallery(i).Description;    
        % trainingFeatures(featureCount,:) = extractHOGFeatures(a);
        featureCount = featureCount + 1;
    end
    personIndex{i} = faceGallery(i).Description;
end

figure; imshow(trainingFeatures{5}.image);


%% Entrainements avec les images récupérées 
m = zeros(featureCount, 1);
for i = 1:size(faceGallery, 2)
    X(i, :) = trainingFeatures{i}.vector;
    m = m + trainingFeatures{i}.vector;
end
m = m / size(faceGallery, 2);
for i = 1:size(faceGallery, 2)
    X(i,:) = X(i,:) - m;   
end

K = (X * X')/size(faceGallery, 2);

[V, D] = eig(K);

for i=1:size(D,1)
    eigVal(i) = D(i,i); % Get vector of diagonal elements
end

[B, IX] = sort(eigVal,'descend');
eigValues = B;
for j = 1:size(V,2)
    eigVec(:,j) = V(:,IX(:,j)); % sort columns of the eigenvalue matrix
end
            
for i =1:size(eigVec,2)
    v = X'*eigVec(:,i);
    eigVectors(:,i) = v/norm(v); % Vk reduced eigenvector
end
            
%% M values calculates
thres = 0.95;
sumV = sum(eigValues);
sumT = 0;
M = 1;
while(sumT < sumV*thres)
    sumT = sumT + eigValues(M);
    M = M + 1;
end
            
%M = 58; % Cheating in here =)
bestM = M;
%% Trainin set features create
feature = zeros(1,M);
for i = 1:size(faceGallery,2) % Creation of the training images feature vectors
    for j=1:size(faceGallery,2)
        feature(j) = dot(trainingFeatures{i}.vector-m,eigVectors(:,j)); % bm values
    end
    trainingFeatures{i}.features = feature;
end

% Test image feature extraction
% for i=1:size(faceGallery,2)
%     testVec = obj.testData{i}.vector - obj.meanFace;
%     for j=1:size(obj.trainData,2)
%         feature(j) = dot(testVec,obj.eigVectors(:,j)); % bm values
%     end
%     obj.testData{i}.features = feature;
% end 
        

    
%% 
faceClassifier = fitcecoc(trainingFeatures,trainingLabel);

%% tata
testSet = imageSet('att_faces_test');
figure;
figureNum = 1;
for  i= 1: testSet.Count
    queryImage = read(testSet,i);
    if(size(queryImage, 3)) > 1
        queryImage = rgb2gray(queryImage);
    end
    % queryImage = imresize(a, [100, 100]);
    queryFeatures = extractHOGFeatures(queryImage);
    personLabel = predict(faceClassifier,queryFeatures);
    booleanIndex = strcmp(personLabel, personIndex);
    integerIndex = find(booleanIndex);
    subplot(2, 2, figureNum);imshow(queryImage);title('Query Face');
    subplot(2,2,figureNum+1);imshow(read(faceGallery(integerIndex),1));title('Matched Class');
    figureNum = figureNum+2;

end