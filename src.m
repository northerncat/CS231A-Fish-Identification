function weights = src(trainMatrix, testImg, epsilon)
    
    % This function implements the Sparse Representation classification
    % method as developed in Wright et al. 2009 and improved in Hsiao et
    % al. 2014 specifically for the the problem of fish identification.
    %
    % Arguments:
    %   trainMatrix, speciesVec: trainMatrixas returned by buildTrainMatrix 
    %                            function
    %   testImg: the testing image in grayscale form, the caller function
    %            should ensure that the conversion algorithm should be the
    %            same used for buildTrainMatrix
    % 
    % Return:
    %   weights: the weighting coefficient corresponding to each image in
    %            trainMatrix

    f = ones(size(trainMatrix,2),1);
    noise = rand(size(testImg), 'double') * epsilon;
    weights = linprog(f, trainMatrix, testImg+noise);

    figure;
    bar(weights);
end