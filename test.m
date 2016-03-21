tic
% Create an empty destination image
IMG=zeros(size(rgb));
% Number of quadrilateral in the mesh
nb_of_rect=size(H,1);
number_of_rect=size(rectangles_table,1);
% Perform inverse Homography transformation for each quadrilateral
for i=1:1:number_of_rect
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

figure
imshow(IMG)

tn=toc