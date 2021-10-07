function h_imstack3Loader(num, siz, overlapFlag)
global jbm;
jbm.numberOfInstances = num;
% this function load several h_imstack3 instances and spread them on screen

% screenSiz = [1920 1080];% lab 27" monitor
% screenSiz = [1440 900];%notebook
screenSiz = get(0, 'screensize');
screenSiz = screenSiz(3:4);
spacing = [20, 65]; %[x, y]

if ~exist('siz', 'var') || isempty(siz)
    ysiz = (screenSiz(2)-40)/2 - spacing(2);%bottom 40 pixels or so is for manual bar
%     siz = [700, 700*551/801];
    siz = [ysiz/650*801, ysiz];
else
    siz(2) = siz(1)*551/801;
end


if ~exist('overlapFlag', 'var') || isempty(overlapFlag)
    overlapFlag = 'long';
% else
%     overlapFlag = 'short';
end

if strcmpi(overlapFlag, 'short')
    overlapX = (801 - 475) * siz(1) / 801;
else
    overlapX = 0;
end

shortSiz = 475*siz(1)/801;



n_col = round((screenSiz(1)+spacing(1)-shortSiz/2)/(siz(1)-overlapX+spacing(1)));%to ensure the images is mostly included.
n_row = round((screenSiz(2) - 40 +spacing(2))/(siz(2)+spacing(2)));

for i = 1:num
    h = h_imstack3;
    pos = [];
    if i<=n_col*n_row
        pos(1) = mod(i-1,n_col)*(siz(1)-overlapX+spacing(1)) + 10;
        pos(2) = screenSiz(2) - (floor((i-1)/n_col)+1)*(siz(2)+spacing(2)) + 100;
        pos(3:4) = siz;
        set(h, 'position', pos);
    else
        pos = get(h, 'position');
        pos(3:4) = siz;
        set(h, 'position', pos);        
    end
end