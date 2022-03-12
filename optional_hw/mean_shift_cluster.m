% read images
Files = dir(fullfile('pic2\\*.jpg'));
LengthFiles = length(Files);

len = 256;
wid = 256;
Imgs = cell(1,LengthFiles);

bin = 8;
RGB_unit = 256 / bin;

% color histogram
X = zeros(bin,bin,bin,LengthFiles);

for i = 1:LengthFiles
    Img = imread(strcat('pic2\\',Files(i).name));
    Img = imresize(Img,[len,wid]);
    Imgs{i}=Img;
    for j = 1:len
        for k = 1:wid
            R = fix(single(Img(j,k,1))/single(RGB_unit))+1;
            G = fix(single(Img(j,k,2))/single(RGB_unit))+1;
            B = fix(single(Img(j,k,3))/single(RGB_unit))+1;
            temp = X(R, G, B,i);
            X(R, G, B, i) = temp+1;
        end
    end
end

[clus] = mean_shift(X);
parents = unique(clus);
for i = 1:size(parents)
    figure(i);
    count = 1;
    for j = 1:size(clus)
        if clus(j) == parents(i)
            im = Imgs{j};
            subplot(6,6,count),imshow(im);
            count = count + 1;
        end
    end

end

