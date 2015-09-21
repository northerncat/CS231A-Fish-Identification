function [train, test, held] = splitFolds(fishData)

    % Given the fish images stored in nSpecies * nImagePerSpecie cell
    % array, this function splits the data into train, test and held-out
    % set. For example, if there are 25 species, and each contain 40 
    % images, 2 species would be excluded from the training set to test for
    % identifying true negatives, 2 species would be used as the held out
    % set to get threshold for defining true negatives. In addition, for
    % each species, 8 images would be used as the test set.
    nSp = size(fishData, 1);
    nIm = size(fishData, 2);
    nSpTest = floor(nSp / 10);
    nImTest = floor(nIm / 10);
    
    spRands = randperm(nSp);
    imRands = randperm(nIm);
    testSpIndex = spRands(1:nSpTest);
    testImIndex = imRands(1:nImTest);
    heldSpIndex = spRands(nSpTest + 1: 2*nSpTest);
    heldImIndex = imRands(nImTest + 1: 2*nImTest);
    trainSpIndex = spRands(2*nSpTest + 1:end);
    trainImIndex = imRands(2*nImTest + 1:end);
    
    train = fishData(trainSpIndex, trainImIndex);
    train = train(:); 
    testImages = fishData(testSpIndex, :);
    test = testImages(:);
    testImages = fishData(trainSpIndex, testImIndex);
    test = [test; testImages(:)];
    heldImages = fishData(heldSpIndex, :);
    held = heldImages(:);
    heldImages = fishData(trainSpIndex, heldImIndex);
    held = [held; heldImages(:)];

end