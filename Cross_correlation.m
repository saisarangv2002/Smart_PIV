clear all;
clc;
close all;

imagea = imread("B002_1.tif");
imageb = imread("B002_2.tif");

[xmax, ymax] = size(imagea);

%windowsize
wsize = [64,64];
w_width = wsize(1);
w_height = wsize(2);

%center points grid
xmin = w_width/2;
ymin = w_height/2; 
xgrid = 100: w_width/2 : 412;
ygrid = 100: w_height/2 : 412; 
%No of windows in total 
w_xcount = length(xgrid);
w_ycount = length(ygrid);

%These correspond to the ranges for the search windows in image b 
x_disp_max = w_width/2;
y_disp_max = w_height/2;

%For every window, first we have to "create" the test matrix
%in image A. Then in image B, we have to correlate this test
%window around it's original position in image A, the range
%is pre-determined. The point of max. correlation corresponds
%to the final avg. displacement of that window

test_ima(w_width, w_height) = 0;
test_imb(w_width+2*x_disp_max, w_height+2*y_disp_max) = 0;
dpx(w_xcount, w_ycount) = 0;
dpy(w_xcount, w_ycount) = 0;
xpeak1 = 0;
ypeak1 = 0;

%i, j are for the windows
%test_i and test_j are for test window to eb
%extracted from image A
for i = 1:(w_xcount)
    for j = 1: (w_ycount)
        max_correlation = 0;
        test_xmin= xgrid(i)- w_width/2;
        test_xmax = xgrid(i) + w_width/2;
        test_ymin = ygrid(j)- w_height/2;
        test_ymax = ygrid(j)+ w_height/2;
        x_disp=0;
        y_disp=0;
        test_ima= imagea(test_xmin:test_xmax, test_ymin:test_ymax);
        test_imb= imageb((test_xmin-x_disp_max):(test_xmax+x_disp_max), (test_ymin - y_disp_max):(test_ymax+y_disp_max));
        correlation = normxcorr2(test_ima, test_imb);
        [xpeak, ypeak] = find(correlation==max(correlation(:)));
        %Rescaling
        xpeak1 = test_xmin + xpeak - wsize(1)/2 - x_disp_max;
        ypeak1 = test_ymin + ypeak - wsize(2)/2 - y_disp_max;
        dpx(i,j) = xpeak1 - xgrid(i);
        dpy(i,j) = ypeak1 - ygrid(i);
    end
end
%Vector display
quiver(dpy, dpy);


