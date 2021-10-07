function colorim = h_createGOMImage(red,green,blue,climitr,climitg,climitb)

warning off MATLAB:divideByZero;
green = double(green);
red = double(red);
blue = double(blue);

if ~(exist('climitg')==1)|isempty(climitg)
    temp2 = sort(green(:));
    climitg = [temp2(round(0.05*length(temp2))),temp2(round(0.99*length(temp2)))];
end

if ~(exist('climitr')==1)|isempty(climitr)
    temp2 = sort(red(:));
    climitr = [temp2(round(0.05*length(temp2))),temp2(round(0.99*length(temp2)))];
end

if ~(exist('climitb')==1)|isempty(climitb)
    temp2 = sort(blue(:));
    climitb = [temp2(round(0.05*length(temp2))),temp2(round(0.99*length(temp2)))];
end

green_im = uint8((green - climitg(1))* 255 /(climitg(2) - climitg(1)) );
red_im = uint8((red - climitr(1)) * 255 /(climitr(2) - climitr(1)) );
blue_im = uint8((blue - climitb(1)) * 255 /(climitb(2) - climitb(1)) );

% green(green > 1) = 1;
% green(green < 0) = 0;
% 
% red (red >=1) = 1;
% red (red < 0) = 0;
% 
% blue(green > 1) = 1;
% blue(green < 0) = 0;

if ~isempty(red)
    colorim(:, :, 1) = red_im - green_im;
end
if ~isempty(green)
    colorim(:, :, 2) = green_im;
end
if ~isempty(blue)
    colorim(:, :, 3) = blue_im + red_im - green_im;
end 



;

warning on MATLAB:divideByZero;