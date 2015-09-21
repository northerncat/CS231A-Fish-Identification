function gray = decolorize(img)

    % This function implements the decolorizing algorithm as described in
    % Grundland and Dodgson 2007. The basic idea of the algorithm is to use
    % the chromatic information to adjust the luminance contrast of the
    % image.
    
    % The algorithm is roughly as following:
    %   1. transform RGB of each pixel to YPQ space
    %   2. sample another pixel in the image to infer color contrast
    %       distribution
    %   3. Calculate chromatic contrast of paired pixels and determine the
    %       predominant axis of the contrast
    %   4. Combine luminance and chromatic information to gain degree of
    %       contrast desired for the image and enhanced luminance
    %   5. Rescale the enhanced luminance based on the dynamic range of
    %       enhanced luminance and the saturation
    
    nR = size(img,1);
    nC = size(img,2);
    img = im2double(img);
    lambda = 0.3;
    sigma = 25;
    eta = 0.001;
    nSample = 10;
    % transform to YPQ
    toYPQ = [0.2989, 0.5870, 0.1140; 0.5, 0.5, -1; 1, -1, 0];
    YPQimg = img;
    for i = 1:nR
        for j = 1:nC
            YPQimg(i,j,:) = toYPQ * squeeze(img(i,j,:));
        end
    end
    % image sampling and dimensionality reduction
    K = zeros(nR, nC);
    for i = 1:nR
        for j = 1:nC
            pixel = squeeze(img(i,j,:));
            YPQPixel = squeeze(YPQimg(i,j,:));
            % obtain another random pixel
            sig = (2 * sigma * sigma / pi)^(0.5);
            pairedPixels = [];
            YPQpairedPixels = [];
            while size(pairedPixels,2) < nSample
                dispX = floor(normrnd(0, sig));
                dispY = floor(normrnd(0, sig));
                I = max(size(img,1), min(1, i + dispX));
                J = max(size(img,2), min(1, j + dispY));
                pairedPixels = [pairedPixels, squeeze(img(I,J,:))];
                YPQpairedPixels = [YPQpairedPixels, squeeze(YPQimg(I,J,:))];
            end
            % obtain contrast between the paired pixels
            dR = repmat(pixel(1),1,nSample) - pairedPixels(1,:);
            dG = repmat(pixel(2),1,nSample) - pairedPixels(2,:);
            dB = repmat(pixel(3),1,nSample) - pairedPixels(3,:);
            % calculate predominant axis of chromatic contrast c
            dD = (dR.^2 + dG.^2 + dB.^2).^(0.5);
            dY = repmat(YPQPixel(1),1,nSample) - YPQpairedPixels(1,:);
            dP = repmat(YPQPixel(2),1,nSample) - YPQpairedPixels(2,:);
            dQ = repmat(YPQPixel(3),1,nSample) - YPQpairedPixels(3,:);
            o = sign(dY);
            c = contrastLossRatio(dD, dY, YPQPixel(1));
            % calculate predominant chromatic value K
            deltaP = sum(o.*(c.*dP), 2);
            deltaQ = sum(o.*(c.*dQ), 2);
            K(i,j) = YPQPixel(2) * deltaP + YPQPixel(3) * deltaQ;
        end
    end
    % normalize by outlier ratio
    Ks = sort(K(:));
    quantileK = Ks(floor(nR * nC * (1-eta)));
    % calculate desired contrast ehnancement
    C = K ./ quantileK;
    Y = squeeze(YPQimg(:,:,1));
    U = Y + lambda * C;
    % Adjust by dynamic range of saturation
    Us = sort(U);
    Umin = Us(floor(nR * nC * eta));
    Umax = Us(floor(nR * nC * (1-eta)));
    Ys = sort(Y(:));
    Ymin = min(Y(:));
    Ymax = max(Y(:));
    Yeta = Ys(floor(nR * nC * eta));
    Ym_eta = Ys(floor(nR * nC * (1-eta)));
    Vmin = lambda * Ymin + (1 - lambda) * Yeta;
    Vmax = lambda * Ymax + (1 - lambda) * Ym_eta;
    V = repmat(Vmin, size(U)) + (Vmax - Vmin) / (Umax - Umin) * (U - Umin);
    S = saturationImg(img);
    [E, F] = getEF(Y, Ymin, Ymax, lambda, S);
    gray = zeros(size(S));
    for i = 1:nR
        for j = 1:nC
            gray(i,j) = median([V(i,j), E(i,j), F(i,j)]);
        end
    end
    
end

function c = contrastLossRatio(dD, dY, Y)
    c = zeros(size(dD));
    for i = 1:size(dD,2)
        if dD ~= 0
            c(i) = (dD(i) - 1 / Y * abs(dY(i))) / dD(i);
        end
    end
end

function S = saturationImg(img)
    S = zeros(size(img,1), size(img,2));
    for i = 1:size(img,1)
        for j = 1:size(img,2)
            V = max(img(i,j,:));
            m = min(img(i,j,:));
            C = V - m;
            if V ~= 0
                S(i,j) = C / V;
            end
        end
    end
end

function [E, F] = getEF(Y, Ymin, Ymax, lambda, S)
    E = zeros(size(S));
    F = zeros(size(S));
    Smax = max(S(:));
    for i = 1:size(S, 1)
        for j = 1:size(S, 2)
            E(i,j) = max(Ymin, Y(i,j) - lambda * Ymax / Smax * S(i,j));
            F(i,j) = min(Ymax, Y(i,j) + lambda * Ymax / Smax * S(i,j));
        end
    end
end