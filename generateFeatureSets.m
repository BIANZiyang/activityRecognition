%classify according to hoof features
clear,clc,close all;
% load('cutafterOF/bin_50/MSRPairPyramid_L1.mat');
% load('cutafterOF/bin_50/MSRPairPyramid_L2.mat');
% load('cutafterOF/bin_50/MSRPairPyramid_L3.mat');
% load('cutafterOF/bin_50/MSRPairPyramid_L4.mat');
%  load('data/MSRAction3D/AS2/MSRPyramid_L1.mat');
%  load('data/MSRAction3D/AS2/MSRPyramid_L2.mat');
%  load('data/MSRAction3D/AS2/MSRPyramid_L3.mat');
%  load('data/MSRAction3D/AS2/MSRPyramid_L4.mat');
%  load('data/MSRAction3D/AS1_whole/MSRPyramid_L1.mat');
%  load('data/MSRAction3D/AS1_whole/MSRPyramid_L2.mat');
%  load('data/MSRAction3D/AS1_whole/MSRPyramid_L3.mat');
%  load('data/MSRAction3D/AS1_whole/MSRPyramid_L4.mat');
% load('data/MSRPair/MSRPairPyramid_L1.mat');
% load('data/MSRPair/MSRPairPyramid_L2.mat');
% load('data/MSRPair/MSRPairPyramid_L3.mat');
% load('data/MSRPair/MSRPairPyramid_L4.mat');
% load('data/MSRPair/latest/MSRPairPyramid_L1.mat');
% load('data/MSRPair/latest/MSRPairPyramid_L2.mat');
% load('data/MSRPair/latest/MSRPairPyramid_L3.mat');
% load('data/MSRPair/latest/MSRPairPyramid_L4.mat');
% %
%  load('data/MSRAction3D/jointChanges/AS1/MSRPyramid_L1.mat');
%  load('data/MSRAction3D/jointChanges/AS1/MSRPyramid_L2.mat');
%  load('data/MSRAction3D/jointChanges/AS1/MSRPyramid_L3.mat');
%  load('data/MSRAction3D/jointChanges/AS1/MSRPyramid_L4.mat');
%
% load('data/MSRPair/changeInHistogram/MSRPairPyramid_L1.mat');
% load('data/MSRPair/changeInHistogram/MSRPairPyramid_L2.mat');
% load('data/MSRPair/changeInHistogram/MSRPairPyramid_L3.mat');
% load('data/MSRPair/changeInHistogram/MSRPairPyramid_L4.mat');


load('data/MSRAction3D/ROFL/AS2/MSRPyramid_L1.mat');
load('data/MSRAction3D/ROFL/AS2/MSRPyramid_L2.mat');
load('data/MSRAction3D/ROFL/AS2/MSRPyramid_L3.mat');
load('data/MSRAction3D/ROFL/AS2/MSRPyramid_L4.mat');


% load('optFlowMSRPair.mat');

[s1 s2] = size(MSRPairPyramid_L1);

features = [];
lbl = [];
for k = 1:s2
    %concat lvl1 and lvl2 histograms horizontally
    %lvl1
    feature_1 = [];
    feature_2 = [];
    feature_3 = [];
    feature_4 = [];
    for k2 = 1:10
        feature_1 = [feature_1, MSRPairPyramid_L1(1,k).HOOF(k2,1).hist'];
        feature_2 = [feature_2, MSRPairPyramid_L2(1,k).HOOF(k2,1).hist', ...
            MSRPairPyramid_L2(1,k).HOOF(k2,2).hist'];
        feature_3 = [feature_3, ...
            MSRPairPyramid_L3(1,k).HOOF(k2,1).hist', ...
            MSRPairPyramid_L3(1,k).HOOF(k2,2).hist', ...
            MSRPairPyramid_L3(1,k).HOOF(k2,3).hist', ...
            MSRPairPyramid_L3(1,k).HOOF(k2,4).hist'];
        feature_4 = [feature_4, ...
            MSRPairPyramid_L4(1,k).HOOF(k2,1).hist', ...
            MSRPairPyramid_L4(1,k).HOOF(k2,2).hist', ...
            MSRPairPyramid_L4(1,k).HOOF(k2,3).hist', ...
            MSRPairPyramid_L4(1,k).HOOF(k2,4).hist', ...
            MSRPairPyramid_L4(1,k).HOOF(k2,5).hist', ...
            MSRPairPyramid_L4(1,k).HOOF(k2,6).hist', ...
            MSRPairPyramid_L4(1,k).HOOF(k2,7).hist', ...
            MSRPairPyramid_L4(1,k).HOOF(k2,8).hist'];
    end
    MSRPairPyramid_L1(k).features = [feature_1,feature_2,feature_3,feature_4];
    features = [features; feature_1,feature_2,feature_3,feature_4];
    lbl = [lbl; MSRPairPyramid_L1(1,k).label];
    disp(sprintf('num of instance: %d',k));
end

