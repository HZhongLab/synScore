function ROI_siz = h_getROISize3(value)

switch value
    case {1, 9}
        ROI_siz = 16;
    case {2}
        ROI_siz = 1;
    case {3}
        ROI_siz = 2;
    case {4}
        ROI_siz = 3;
    case {5}
        ROI_siz = 5;
    case {6}
        ROI_siz = 7;
    case {7}
        ROI_siz = 10;
    case {8}
        ROI_siz = 13;
    case {10}
        ROI_siz = 20;
    case {11}
        ROI_siz = 25;
    case {12}
        ROI_siz = 30;
    case {13}
        ROI_siz = 40;
    case {14}
        ROI_siz = 50;
    case {15}
        ROI_siz = 60;
    case {16}
        ROI_siz = 80;
    otherwise
end