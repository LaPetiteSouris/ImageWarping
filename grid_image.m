clear all
clc
% Load a sample 3-D RGB image
rgb = imread('test2.jpg');
imshow(rgb)
hold on
M = size(rgb,1);
N = size(rgb,2);
%Vector of coordinate point of the mesh
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
        % (j+ly,i) (j+ly,i+lx) (j,i+lx)
        
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
% read ginputs until a mouse right-button occurs
% right click to end
button = 1;
while sum(button) <=1
    [x,y,button] = ginput(1);
    x=round(x);
    y=round(y);
    plot(x,y,'go','linewidth',8);
    x_c=[x_c x];
    y_c=[y_c y];
end
% Coordinates of point after mesh distortion
points_new=points;
% Transform mesh according the selected point
% Find in the original mesh nearest point to every new point user select
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
% Redraw the mesh
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

% For the given mesh, calculate a list of Homography matrix corresponds to
% every quadrilateral mesh
H=findHomographie(points, points_new, rectangles_table);

% Small UI
uiwait(msgbox('New mesh created ! Click OK to start warping. ','Mesh Created','modal'));
drawnow
h = waitbar(0,'Performing inverse mapping. Please wait...');

tic
% Create an empty destination image
IMG=zeros(size(rgb));
% Number of quadrilateral in the mesh
nb_of_rect=size(H,1);
number_of_rect=size(rectangles_table,1);
% Perform inverse Homography transformation for each quadrilateral
for i=1:1:number_of_rect
    waitbar(i / number_of_rect)
    % (xmin,ymin) is coordinate of lowest corner point
    % of the original rectangle mesh
    % (xmax,ymax) is coordinate of higesh corner point
    % of the original rectangle mesh
    xmin=points(rectangles_table(i,1),1);
    xmax=points(rectangles_table(i,3),1);
    ymin=points(rectangles_table(i,1),2);
    ymax=points(rectangles_table(i,3),2);
    sum_x_rect_des=0;
    sum_y_rect_des=0;
    for k=1:1:4
        sum_x_rect_des=points(rectangles_table(i,k),1)+sum_x_rect_des;
        sum_y_rect_des=points(rectangles_table(i,k),2)+sum_y_rect_des;
    end
    % Center point of the new quadrilateral after distortion
    x_cen=round(sum_x_rect_des/4);
    y_cen=round(sum_y_rect_des/4);
    % Perform inverse transformation from destination image
    % in a region covered by the rectangle center (x_cen; y_cen) with
    % length 2*ly, heigh 2* lx
    IMG=inverse_mapping(IMG,rgb, H{i},xmin,ymin,xmax,ymax, x_cen-50, y_cen-50,x_cen+50,y_cen+50);
end
close(h)

figure
imshow(IMG)
toc
