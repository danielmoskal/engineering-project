function W = calculateVectorW(P1x, P1y, P2x, P2y, M1, M2)

% obliczenie parametrów dla p³aszczyzn kamery, 
% zale¿noœci (6.11, 6.15, 6.18)
A1h = M1(1,1) - M1(3,1) * P1x;
B1h = M1(1,2) - M1(3,2) * P1x;
C1h = M1(1,3) - M1(3,3) * P1x;
D1h = M1(1,4) - P1x;

A1v = M1(2,1) - M1(3,1) * P1y;
B1v = M1(2,2) - M1(3,2) * P1y;
C1v = M1(2,3) - M1(3,3) * P1y;
D1v = M1(2,4) - P1y;

A2h = M2(1,1) - M2(3,1) * P2x;
B2h = M2(1,2) - M2(3,2) * P2x;
C2h = M2(1,3) - M2(3,3) * P2x;
D2h = M2(1,4) - P2x;

A2v = M2(2,1) - M2(3,1) * P2y;
B2v = M2(2,2) - M2(3,2) * P2y;
C2v = M2(2,3) - M2(3,3) * P2y;
D2v = M2(2,4) - P2y;

% wyznaczenie macierzy wspó³czynników oraz wektora wyrazów wolnych,
% zale¿noœæ (6.20)
Q = [A1h, B1h, C1h;
     A1v, B1v, C1v;
     A2h, B2h, C2h;
     A2v, B2v, C2v];
R = [-D1h;
     -D1v;
     -D2h;
     -D2v];
 
% obliczenie wektora wspó³rzêdnych punktu w przestrzeni 3D,
% zaleznoœæ (6.22)
W = Q \ R;
end
