tic
IM=zeros(size(rgb));
nb_of_rect=size(H,1);
IMG=IM;
number_of_rect=size(rectangles_table,1);
for i=1:1:number_of_rect
    
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
    x_cen=round(sum_x_rect_des/4);
    y_cen=round(sum_y_rect_des/4);
    
    IMG=inverse_mapping(IMG,rgb, H{i},xmin,ymin,xmax,ymax, x_cen-50, y_cen-50,x_cen+50,y_cen+50);
end

figure
imshow(IMG)

tn=toc