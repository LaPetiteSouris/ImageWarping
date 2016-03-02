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
        index=index+1;
    end
end

for k = 1:100:M
    x = [1 N];
    
    y = [k k];
    
    plot(x,y,'Color','g','LineStyle','-');
    plot(x,y,'Color','g','LineStyle','-');
end

for k = 1:100:N
    x = [k k];
    y = [1 M];
    plot(x,y,'Color','g','LineStyle','-');
    plot(x,y,'Color','g','LineStyle','-');
end
% Each line consist of 4 element, these are 4 corners points
% of the rectlanges. Values are index in vector points.
% Example rectangle(1,:)=[1,2,3,4] : four corner point of the first
% rectangle is points(1,:) points(2,:), points(3,:), points(4,:)

rectangles_table=[];
rect_indx=1;

for i=1:100:M
    for j=1:100:N
        % point origin(j,i), find 3 other corner of rectangle
        % (j+100,i) (j+100,i+100) (j,i+100)
        
        [~, index1]=ismember([j i], points, 'rows');
        [~, index2]=ismember([j+100 i],points, 'rows');
        [~, index3]=ismember([j+100 i+100],points, 'rows');
        [~, index4]=ismember([j i+100],points, 'rows');
        if index1~=0&& index2~=0&&index3~=0&&index4~=0
            rectangles_table(rect_indx,:)=[index1 index2 index3 index4];
            rect_indx=rect_indx+1;
        end
        
        
    end
end

for i=1:1:rect_indx-1
    for u=1:1:4
        
        plot(points(rectangles_table(i,u),1),points(rectangles_table(i,u),2),'ro','linewidth',8 );
    end
end



