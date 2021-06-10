function [M1, M2] = calculateCameraModels()
imageHeight = 240; % wysoko�� obraz�w
imageWidth = 320; % szeroko�� obraz�w
f = 0.0035; % ogniskowa kamery

% wielko�� piksela
nx = 0.0032 / imageWidth;
ny = 0.0024 / imageHeight;

% odleg�o�� osi optycznej od �rodka elementu �wiatloczu�ego
dx = -160; 
dy = 120;

% wyznaczenie uproszczonych warto�ci dx/dy, zgodnie z zale�no�ci� (5.15.)
dxp = (imageWidth / 2 + dx) * 1 / nx;
dyp = (imageHeight / 2 - dy) * 1 / ny;

% k�t obrotu drugiego obrazu wzgl�dem pierwszego w radianach
a = -10 * pi/180;

% z�o�enie macierzy przekszta�ce� z uk�adu odniesienia elementu
% �wiat�oczu�ego do ukladu odniesienia obrazu, zale�no�� (5.16.)
Tir1 = [1/nx, 0,      dxp;
        0,    -1/ny,  dyp;
        0,    0,       1];
Tir2 = Tir1; % taka sama macierz przekszta�ce� dla obu obraz�w
    
% z�o�enie macierzy przekszta�ce� z uk�adu odniesienia kamery do
% uk�adu odniesienia elementu �wiat�oczu�ego, zale�no�� (5.13.)
Trc1 = [1, 0, 0, 0;
        0, 1, 0, 0;
        0, 0, 1/f, 1];
Trc2 = Trc1; % taka sama macierz przekszta�ce� dla obu obraz�w

% z�o�enie macierzy przekszta�ce� z uk�adu odniesienia sceny do
% uk�adu odniesienia kamery
% dla pierwszego obrazu, zale�no�� (5.9.)
Tcs1 = eye(4); % macierz jednostkowa

% dla drugiego obrazu, zale�no�� (5.11.), rotacja tylko wok� osi y
Tcs2 = [cos(a),  0,  sin(a), 0;
        0,       1,    0,    0;
        -sin(a), 0,  cos(a), 0;
        0,       0,    0,    1];
    
    
% wyznaczenie modelu kamery dla obu obraz�w, przez z�o�enie przekszta�ce�
M1 = Tir1 * Trc1 * Tcs1;
M2 = Tir2 * Trc2 * Tcs2;
end