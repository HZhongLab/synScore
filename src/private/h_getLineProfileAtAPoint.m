function [Intensity, Xi, Yi] = h_getLineProfileAtAPoint(Img, pos, angle, width)

% Img:      a 2D image, i.e. size(Img, 3) == 1.
% pos:      (x, y), the center position where the line profile is produced.
% angle:    in degrees defining the angle of the line.
% width:    in pixels, the length of the line profile.

if ~exist('width','var') || isempty(width)
    width = 12;
end

width = round(width/2)*2; % set width always an even integer (so the profile always go through pos.
deltaX = width .* cosd(angle);
deltaY = width .* sind(angle);
startPos = pos - [deltaX, deltaY]/2;
endPos = pos + [deltaX, deltaY]/2;

% Xi = startPos(1):(endPos(1)-startPos(1))/width:endPos(1);
% Yi = startPos(2):(endPos(2)-startPos(2))/width:endPos(2);

[Xi, Yi, Intensity] = improfile(Img, [startPos(1), endPos(1)], [startPos(2), endPos(2)], width+1, 'Bicubic');
% Note: improfile tends to be slow. If that becomes a limiting factor, then
% we can think of ways to improve it.