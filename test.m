IM=zeros(size(rgb));

IMG=inverse_mapping(IM,rgb, H{1},1,1,101,101);
figure
imshow(IMG)