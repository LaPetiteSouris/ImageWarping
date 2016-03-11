function H=findHomographie(points1, points2, rectangles_table)
%% For each quadrilateral couples, matrix Homography H projects pixel from 
%% image 1 to image 2(points 1 to points 2)
%% :retunr: cell array of Homography matrix H for each quadrilateral
number_of_rect=size(rectangles_table,1);
H=cell(number_of_rect,4);
for i=1:1:number_of_rect
    x1_vector=[];
    x2_vector=[];
    for u=1:1:4
        x1=[ points1(rectangles_table(i,u),1)  points1(rectangles_table(i,u),2)];
        x2=[ points2(rectangles_table(i,u),1)  points2(rectangles_table(i,u),2)];
        x1_vector=[x1_vector; x1];
        x2_vector=[x2_vector; x2];
    end
    H{i}=getH_Homo(x2_vector',x1_vector');
end
end
