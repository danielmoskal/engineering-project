function XYZ = SFM(hasNewData, savePointCloud, pointCloudName)
if nargin < 3
    pointCloudName = 'handPointCloud';
end
if nargin < 2
    savePointCloud = false;
end
if nargin < 1
    hasNewData = false;
end

% pobranie obrazów
gray1 = rgb2gray(imread('gesture1_0_0_0_kolor.bmp'));
gray2 = rgb2gray(imread('gesture1_0_10_0_kolor.bmp'));

% zbinaryzowanie obrazów z doœwiadczalnie wyznaczonym niskim progiem
bin1 = im2bw(gray1, 0.01);
bin2 = im2bw(gray2, 0.01);

% wyszukanie pikseli nale¿¹cych do d³oni na obrazie pierwszym 
[handPoints1y, handPoints1x] = find(bin1);

% wyszukanie pikseli nale¿¹cych do d³oni na obrazie drugim 
[handPoints2y, handPoints2x] = find(bin2);
% (funkcja "find" zwraca piksele, maj¹ce niezerowe wartoœci w
% zbinaryzowanym obrazie, czyli punkty nale¿ace do d³oni,
% dodatkowo wartoœci te s¹ posortowane od wartoœci najmniejszych 
% do najwiekszych)

% wyszukanie iloœci znalezionych pikseli nale¿¹cych do d³oni,
% dla kolejno pierwszego i drugiego obrazu
[numberOfHandPoints1, ~] = size(handPoints1x);
[numberOfHandPoints2, ~] = size(handPoints2x);

% pobranie punktów odpowiadaj¹cych, potrzebnych do wyznaczenia
% macierzy przekszta³ceñ Z
if (hasNewData == true)
    [data, i1, j1, i2, j2] = getDataFromExcelAndSave();
else
    load data;
end

% obliczenie macierzy przekszta³ceñ Z, opisano w rozdziale 8.5.
Z = calculateArrayZ(data, i1, j1, i2, j2);

% obliczenie modeli kamery dla obu obrazów, opisano w rozdziale 8.6.
[M1, M2] = calculateCameraModels;

% przygotowanie macierzy XYZ
XYZ = [];

% dla ka¿dego piksela nale¿¹cego do d³oni na pierwszym obrazie..
for n = 1:numberOfHandPoints1
    
    % zapisz wspó³rzêdne piksela w postaci wektora
    P1 = [handPoints1x(n);
          handPoints1y(n);
          1];
    
    % wyznacz odpowiadaj¹cy punkt na drugim obrazie, zale¿noœæ (4.2) 
    P2 = Z * P1;
    
    % zapisz wspó³rzêdne wyznaczonego piksela na obrazie drugim
    P2x = floor(P2(1) / P2(3) + 0.5);
    P2y = floor(P2(2) / P2(3) + 0.5);
    % (wyznaczony punkt P2, mo¿e zawieraæ nieca³kowite wartoœci
    % wspó³rzêdnych, natomiast wyznaczony zbiór pikseli nale¿¹cych
    % do d³oni na drugim obrazie, zawiera tylko piksele o wspó³rzêdnych
    % ca³kowitych, z tego powodu wykorzystano zaokr¹glenie wspó³rzêdnych
    % znalezionego punktu P2 do najbli¿szych wartoœci ca³kowitych)
    
    
    % je¿eli znaleziony piksel na drugim obrazie nie nale¿y do d³oni,
    % odrzuæ generowanie wspó³rzêdnych 3D dla takiej pary pikseli
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
    
    % gdy piksel na drugim obrazie nale¿y do d³oni, oblicz
    % wspó³rzêdne punktu w przestrzeni 3D dla wyznaczonej 
    % pary pikseli, opisano w rozdziale 8.7.
    W = calculateVectorW(P1(1), P1(2), P2x, P2y, M1, M2);
    
    % do³ó¿ obliczony wektor wspó³rzêdnych 3D do macierzy XYZ
    W = W.';
    if isempty(XYZ)
        XYZ = W;
    else
        XYZ = [XYZ;
             W];
    end
end

% wyœwietl wszystkie punkty w przestrzeni 3D, korzystaj¹c z ich
% wspó³rzêdnych zapisanych w macierzy XYZ
showPointCloud(XYZ)

if (savePointCloud == true)
    savePointCloudToAsciiAndBin(XYZ, pointCloudName);
end
end