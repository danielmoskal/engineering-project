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

% pobranie obraz�w
gray1 = rgb2gray(imread('gesture1_0_0_0_kolor.bmp'));
gray2 = rgb2gray(imread('gesture1_0_10_0_kolor.bmp'));

% zbinaryzowanie obraz�w z do�wiadczalnie wyznaczonym niskim progiem
bin1 = im2bw(gray1, 0.01);
bin2 = im2bw(gray2, 0.01);

% wyszukanie pikseli nale��cych do d�oni na obrazie pierwszym 
[handPoints1y, handPoints1x] = find(bin1);

% wyszukanie pikseli nale��cych do d�oni na obrazie drugim 
[handPoints2y, handPoints2x] = find(bin2);
% (funkcja "find" zwraca piksele, maj�ce niezerowe warto�ci w
% zbinaryzowanym obrazie, czyli punkty nale�ace do d�oni,
% dodatkowo warto�ci te s� posortowane od warto�ci najmniejszych 
% do najwiekszych)

% wyszukanie ilo�ci znalezionych pikseli nale��cych do d�oni,
% dla kolejno pierwszego i drugiego obrazu
[numberOfHandPoints1, ~] = size(handPoints1x);
[numberOfHandPoints2, ~] = size(handPoints2x);

% pobranie punkt�w odpowiadaj�cych, potrzebnych do wyznaczenia
% macierzy przekszta�ce� Z
if (hasNewData == true)
    [data, i1, j1, i2, j2] = getDataFromExcelAndSave();
else
    load data;
end

% obliczenie macierzy przekszta�ce� Z, opisano w rozdziale 8.5.
Z = calculateArrayZ(data, i1, j1, i2, j2);

% obliczenie modeli kamery dla obu obraz�w, opisano w rozdziale 8.6.
[M1, M2] = calculateCameraModels;

% przygotowanie macierzy XYZ
XYZ = [];

% dla ka�dego piksela nale��cego do d�oni na pierwszym obrazie..
for n = 1:numberOfHandPoints1
    
    % zapisz wsp�rz�dne piksela w postaci wektora
    P1 = [handPoints1x(n);
          handPoints1y(n);
          1];
    
    % wyznacz odpowiadaj�cy punkt na drugim obrazie, zale�no�� (4.2) 
    P2 = Z * P1;
    
    % zapisz wsp�rz�dne wyznaczonego piksela na obrazie drugim
    P2x = floor(P2(1) / P2(3) + 0.5);
    P2y = floor(P2(2) / P2(3) + 0.5);
    % (wyznaczony punkt P2, mo�e zawiera� nieca�kowite warto�ci
    % wsp�rz�dnych, natomiast wyznaczony zbi�r pikseli nale��cych
    % do d�oni na drugim obrazie, zawiera tylko piksele o wsp�rz�dnych
    % ca�kowitych, z tego powodu wykorzystano zaokr�glenie wsp�rz�dnych
    % znalezionego punktu P2 do najbli�szych warto�ci ca�kowitych)
    
    
    % je�eli znaleziony piksel na drugim obrazie nie nale�y do d�oni,
    % odrzu� generowanie wsp�rz�dnych 3D dla takiej pary pikseli
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
    
    % gdy piksel na drugim obrazie nale�y do d�oni, oblicz
    % wsp�rz�dne punktu w przestrzeni 3D dla wyznaczonej 
    % pary pikseli, opisano w rozdziale 8.7.
    W = calculateVectorW(P1(1), P1(2), P2x, P2y, M1, M2);
    
    % do�� obliczony wektor wsp�rz�dnych 3D do macierzy XYZ
    W = W.';
    if isempty(XYZ)
        XYZ = W;
    else
        XYZ = [XYZ;
             W];
    end
end

% wy�wietl wszystkie punkty w przestrzeni 3D, korzystaj�c z ich
% wsp�rz�dnych zapisanych w macierzy XYZ
showPointCloud(XYZ)

if (savePointCloud == true)
    savePointCloudToAsciiAndBin(XYZ, pointCloudName);
end
end