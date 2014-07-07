function splitwrtSubject( featset )
%UNTÝTLED Summary of this function goes here
%   Detailed explanation goes here
% % %1 5 6 7 8 9 10 are used, 
  testActors  = [1,2,3,4];
   trainActors= [5,6,7,8,9,10];
%  testActors = [1,2,3,4,5];
%  trainActors = [6,7,8,9,10];

traindata = [];
trainlabel = [];
testdata = [];
testlabel = [];
traincnt = 0;
testcnt = 0;

for i = 1 : length(featset)
    if (any(abs(featset(i).subject-trainActors) <1e-10))
        traindata = cat(1, traindata, featset(i).features);
        trainlabel = cat(1, trainlabel, featset(i).action);
        traincnt = traincnt +1;
    end
    if (any(abs(featset(i).subject-testActors) <1e-10))
        testdata = cat(1, testdata, featset(i).features);
        testlabel = cat(1, testlabel, featset(i).action);
        testcnt = testcnt + 1;
    end
end

tmpmat = [traindata;testdata];

[mappedData,mapping] = pca(tmpmat,3);

traindata = mappedData(1:traincnt,:);
testdata = mappedData(traincnt+1:traincnt+testcnt,:);

traindata = mkunitvar(centercols(double(traindata)));
testdata = mkunitvar(centercols(double(testdata)));

traindata = single(traindata); testdata = single(testdata);
pTrain={'M',50,'maxDepth',50};

forest=forestTrain(traindata,trainlabel,pTrain{:});
hsPr0 = forestApply(traindata,forest);
hsPr1 = forestApply(testdata,forest);

%   model = svmtrain(trainlabel, sparse(traindata), '-c 5 -t 3 -g 0.003 -b 1');
%   [out, accuracy, a] = svmpredict(testlabel, sparse(testdata), model,'-b 1');

%   yHat = classify(testdata,traindata,trainlabel,'diaglinear');
 nerrs  = sum(hsPr1 ~= testlabel);
 acc = 1 - nerrs/size(testlabel,1)
plotConfusion(testlabel,hsPr1);
% figure(1),plotConfusion(trainlabel,hsPr0);

end

