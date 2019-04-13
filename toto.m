           for i=1:size(D,1)
               eigVal(i) = D(i,i); % Get vector of diagonal elements
            end

            [B, IX] = sort(eigVal,'descend');
            obj.eigValues = B;
            for j = 1:size(V,2)
                eigVec(:,j) = V(:,IX(:,j)); % sort columns of the eigenvalue matrix
            end
            
            for i =1:size(eigVec,2)
               v = X'*eigVec(:,i);
               obj.eigVectors(:,i) = v/norm(v); % Vk reduced eigenvector
            end
            
            %% M values calculates
            thres = 0.95;
            sumV = sum(obj.eigValues);
            sumT = 0;
            M = 1;
            while(sumT < sumV*thres)
               sumT = sumT + obj.eigValues(M);
               M = M + 1;
            end
            
            %M = 58; % Cheating in here =)
            obj.bestM = M;
            %% Trainin set features create
            feature = zeros(1,M);
            for i = 1:size(obj.trainData,2) % Creation of the training images feature vectors
                for j=1:size(obj.trainData,2)
                   feature(j) = dot(obj.trainData{i}.vector-obj.meanFace,obj.eigVectors(:,j)); % bm values
                end
                obj.trainData{i}.features = feature;
            end
            
            %% Test image feature extraction
           for i=1:size(obj.testData,2)
               testVec = obj.testData{i}.vector - obj.meanFace;

               for j=1:size(obj.trainData,2)
                   feature(j) = dot(testVec,obj.eigVectors(:,j)); % bm values
               end
               obj.testData{i}.features = feature;
           end
        end
        