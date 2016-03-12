function IMG=inverse_mapping(IM, im , H, xmin_ori, ymin_ori, xmax_ori, ymax_ori, xmin_des, ymin_des, xmax_des, ymax_des);
% Arguments:
% im - single image
% H - homography
% IM - current mosaiced image
% xmin min x coordinate of the original square
% ymin min y coordinate of the original square
% Size of single image
[M,N,C] = size(im);
% Size of mosaiced image
IMG = IM;
% Assign pixel values
x_new = [0 0 1]'; % Homogeneous coordinate in new plane
for m = ymin_des : ymax_des
    x_new(2) = m  - 1;
    for n =xmin_des:xmax_des
        x_new(1) = n  - 1;
        for c = 1 : C
            x_org = H \ x_new;
            x = x_org(1) / x_org(3);
            fx = x - fix(x);
            y = x_org(2) / x_org(3);
            fy = y - fix(y);
            if (xmin_ori <= x && x <= xmax_ori && ymin_ori <= y && y <= ymax_ori)
                % Use bilinear interpolation
                IMG(m,n,c) = (1 - fx) * (1 - fy) * im(fix(y),fix(x),c) +...
                    (1 - fx) * fy * im(ceil(y),fix(x),c) +...
                    fx * (1 - fy) * im(fix(y),ceil(x),c) +...
                    fx * fy * im(ceil(y),ceil(x),c);
            end
        end
    end
end
IMG = uint8(IMG);
end