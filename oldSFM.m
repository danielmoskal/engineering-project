clear all
img1 = imread('gesture1_0_0_0_kolor.bmp');
img2 = imread('gesture1_0_10_0_kolor.bmp');
gray1 = rgb2gray(img1);
gray2 = rgb2gray(img2);
bin1 = im2bw(gray1, 0.01);
bin2 = im2bw(gray2, 0.01);

%wyszukanie punktów d³oni na obrazie I (find zwraca wartoœci niezerowe w
%obrazie, czyli punkty nale¿ace do d³oni
[handPoints1y, handPoints1x] = find(bin1);
[numberOfHandPoints1, ~] = size(handPoints1x);

%wyszukanie punktów d³oni na obrazie II (find zwraca wartoœci niezerowe w
%obrazie, czyli punkty nale¿ace do d³oni
[handPoints2y, handPoints2x] = find(bin2);
[numberOfHandPoints2, ~] = size(handPoints2x);

load data
Z = calculateArrayZ(data);
[M1, M2] = calculateCameraModels;
W = [];

for n = 1:numberOfHandPoints1
    P1 = [handPoints1x(n);
          handPoints1y(n);
          1];
      
    P2 = Z * P1;
    P2x = floor(P2(1) / P2(3) + 0.5);
    P2y = floor(P2(2) / P2(3) + 0.5);
    
    if P2x < handPoints2x(1) || P2x > handPoints2x(numberOfHandPoints2)
        continue;    
    end
    
    hp2EqualP2xLogicalArray = ismember(handPoints2x, P2x);
    hp2EqualP2xIndexes = find(hp2EqualP2xLogicalArray);
    
    [hp2EqualP2xIndexesRows, ~] = size(hp2EqualP2xIndexes);
    hp2CorrespondingP2y = handPoints2y(hp2EqualP2xIndexes(1) : hp2EqualP2xIndexes(hp2EqualP2xIndexesRows));

    hp2CorrespondingP2yLogicalArray = ismember(hp2CorrespondingP2y, P2y);
    result = any(hp2CorrespondingP2yLogicalArray);
    if result == 0
        continue;
    end
    w = calculateVectorW(P1(1), P1(2), P2x, P2y, M1, M2);
    w = w.';
    if isempty(W)
        W = w;
    else
        W = [W;
             w];
    end
end