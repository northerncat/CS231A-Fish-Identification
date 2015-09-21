function fishData = readFishImages()

% This function reads the fish image data as 

folders = dir('FISH_Data_Valid');

fishData = cell(25,40);
fishCount = 0;
for i = 1:length(folders)
    if ismember(1, strfind(folders(i).name, '.'))
        continue
    end
    fishCount = fishCount + 1;
    dirName = sprintf('FISH_Data_Valid/%s', folders(i).name);
    imFiles = dir(dirName);
    imCount = 0;
    for j = 1:length(imFiles)
        if ismember(1, strfind(imFiles(j).name, '.'))
            continue
        end
        imCount = imCount + 1;
        filename = sprintf('%s/%s', dirName, imFiles(j).name);
        fishData{fishCount,imCount} = imread(filename);
    end 
end

for i = 1:size(fishData,1)
    for j = 1:size(fishData,2)
        fishData{i, j} = FishImage(i, fishData{i, j});
    end
end

save('fishData.mat', 'fishData');

end