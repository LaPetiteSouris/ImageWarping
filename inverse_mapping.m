function IMG=inverse_mapping(IM, im , H, xmin, ymin, xmax, ymax);
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
for m = 1:M
    x_new(2) = m  - 1;
    for n = 1 : N
        x_new(1) = n  - 1;
        for c = 1 : C
            x_org = H \ x_new;
            x = x_org(1) / x_org(3);
            fx = x - fix(x);
            y = x_org(2) / x_org(3);
            fy = y - fix(y);
            if (xmin <= x && x <= xmax && ymin <= y && y <= ymax)
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