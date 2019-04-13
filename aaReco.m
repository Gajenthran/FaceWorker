% Face cropping, Color image, Dimensions image, Values, Name
loaded_Image=load_database();
% random_Index=round(400*rand(1,1));
% random_Image=loaded_Image(:,random_Index);
ObjectDetector = vision.CascadeObjectDetector;
pathName = 'test.jpg';
[filepath, name, ext] = fileparts(pathName);
fileCreated = 0;
if strcmp(ext, '.pgm') == false
	file2 = strrep(pathName, ext,'.pgm');
	copyfile(pathName, file2);
    pathName = file2;
    fileCreated = 1;
end

randomImage = (imread(pathName));

if(size(randomImage, 3) > 1)
	randomImage = rgb2gray(randomImage);
end

inObject = step(ObjectDetector, randomImage);

if isempty(inObject) == true
	disp("It is not a face !");
	close all;
end

randomImage = imcrop(randomImage, inObject(1, :));
randomImage = imresize(randomImage, [112, 92]);

randomImage = reshape(randomImage,size(randomImage,1)*size(randomImage,2),1);
randomImage = uint8(randomImage);

% rest_of_the_images=loaded_Image(:,[1:random_Index-1 random_Index+1:end]);
image_Signature=20;
% white_Image=uint8(ones(1,size(rest_of_the_images,2)));
white_Image=uint8(ones(1,size(loaded_Image,2)));
% mean_value=uint8(mean(rest_of_the_images,2));
mean_value=uint8(mean(loaded_Image,2));
mean_Removed=loaded_Image-uint8(single(mean_value)*single(white_Image));

L=single(mean_Removed)'*single(mean_Removed);
[V,D]=eig(L);
V=single(mean_Removed)*V;
V=V(:,end:-1:end-(image_Signature-1));
% all_image_Signatire=zeros(size(rest_of_the_images,2),image_Signature);
all_image_Signatire=zeros(size(loaded_Image,2),image_Signature);
for i=1:size(loaded_Image,2)
	all_image_Signatire(i,:)=single(mean_Removed(:,i))'*V;
end

subplot(121);
% imshow(reshape(random_Image,112,92));
imshow(reshape(randomImage,112,92));
title('Looking for this Face','FontWeight','bold','Fontsize',16,'color','red');

% p=random_Image-mean_value;
p=randomImage-mean_value;
s=single(p)'*V;
z=[];
% for i=1:size(rest_of_the_images,2)
for i=1:size(loaded_Image,2)
	z=[z,norm(all_image_Signatire(i,:)-s,2)];
	% if(rem(i,20)==0),imshow(reshape(rest_of_the_images(:,i),112,92)),end;
	% drawnow;
end

[a,i]=min(z);
subplot(122);
% imshow(reshape(rest_of_the_images(:,i),112,92));
imshow(reshape(loaded_Image(:,i),112,92));
title('Recognition Completed','FontWeight','bold','Fontsize',16,'color','red');
if fileCreated == 1
    delete(pathName);
end

function output_value = load_database()
persistent loaded;
persistent numeric_Image;
if(isempty(loaded))
    cd('Dataset');
	dbFolder = dir;
	nbFolder = length(dbFolder)-2;
	all_Images = zeros(10304, nbFolder);
	for i=1:nbFolder
		cd(strcat('s',num2str(i)));
		for j=1:10
			image_Container = imread(strcat(num2str(j),'.pgm'));
			if(size(image_Container, 3) > 1)
				image_Container = rgb2gray(image_Container);
			end
			all_Images(:,(i-1)*10+j)=reshape(image_Container,size(image_Container,1)*size(image_Container,2),1);
		end
		display('Loading Database');
		cd ..;
    end
    cd ..;
	numeric_Image = uint8(all_Images);
end
loaded = 1;
output_value = numeric_Image;
end