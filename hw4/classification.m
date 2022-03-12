% 1. deal
skyTrain = imread('sky/sky_train.jpg');
skyTrainNoSky = imread('sky/sky_train_no_sky.jpg');
%imshow(skyTrain)
%imshow(skyTrainNoSky)
sky = [];
noSky = [];
white = [255 255 255];
skyIndex = 1;
noSkyIndex = 1;

% 2. train
for i = 1:size(skyTrain,1)
    for j = 1:size(skyTrain,2)

        if all(skyTrainNoSky(i,j,:) == white)
            sky(skyIndex,:) = skyTrain(i,j,:);
            skyIndex = skyIndex + 1;
        else
           noSky(noSkyIndex,:) = skyTrain(i,j,:);
           noSkyIndex = noSkyIndex + 1;
        end
    end
end

% 3. kmeans
[cluster1, center1] = kmeans_code(sky, 10, 10);
[cluster2, center2] = kmeans_code(noSky, 10, 10);

% 4. classification
for index = 1:4
    img = imread(fullfile('sky',strcat('sky_test',num2str(index),'.jpg')));
    for i = 1:size(img,1)
    for j = 1:size(img,2)
       dis1=99999;
       dis2=99999;
       for k=1:size(center1)
           dis1 = min(norm(double(img(i,j)).' - center1(k).'), dis1);
       end
       for k=1:size(center1)
           dis2 = min(norm(double(img(i,j)).' - center2(k).'), dis2);
       end
       if dis1 < dis2
           img(i,j,:)=[128 0 128];
       end
    end
    end 
    % 5. paint
    figure(index)
    imshow(img)
end
