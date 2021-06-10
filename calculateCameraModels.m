function [M1, M2] = calculateCameraModels()
imageHeight = 240; % wysokoœæ obrazów
imageWidth = 320; % szerokoœæ obrazów
f = 0.0035; % ogniskowa kamery

% wielkoœæ piksela
nx = 0.0032 / imageWidth;
ny = 0.0024 / imageHeight;

% odleg³oœæ osi optycznej od œrodka elementu œwiatloczu³ego
dx = -160; 
dy = 120;

% wyznaczenie uproszczonych wartoœci dx/dy, zgodnie z zale¿noœci¹ (5.15.)
dxp = (imageWidth / 2 + dx) * 1 / nx;
dyp = (imageHeight / 2 - dy) * 1 / ny;

% k¹t obrotu drugiego obrazu wzglêdem pierwszego w radianach
a = -10 * pi/180;

% z³o¿enie macierzy przekszta³ceñ z uk³adu odniesienia elementu
% œwiat³oczu³ego do ukladu odniesienia obrazu, zale¿noœæ (5.16.)
Tir1 = [1/nx, 0,      dxp;
        0,    -1/ny,  dyp;
        0,    0,       1];
Tir2 = Tir1; % taka sama macierz przekszta³ceñ dla obu obrazów
    
% z³o¿enie macierzy przekszta³ceñ z uk³adu odniesienia kamery do
% uk³adu odniesienia elementu œwiat³oczu³ego, zale¿noœæ (5.13.)
Trc1 = [1, 0, 0, 0;
        0, 1, 0, 0;
        0, 0, 1/f, 1];
Trc2 = Trc1; % taka sama macierz przekszta³ceñ dla obu obrazów

% z³o¿enie macierzy przekszta³ceñ z uk³adu odniesienia sceny do
% uk³adu odniesienia kamery
% dla pierwszego obrazu, zale¿noœæ (5.9.)
Tcs1 = eye(4); % macierz jednostkowa

% dla drugiego obrazu, zale¿noœæ (5.11.), rotacja tylko wokó³ osi y
Tcs2 = [cos(a),  0,  sin(a), 0;
        0,       1,    0,    0;
        -sin(a), 0,  cos(a), 0;
        0,       0,    0,    1];
    
    
% wyznaczenie modelu kamery dla obu obrazów, przez z³o¿enie przekszta³ceñ
M1 = Tir1 * Trc1 * Tcs1;
M2 = Tir2 * Trc2 * Tcs2;
end