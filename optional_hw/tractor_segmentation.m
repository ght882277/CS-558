% 1. deal
len = 256;
wid = 256;
castle = imread('pic1\castle-P19 (8).jpg');
castle = imresize(castle,[len,wid]);
tractor = imread('pic1\tractor.jpg');
tractor = imresize(tractor,[len,wid]);

%imshow(skyTrain)
%imshow(skyTrainNoSky)
clatle_bg = [];
tra_fg = [];
white = [255 255 255];
skyIndex = 1;
noSkyIndex = 1;

% 2. train
for i = 1:size(castle,1)
    for j = 1:size(castle,2)

        if all(tractor(i,j,:) == white)
            clatle_bg(skyIndex,:) = castle(i,j,:);
            skyIndex = skyIndex + 1;
        else
           tra_fg(noSkyIndex,:) = castle(i,j,:);
           noSkyIndex = noSkyIndex + 1;
        end
    end
end

% 3. kmeans
[cluster1, center1] = kmeans_code(clatle_bg, 4, 4);
[cluster2, center2] = kmeans_code(tra_fg, 4, 4);

% 4. classification
for index = 1:5
    img = imread(fullfile('pic1\',strcat('castle-P19 (',num2str(index),').jpg')));
    img = imresize(img,[len,wid]);
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
