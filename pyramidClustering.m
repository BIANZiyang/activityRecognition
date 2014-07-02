clear,clc,close all;

% config.data = 'data/MSRPair/MSRPairOptFlowPatches_Latest.mat';
config.data = 'data/MSRAction3D/ROFL/AS2.mat';

load(config.data);
optFlowMSRPair = MSRAction3D;
%optFlowMSRPair = results;
config.binSize = 30;
config.patchSize = 11;
config.lvl = 4;
[s1 s2] = size(optFlowMSRPair);
MSRPairPyramid = [];


for k = 1:s2
    for k3 = 1:10 % for each joint optical flow fields are horizontally contetanated
        %calculate pyramid levels (this one is for Level 1)
        tmpVx = [];
        tmpVy = [];
        for k2 = 1:optFlowMSRPair(k).numFrames - 2 %scan all frames and concat them
            tmpVx = [tmpVx,optFlowMSRPair(k).optFlowPatches(k3,k2).Vx];
            tmpVy = [tmpVy,optFlowMSRPair(k).optFlowPatches(k3,k2).Vy];
        end
        %define the levels here!
        numcols = size(tmpVx,2);
        if(config.lvl == 1)
            MSRPairPyramid(k).HOOF(k3,1).hist = gradientHistogram(tmpVx,tmpVy,config.binSize);
            MSRPairPyramid(k).label = optFlowMSRPair(k).action;
            MSRPairPyramid(k).subject = optFlowMSRPair(k).subject;
        elseif(config.lvl == 2)
            %numframes = optFlowMSRPair(k).numFrames;
            %divide into 2 parts
            middle = floor(numcols / 2);
            tmpVx21 = tmpVx(:,1:middle);
            tmpVx22 = tmpVx(:,middle+1:end);
            
            tmpVy21 = tmpVy(:,1:middle);
            tmpVy22 = tmpVy(:,middle+1:end);
            
            MSRPairPyramid(k).HOOF(k3,1).hist = gradientHistogram(tmpVx21,tmpVy21,config.binSize);
            MSRPairPyramid(k).HOOF(k3,2).hist = gradientHistogram(tmpVx22,tmpVy22,config.binSize);
            MSRPairPyramid(k).label = optFlowMSRPair(k).action;
            MSRPairPyramid(k).subject = optFlowMSRPair(k).subject;
            
        elseif(config.lvl == 3)
            %divide into 4 parts
            middle1 = floor(numcols / 4);
            end1 = middle1*2;
            middle2 = middle1*3;
            tmpVx41 = tmpVx(:,1:middle1);
            tmpVx42 = tmpVx(:,middle1+1:end1);
            tmpVx43 = tmpVx(:,end1+1:middle2);
            tmpVx44 = tmpVx(:,middle2+1:end);
            
            tmpVy41 = tmpVy(:,1:middle1);
            tmpVy42 = tmpVy(:,middle1+1:end1);
            tmpVy43 = tmpVy(:,end1+1:middle2);
            tmpVy44 = tmpVy(:,middle2+1:end);
            
            MSRPairPyramid(k).HOOF(k3,1).hist = gradientHistogram(tmpVx41,tmpVy41,config.binSize);
            MSRPairPyramid(k).HOOF(k3,2).hist = gradientHistogram(tmpVx42,tmpVy42,config.binSize);
            MSRPairPyramid(k).HOOF(k3,3).hist = gradientHistogram(tmpVx43,tmpVy43,config.binSize);
            MSRPairPyramid(k).HOOF(k3,4).hist = gradientHistogram(tmpVx44,tmpVy44,config.binSize);
            MSRPairPyramid(k).label = optFlowMSRPair(k).action;
            MSRPairPyramid(k).subject = optFlowMSRPair(k).subject;
            
        elseif(config.lvl == 4)
            %divide into 8 parts
            middle1 = floor(numcols / 8);
            end1 = middle1*2;
            middle2 = middle1*3;
            end2 = middle1*4;
            middle3 = middle1*5;
            end3 = middle1*6;
            middle4 = middle1*7;
            
            tmpVx81 = tmpVx(:,1:middle1);
            tmpVx82 = tmpVx(:,middle1+1:end1);
            tmpVx83 = tmpVx(:,end1+1:middle2);
            tmpVx84 = tmpVx(:,middle2+1:end2);
            tmpVx85 = tmpVx(:,end2+1:middle3);
            tmpVx86 = tmpVx(:,middle3+1:end3);
            tmpVx87 = tmpVx(:,end3+1:middle4);
            tmpVx88 = tmpVx(:,middle4+1:end);
            
            tmpVy81 = tmpVy(:,1:middle1);
            tmpVy82 = tmpVy(:,middle1+1:end1);
            tmpVy83 = tmpVy(:,end1+1:middle2);
            tmpVy84 = tmpVy(:,middle2+1:end2);
            tmpVy85 = tmpVy(:,end2+1:middle3);
            tmpVy86 = tmpVy(:,middle3+1:end3);
            tmpVy87 = tmpVy(:,end3+1:middle4);
            tmpVy88 = tmpVy(:,middle4+1:end);
            
            MSRPairPyramid(k).HOOF(k3,1).hist = gradientHistogram(tmpVx81,tmpVy81,config.binSize);
            MSRPairPyramid(k).HOOF(k3,2).hist = gradientHistogram(tmpVx82,tmpVy82,config.binSize);
            MSRPairPyramid(k).HOOF(k3,3).hist = gradientHistogram(tmpVx83,tmpVy83,config.binSize);
            MSRPairPyramid(k).HOOF(k3,4).hist = gradientHistogram(tmpVx84,tmpVy84,config.binSize);
            MSRPairPyramid(k).HOOF(k3,5).hist = gradientHistogram(tmpVx85,tmpVy85,config.binSize);
            MSRPairPyramid(k).HOOF(k3,6).hist = gradientHistogram(tmpVx86,tmpVy86,config.binSize);
            MSRPairPyramid(k).HOOF(k3,7).hist = gradientHistogram(tmpVx87,tmpVy87,config.binSize);
            MSRPairPyramid(k).HOOF(k3,8).hist = gradientHistogram(tmpVx88,tmpVy88,config.binSize);
            
            MSRPairPyramid(k).label = optFlowMSRPair(k).action;
            MSRPairPyramid(k).subject = optFlowMSRPair(k).subject;
            
        end
        disp(sprintf('instance: %d frmnum: %d jointnum: %d',k,k2-1,k3));
    end
end