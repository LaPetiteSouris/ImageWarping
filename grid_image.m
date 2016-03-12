clear all
clc

rgb = imread('test2.jpg');  %# Load a sample 3-D RGB image
imshow(rgb)
hold on
M = size(rgb,1);
N = size(rgb,2);
%Vector of coordinate point
points=[];
index=1;

lx=round(M/10);
ly=round(N/10);
% i is is along x axis
% j is along y axis
for i=1:lx:M
    for j=1:ly:N
        points(index,:)=[j i];
        index=index+1;
    end
end


% Each line consist of 4 element, these are 4 corners points
% of the rectlanges. Values are index in vector points.
% Example rectangle(1,:)=[1,2,3,4] : four corner point of the first
% rectangle is points(1,:) points(2,:), points(3,:), points(4,:)

rectangles_table=[];
rect_indx=1;

for i=1:lx:M
    for j=1:ly:N
        % for each point (j,i), find 3 other corner of rectangle
        % (j+100,i) (j+100,i+100) (j,i+100)
        
        [~, index1]=ismember([j i], points, 'rows');
        [~, index2]=ismember([j+ly i],points, 'rows');
        [~, index3]=ismember([j+ly i+lx],points, 'rows');
        [~, index4]=ismember([j i+lx],points, 'rows');
        if index1~=0&& index2~=0&&index3~=0&&index4~=0
            rectangles_table(rect_indx,:)=[index1 index2 index3 index4];
            rect_indx=rect_indx+1;
        end
        
        
    end
end
h_v=[];
for i=1:1:rect_indx-1
    for u=1:1:4
        h=plot(points(rectangles_table(i,u),1),points(rectangles_table(i,u),2),'ro','linewidth',8 );
        h_v=[h_v h];
    end
end
% % Change mesh
x_c=[];
y_c=[];

button = 1;
while sum(button) <=1   % read ginputs until a mouse right-button occurs
    [x,y,button] = ginput(1);
    x=round(x);
    y=round(y);
    plot(x,y,'go','linewidth',8);
    x_c=[x_c x];
    y_c=[y_c y];
end
points_new=points;
for k=1:1:length(x_c)
    d_min=distance(points_new(1,1),points_new(1,2),x_c(k),y_c(k));
    i_nearest=0;
    u_nearest=0;
    for i=1:1:rect_indx-1
        for u=1:1:4
            
            d=distance(points_new(rectangles_table(i,u),1),points_new(rectangles_table(i,u),2),x_c(k),y_c(k));
            if d< d_min
                d_min=d;
                i_nearest=i;
                u_nearest=u;
            end
            
        end
    end
    points_new(rectangles_table(i_nearest, u_nearest),1)=x_c(k);
    points_new(rectangles_table(i_nearest, u_nearest),2)=y_c(k);
end
delete(h_v)

for i=1:1:rect_indx-1
    x_rectangle_vector_to_plot=[];
    y_rectangle_vector_to_plot=[];
    for u=1:1:4
        x_rectangle_vector_to_plot=[x_rectangle_vector_to_plot points_new(rectangles_table(i,u),1)];
        y_rectangle_vector_to_plot=[y_rectangle_vector_to_plot points_new(rectangles_table(i,u),2)];
    end
    plot(x_rectangle_vector_to_plot, y_rectangle_vector_to_plot,'r');
end

H=findHomographie(points, points_new, rectangles_table);
