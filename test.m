clear all
clc

rgb = imread('test.jpg');  %# Load a sample 3-D RGB image
imshow(rgb)
hold on
M = size(rgb,1);
N = size(rgb,2);
%Vector of coordinate point
points=[];
index=1;
% i is is along x axis
% j is along y axis
for i=1:100:M
    for j=1:100:N
        points(index,:)=[j i];
        plot(j,i,'go')
        index=index+1;
    end
end

for k = 1:100:M
    x = [1 N];

    y = [k k];

    plot(x,y,'Color','r','LineStyle','-');
    plot(x,y,'Color','r','LineStyle','-');
end

for k = 1:100:N
    x = [k k];
    y = [1 M];
    plot(x,y,'Color','r','LineStyle','-');
    plot(x,y,'Color','r','LineStyle','-');
end

