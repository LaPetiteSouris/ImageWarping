IM=zeros(size(rgb));
nb_of_rect=size(H,1);
IMG=IM;
number_of_rect=size(rectangles_table,1);
for i=1:1:number_of_rect
    
    xmin=points(rectangles_table(i,1),1);
    xmax=points(rectangles_table(i,3),1);
    ymin=points(rectangles_table(i,1),2);
    ymax=points(rectangles_table(i,3),2);
    IMG=inverse_mapping(IMG,rgb, H{i},xmin,ymin,xmax,ymax);
end

figure
imshow(IMG)