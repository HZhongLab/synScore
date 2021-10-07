function [XfieldOfView, YfieldOfView] = calculateFieldOfView(ScanImageZoom)

% calculates field of view in um for given ScanImageZoom
% A.Sobczyk <sobczyk@cshl.edu>

% PLEASE INCLUDE NAME DATE AND RIG OF CALIBRATION



set(0, 'DefaultFigureColor', 'w');
% JBM 071515 Naga (In-Vivo Two-Photon Rig On 3rd Floor [MIMMS])
% On fine, accounting for dead travel by charging 30 um prior to bead entry
% in frame
% 3 - 5 trials per magnification per dimension
% 512x512 at all magnifications
Xzoom2 = mean([179 179.72 182 183 179]);
Xzoom4 = mean([92.96 91.56 91.28 90.24]);
Xzoom8 = mean([46.60 47.0 44.68 44.68 44.48]);
Xzoom10 = mean([37.28 37.64 36.12 36.52 35.52]);
Xzoom20 = mean([18.0 19.08 17.88 17.88 17.60]);
Xzoom40 = mean([9.08 9.20 8.60 8.64]);
Xzoom80 = mean([4.40 4.64 4.28 4.56 4.48]);

Yzoom2 = mean([180.8 178.8  179.56 179.6]);
Yzoom4 = mean([87.52 87.72 94.28 96.52 86.4 86.32 87.36]);
Yzoom8 = mean([47.64 45.88 41.8 42.56 41.48 44.04]);
Yzoom10 = mean([39.20 35.24 36.12 34.52 37.76 35.76]);
Yzoom20 = mean([19.52 16.88 16.36 16.32 ]);
Yzoom40 = mean([9.88 8.56 8.36 8.40]);
Yzoom80 = mean([5.16 4.88 4.56 4.00 4.36 4.24]);

magnification = [2 4 8 10 20 40 80];
xscale = [Xzoom2 Xzoom4 Xzoom8 Xzoom10 Xzoom20 Xzoom40 Xzoom80];
yscale = [Yzoom2 Yzoom4 Yzoom8 Yzoom10 Yzoom20 Yzoom40 Yzoom80];


% JBM and CCC, 060915, Naga 
% magnification = [2 4 8 10 20 40 60 80 100];
% xscale = [182.16 92.88 46.44 37.32 19.9 10.56 7.08 5.16 4.08];
% yscale = [183.12 92.52 45.36 36.6  18.24 9.84 6.96 5.16 4.32];

% Haining July 8, 2010
% magnification = [ 2 4 10 20 40 80];
% xscale = [ 173.0 90.88 35.96 18.24 8.72 4.25];
% yscale = [ 173.4 85.12 34.52 17.16 8.96 4.56]; 
    

% chris june 20,2005
% magnification = [2 4 10 50 70 140];
% xscale=[157.2 78.7 32 6.045 5.13 2.69];
% yscale=[161.3 83.3 33.27 6.858 5.28 2.74];


% shane July 7,2010
% magnification = [2 4 10 20 50 70 140];
% xscale=[179.0 86.7 34.8 16.77 8.4 8.3 4.5];
% yscale=[184.8 95.8 42.3 25.1 11.9 8.9 4.9];


mag2 = 1./magnification;
zoomInverse = 1 / ScanImageZoom;

beta0 = [1 0];
linfitX = polyfit(mag2, xscale, 1);
linfitY = polyfit(mag2, yscale, 1);

fieldX = linfitX(1) * zoomInverse + linfitX(2);
fieldY = linfitY(1) * zoomInverse + linfitY(2);

disp(sprintf('For ScanImage zoom %i, fields of view are:',round(ScanImageZoom)));
disp(sprintf('   X: %.3f um',fieldX));
disp(sprintf('   Y: %.3f um\n\t',fieldY));

XfieldOfView = fieldX;
YfieldOfView = fieldY;
