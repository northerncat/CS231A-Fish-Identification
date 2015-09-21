function [trainMatrix, speciesVec] = buildTrainMatrix(train, im2gray)

    % Argument: 
    %   train: a cell array containing FishImage objects for the training
    %          set
    %   im2gray: a function handle that converts the image from RGB to
    %            grayscale
    %
    % Return:
    %   trainMatrix: a matrix where each column is a descriptor of an image
    %                in the training set
    %   speciesVec: a vector in which the elements correspond to the
    %               species index of the columns of trainMatrix

trainMatrix = [];
speciesVec = [];
for i = 1:length(train)
    trainImg = im2double(im2gray(train{i}.image));
    trainImg = trainImg(:);
    trainMatrix = [trainMatrix, trainImg];
    speciesVec = [speciesVec, train{i}.species];
end

end