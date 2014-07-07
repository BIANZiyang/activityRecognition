
%Feature Extraction of New Method (BoW, Temporal Pyramid, Histogram
%Binning);
%sphdata = spherical coordinates of joint angles
%angledata = joint angles
%jointveldata = joint angle velocities ( or differences )

addpath(genpath('C:\code\newMethod'));
cd C:\code\Kinect
run('addKinectPath.m');

config.dataset = 'MSRAction3D';
config.actionSet = 'AS2';

data = [];
switch config.dataset
    case 'MSRPair'
        rmpath(genpath('C:\dataset\MSR-Action3D'));
        addpath(genpath('C:\dataset\MSR\Data\MSR-Pair'));
        cd C:\dataset\MSR\Data\MSR-Pair\Depth
        cd FullFrame
        listdata = [];
        jointveldata = [];
        sphveldata = [];
        angledata = [];
        sphdata = [];
        label = [];
        d = dir();
        % 1st and 2nd element of the struct are '.' and '..' respectively skip
        % them.
        [n, one] = size(d);
        %singleAction = zeros(240,320,170);  % Full Frame
        for k = 3:n
            tmpstr = d(k,1).name;
            cd (tmpstr) %cd to action%d
            d2 = dir();
            [m, one] = size(d2);
            for k2=3:m%3:m
                if(k ~= 7) % to be able to skip action 5
                    tmpstr = d2(k2,1).name;
                    cd (tmpstr) %cd to action snippets
                    d3 = dir();
                    [o, one] = size(d3);
                    flname = tmpstr(3:14); %name of the action file /
                    [jWCoors jImCoors] = giveSkltCoors(strcat(flname,'skeleton.txt'),config.dataset);
                    [jcnt dim frmcnt] = size(jImCoors);
                    thetaWhole = zeros(10,o-2);
                    thetas_old = zeros(10,1);
                    thetas = zeros(10,1);
                    sphW_old = zeros(20,3);
                    for k3 = 3:frmcnt+2%3:o-1
                        tmpstr2 = d3(k3,1).name;
                        %singleAction(:,:,k3-2) = imread(tmpstr2);
                        singleJointCoorsWorld = jWCoors(:,:,k3-2);
                        %move origin top hip center
                        transformedCoors = moveOrigin2Hip(singleJointCoorsWorld');
                        %convert cartesian coors to spherical
                        [sphW(:,1),sphW(:,2),sphW(:,3)] = cart2sph(transformedCoors(:,1),transformedCoors(:,2),transformedCoors(:,3));
                        thetas = genJointAngles(singleJointCoorsWorld');
                        [jVel, jointList] = SATJ(thetas,thetas_old, 1);
                        sphWVel = sphW - sphW_old;
                        %figure(1),util_skeletonViewer(jImCoors(:,:,k3-2)', singleAction(:,:,k3-2), 1);
                        thetas_old = thetas;
                        sphW_old = sphW;
                        listdata = [listdata; jointList'];
                        jointveldata = [jointveldata; jVel'];
                        sphdata = [sphdata; sphW(:,1:3)'];
                        sphveldata = [sphveldata; sphWVel(:,1:3)'];
                        angledata = [angledata; thetas'];
                    end
                    cd ..
                    label = [label;k-2];
                    disp(sprintf('Action: A%d Instance: %d',k-2, k2-2));
                else
                    continue;
                end
            end
            cd ..
        end
        cd ..
    case 'MSRAction3D'
        ActionNum = ['a02', 'a03', 'a05', 'a06', 'a10', 'a13', 'a18', 'a20'; % first row corresponds to action subset 'AS1'
            'a01', 'a04', 'a07', 'a08', 'a09', 'a11', 'a12', 'a14'; % second row corresponds to action subset 'AS2'
            'a06', 'a14', 'a15', 'a16', 'a17', 'a18', 'a19', 'a20']; % third row corresponds to action subset 'AS3'
        
        NumAct = 8;          % number of actions in each subset
        
        switch config.actionSet
            case 'AS1'
                subset = 1;
            case 'AS2'
                subset = 2;
            case 'AS3'
                subset = 3;
        end
        
        TargetSet = ActionNum(subset,:);
        rmpath(genpath('C:\dataset\MSR\Data\MSR-Pair'));
        addpath(genpath('C:\dataset\MSR-Action3D'));
        cd C:\dataset\MSR-Action3D\Actions
        listdata = [];
        veldata = [];
        sphdata = [];
        label = [];
        thetas_old = zeros(10,1);
        thetas = zeros(10,1);
        
        singleAction = zeros(240,320,170);  % Full Frame
        d = dir();
        % 1st and 2nd element of the struct are '.' and '..' respectively skip
        % them.
        [n, one] = size(d);
        ind = 1;
        for k = 1:8 %n-1%3:4 %choose action from here!
            tmpstr = TargetSet((k-1)*3+1:k*3);
            cd (tmpstr)
            d2 = dir();
            [m, one] = size(d2);
            for k2 = 3:m %choose instance from here!
                    featureV = [];
                    tmpstr = d2(k2,1).name;
                    flname = tmpstr(1:12);
                    [jWCoors, jImCoors] = giveSkltCoors(flname,config.dataset);
                    [jcnt, dim, frmcnt] = size(jImCoors);
                    load(tmpstr);
                    data = [];
                    for k3= 1:frmcnt
                        singleJointCoorsWorld = transformMSR3DJoints(jWCoors(:,:,k3),config.dataset)';
                        singleframejnt = transformMSR3DJoints(jImCoors(:,:,k3),config.dataset)';
                        %move origin top hip center
                        transformedCoors = moveOrigin2Hip(singleJointCoorsWorld);
                        %convert cartesian coors to spherical
                        [sphW(:,1),sphW(:,2),sphW(:,3)] = cart2sph(transformedCoors(:,1),transformedCoors(:,2),transformedCoors(:,3));
                        thetas = genJointAngles(singleJointCoorsWorld);
                        [jVel, jointList] = SATJ(thetas,thetas_old, 1);
                        %reducedSphW = reduceCoors(sphW');
                        %figure(1),util_skeletonViewer(singleframejnt, singleAction(:,:,k3),1 );%depth(:,:,k3), 1);
                        thetas_old = thetas;
                        %listdata = [listdata; jointList'];
                        data(k3).angledata = [thetas'];
                        data(k3).veldata = [jVel'];
                        data(k3).sphdata = [sphW(:,1:2)'];
                        data(k3).jointLoc = [transformedCoors(2:end,:)];
                    end
                    output(ind).action = str2num(tmpstr(2:3));
                    output(ind).numFrames = frmcnt;
                    output(ind).veldata = {data.veldata};
                    output(ind).angledata = {data.angledata};
                    output(ind).sphdata = {data.sphdata};
                    output(ind).jointLoc = {data.jointLoc};
                    output(ind).subject = str2num(tmpstr(6:7));

                    ind = ind+1;
                    
                    disp(sprintf('Action: A%s Instance: %d',tmpstr, k2-2));
            end
            cd ..
        end
        cd ..
    case 'JHMDB'
        addpath(genpath('C:\dataset\JHMDB'));
        cd C:\dataset\JHMDB\JHMDB_video
        listdata = [];
        veldata = [];
        sphdata = [];
        label = [];
        thetas_old = zeros(10,1);
        thetas = zeros(10,1);
        d = dir();
        % 1st and 2nd element of the struct arce '.' and '..' respectively skip
        % them.
        [n, one] = size(d);
        for k = 3:8%3:n % ACTION NUM
            tmpstr = d(k,1).name;
            cd (tmpstr) %cd to action
            d2 = dir();
            [m, one] = size(d2);
            for k2 =  3:13 %m
                flname = d2(k2,1).name; %name of the video file /
                [vMat,frmcnt] = avi2Mat(flname);
                flname = flname(1:end-4);
                inputstr = cell(1,2);
                inputstr{1} = flname; inputstr{2} = tmpstr;
                [jWCoors, jImCoors] = giveSkltCoors(inputstr,config.dataset);
                for k3 = 1:frmcnt
                    singleJointCoorsWorld = transformMSR3DJoints(jWCoors(:,:,k3),config.dataset)';
                    singleframejnt = transformMSR3DJoints(jImCoors(:,:,k3),config.dataset)';
                    %move origin top hip center
                    transformedCoors = moveOrigin2Hip(singleJointCoorsWorld);
                    %convert cartesian coors to spherical
                    [sphW(:,1),sphW(:,2)] = cart2sph(transformedCoors(:,1),transformedCoors(:,2),zeros(20,1));
                    thetas = genJointAngles(singleJointCoorsWorld);
                    [jVel, jointList] = SATJ(thetas,thetas_old, 1);
                    %figure(1),skeletonViewerJHMDB(singleframejnt, vMat(:,:,k3), 1);
                    %title(tmpstr);
                    thetas = genJointAngles(singleJointCoorsWorld);
                    thetaWhole(:,k3) = thetas';
                    thetas_old = thetas;
                    listdata = [listdata; jointList'];
                    veldata = [veldata; jVel'];
                    sphdata = [sphdata; sphW(:,1:2)'];
                end
                label = [label;k-2];
                disp(sprintf('Action: %s Instance: %d',tmpstr, k2-2));
            end
            cd ..
        end
    case 'MicrosoftGestureDataset'
        addpath(genpath('C:\dataset\MicrosoftGestureDataset'));
        cd C:\dataset\MicrosoftGestureDataset\data\csv\
        listdata = [];
        veldata = [];
        sphdata = [];
        label = [];
        frmnums = [];
        thetas_old = zeros(10,1);
        thetas = zeros(10,1);
        d = dir();
        [n, one] = size(d);
        singleAction = zeros(240,320);  % Full Frame
        for k = 3:n
            tmpstr = d(k,1).name;
            filename = tmpstr(1:end-4); % CUT OUT the file extension
            [X,Y,tagset] = load_file(filename);
            [row col] = ind2sub(size(Y),find(Y));
            col;
            fp = fopen(['../sepinst/' filename '.sep'], 'rt');
            S = fscanf(fp, '%d', [2 Inf])';
            fclose(fp);
            for k2 = 1:5 %size(S,1)
                for k3 = S(k2,1):S(k2,2)
                    frmcnt = S(k2,2) - S(k2,1)
                    singleJointCoorsWorld=X(k3,:);
                    skel_model % init NUI_SKELETON STUFF
                    skel=reshape(singleJointCoorsWorld, 4, NUI_SKELETON_POSITION_COUNT)';
                    skel = skel(:,1:3); % cutout the one's at column 4
                    %move origin top hip center
                    transformedCoors = moveOrigin2Hip(skel);
                    %convert cartesian coors to spherical
                    [sphW(:,1),sphW(:,2),sphW(:,3)] = cart2sph(transformedCoors(:,1),transformedCoors(:,2),transformedCoors(:,3));
                    thetas = genJointAngles(skel);
                    [jVel, jointList] = SATJ(thetas,thetas_old, 1);
                                         figure(1),util_skeletonViewer(skel, singleAction, 1);
                    thetas_old = thetas;
                    listdata = [listdata; jointList'];
                    veldata = [veldata; jVel'];
                    sphdata = [sphdata; sphW(:,1:2)'];
                end
                frmnums = [frmnums;frmcnt];
                disp(sprintf('Action: %s Instance: %d',tmpstr, k2));
            end
            label = [label;k-2];
        end
end