function c = h_image(img)

c = image(img);
axis image;
set(gca, 'unit','normalized','position',[0 0 1 1], 'YTickLabel', '', 'YTick',[],'XTickLabel', '', 'XTick',[]);