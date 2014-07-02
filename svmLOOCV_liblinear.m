function svmLOOCV_liblinear(featset)
close all;
subj = 1:10;
subnum = size(subj,2);
acc = zeros(subnum,1);

for k = 1 : subnum
    traindata = [];
    trainlabel = [];
    testdata = [];
    testlabel = [];

    for i = 1 : length(featset)
%         disp(sprintf('featset(i).subject: %d',featset(i).subject));
%         disp(sprintf('subj(1,k): %d',subj(1,k)));
        if featset(i).subject ~= subj(1,k)
            traindata = cat(1, traindata, featset(i).features);
            trainlabel = cat(1, trainlabel, featset(i).label);
        else
            testdata = cat(1, testdata, featset(i).features);
            testlabel = cat(1, testlabel, featset(i).label);
        end
    end
     
   %temp = mkunitvar(centercols([traindata;testdata]));
   %traindata = mkunitvar(centercols(temp(1:size(traindata,1),:)));
   %testdata = mkunitvar(centercols(temp(size(traindata,1)+1:end,:)));
%     
    traindata = mkunitvar(centercols(double(traindata)));
    testdata = mkunitvar(centercols(double(testdata)));
     
% traindata = double(traindata);
% testdata = double(testdata);
% 
tic
   model = train(trainlabel, sparse(traindata), '-s 4 -c 10');
   yHat = predict(testlabel, sparse(testdata), model);
toc
   %    
 %    
%     nb = NaiveBayes.fit(traindata, trainlabel,'Prior','uniform');
%     [yHat] = predict(nb,testdata);
%         yHat = classify(testdata,traindata,trainlabel,'diaglinear');
%   mdl = ClassificationKNN.fit(traindata,trainlabel);
%  [yHat] = predict(mdl,testdata);
%  plotConfusion(testlabel,yHat);
   nerrs  = sum(yHat ~= testlabel);
   acc(k) = 1-nerrs/size(testlabel,1)
end
disp(['mean accuracy=' num2str(mean(acc))]);
end