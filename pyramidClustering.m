clear,clc,close all;

% config.data = 'data/MSRPair/MSRPairOptFlowPatches_Latest.mat';
% config.data = 'data/MSRAction3D/AS2.mat';
config.data = 'data/MSRAction3D/AS2_cluster.mat';
load(config.data);
config.binSize = 150;
config.clusterSize = 150;
config.lvl = 1;
[s1 s2] = size(output);

%collect postures
% postures = [];
% for k = 1:s2 
%     for k2 = 1:output(k).numFrames
%         tmpvel = output(k).veldata{k2};
%         tmpsph = output(k).sphdata{k2};
%         tmpsph = tmpsph(:,2:end); %cutout the first column with zeros
%         tmpsph = (reshape(tmpsph.',[],1))';
%         postures = [postures;tmpvel, tmpsph];
%     end
% end
% 
% %cluster postures using k-means clustering
% IDX=kmeans(postures,config.clusterSize);
% ind = 1; % indice for IDX variable
% for k = 1:s2 
%     tmpinstance = [];
%     for k2 = 1:output(k).numFrames
%         tmpinstance = [tmpinstance, IDX(ind)];
%         ind = ind + 1;
%     end
%     output(k).clusterSequence = tmpinstance;
% end


%lets split clusters and then take the histogram

for k = 1:s2
%     tmpVx = [];
%     for k2 = 1:output(k).numFrames %scan all frames and concat them
        tmpSeq = [output(k).clusterSequence];
%     end
    %define the levels here!
    numcols = size(tmpSeq,2);
    if(config.lvl == 1)
        output(k).H(1).hist = hist(tmpSeq,config.binSize);
    elseif(config.lvl == 2)
        %numframes = optFlowMSRPair(k).numFrames;
        %divide into 2 parts
        middle = floor(numcols / 2);
        tmpSeq21 = tmpSeq(:,1:middle);
        tmpSeq22 = tmpSeq(:,middle+1:end);
        
        output(k).H(1).hist = hist(tmpSeq21,config.binSize);
        output(k).H(2).hist = hist(tmpSeq22,config.binSize);
        
    elseif(config.lvl == 3)
        %divide into 4 parts
        middle1 = floor(numcols / 4);
        end1 = middle1*2;
        middle2 = middle1*3;
        tmpSeq41 = tmpSeq(:,1:middle1);
        tmpSeq42 = tmpSeq(:,middle1+1:end1);
        tmpSeq43 = tmpSeq(:,end1+1:middle2);
        tmpSeq44 = tmpSeq(:,middle2+1:end);
        

        output(k).H(1).hist = hist(tmpSeq41,config.binSize);
        output(k).H(2).hist = hist(tmpSeq42,config.binSize);
        output(k).H(3).hist = hist(tmpSeq43,config.binSize);
        output(k).H(4).hist = hist(tmpSeq44,config.binSize);
        
    elseif(config.lvl == 4)
        %divide into 8 parts
        middle1 = floor(numcols / 8);
        end1 = middle1*2;
        middle2 = middle1*3;
        end2 = middle1*4;
        middle3 = middle1*5;
        end3 = middle1*6;
        middle4 = middle1*7;
        
        tmpSeq81 = tmpSeq(:,1:middle1);
        tmpSeq82 = tmpSeq(:,middle1+1:end1);
        tmpSeq83 = tmpSeq(:,end1+1:middle2);
        tmpSeq84 = tmpSeq(:,middle2+1:end2);
        tmpSeq85 = tmpSeq(:,end2+1:middle3);
        tmpSeq86 = tmpSeq(:,middle3+1:end3);
        tmpSeq87 = tmpSeq(:,end3+1:middle4);
        tmpSeq88 = tmpSeq(:,middle4+1:end);

        output(k).H(1).hist = hist(tmpSeq81,config.binSize);
        output(k).H(2).hist = hist(tmpSeq82,config.binSize);
        output(k).H(3).hist = hist(tmpSeq83,config.binSize);
        output(k).H(4).hist = hist(tmpSeq84,config.binSize);
        output(k).H(5).hist = hist(tmpSeq85,config.binSize);
        output(k).H(6).hist = hist(tmpSeq86,config.binSize);
        output(k).H(7).hist = hist(tmpSeq87,config.binSize);
        output(k).H(8).hist = hist(tmpSeq88,config.binSize);
                
    end
    disp(sprintf('instance: %d frmnum: %d jointnum: %d',k));
end