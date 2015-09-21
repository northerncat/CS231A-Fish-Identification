function gray = im2gray(img, choice)

    % This function converts an rgb image to grayscale image, and the
    % method of conversion depends on the choice argument (these methods 
    % are according to Kanan and Conttrell 2012 PLoS):
    %
    % choice:
    %   1. Intensity, the average of R, G, B values
    %   2. Gamma-corrected Intensity: using the comman gamma = 2.2, this
    %       method converts each RGB value to ^-2.2 and obtain average of 
    %       the corrected values
    %   3. Luminance: human brightness perception, MATLAB rgb2gray
    %   4. Luma: used in HDTVs, gamma corrected form of luminance, and
    %       perceptually uniform
    %   5. Lightness: percetually uniform representation in CIELAB color
    %       space. See code for the equation.
    %   6. Value: The value in Hue-Saturation-Value color space, max of RGB
    %   7. Luster: lightness in Hue-Lightness-Saturation color space, mean
    %       of max and min RGB values
    %   8. Decolorize: See Grundland and Dodgson 2007 for the algorithm!
    %    
    imgDouble = im2double(img);
    gray = zeros(size(img,1), size(img,2));

    % intensity
    if choice == 1
        for i = 1:size(img,1)
            for j = 1:size(img,2)
                gray(i,j) = mean(imgDouble(i,j,:));
            end
        end
    % gamma corrected intensity
    elseif choice == 2
        for i = 1:size(img,1)
            for j = 1:size(img,2)
                gray(i,j) = mean(gammaCorrect(imgDouble(i,j,:)));
            end
        end
    % luminance
    elseif choice == 3
        gray = rgb2gray(img); 
    % Luma
    elseif choice == 4
        for i = 1:size(img,1)
            for j = 1:size(img,2)
                rp = gammaCorrect(imgDouble(i,j,1));
                gp = gammaCorrect(imgDouble(i,j,2));
                bp = gammaCorrect(imgDouble(i,j,3));
                gray(i,j) = 0.02126 * rp + 0.7152 * gp + 0.0722 * bp;
            end
        end
    % lightness
    elseif choice == 5
        for i = 1:size(img,1)
            for j = 1:size(img,2)
                Y = 0.02126 * imgDouble(i,j,1) + 0.7152 * imgDouble(i,j,2) + 0.0722 * imgDouble(i,j,3);
                gray(i,j) = 1.16 * f(Y) - 0.16;
            end
        end
    % value
    elseif choice == 6
        for i = 1:size(img,1)
            for j = 1:size(img,2)
                gray(i,j) = max(imgDouble(i,j,:));
            end
        end
    % Luster
    elseif choice == 7
        for i = 1:size(img,1)
            for j = 1:size(img,2)
                gray(i,j) = (max(imgDouble(i,j,:)) + min(imgDouble(i,j,:))) / 2;
            end
        end
    % decolorize
    elseif choice == 8
        gray = decolorize(img);
    else
        gray = rgb2gray(img);
    end

    
    figure; imshow(gray);
    
end


function xp = gammaCorrect(X)
    xp = X.^(1/2.2);
end

function fY = f(Y)
    if Y > (6/29)^3
        fY = Y^(1/3);
    else
        fY = (29/6)^2 * Y / 3 + 4 / 29;
    end
end