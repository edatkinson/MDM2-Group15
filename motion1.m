clc
clear all
close all
warning off
c=webcam;
while true
e=c.snapshot;
mkdir=createMask(e);
imshowpair(e,mkdir,'montage');
end