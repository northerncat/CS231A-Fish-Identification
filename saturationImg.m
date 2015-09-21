function S = saturationImg(img)
    S = zeros(size(img,1), size(img,2));
    for i = 1:size(img,1)
        for j = 1:size(img,2)
            V = max(img(i,j,:));
            m = min(img(i,j,:));
            C = V - m;
            if V ~= 0
                S(i,j) = double(C) / V;
            end
        end
    end
end