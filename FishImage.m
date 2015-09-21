classdef FishImage
    % FishImage 
    %   This class is a simple wrapper that contains information for a fish
    %   species and should be used in conjunctionwith fishData.mat. 
    properties
        species;
        image;
    end
    
    methods
        
        function obj = FishImage(species, image)
        % constructor, takes in information for the species & image
            if nargin > 0
                obj.species = species;
                obj.image = image;
            end
        end
    end
    
end

