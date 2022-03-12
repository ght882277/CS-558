% 1. load png to rgb
RGB=imread('white-tower.png');
% 2. flatten
T=reshape(RGB, size(RGB,1)*size(RGB,2),size(RGB,3));
% 3. kmeans
[clusters,centers]=kmeans_code(T,10,10);
% 4. print
uint8(centers)