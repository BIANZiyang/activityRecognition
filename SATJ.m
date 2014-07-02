function [ jVel, listOfJoints ] = SATJ( thetas, thetas_old, threshold )
%SATJ Sequence of Joints w.r.t. Activation Time
%params

dT = 1;
jVel = (thetas - thetas_old) ./dT;
[sJVels, listOfJoints] = sort(jVel,'descend');

end

