function Z = calculateArrayZ(data, i1, j1, i2, j2)

% wyznaczenie ilo�� dopasowa�
[numberOfMatches, ~] = size(data);

% wype�nienie zerami macierzy wsp�czynnik�w A o wymiarach
% zale�nych od ilo�ci znalezionych dopasowa�
A = zeros(numberOfMatches*2, 8);

% wype�nienie zerami wektora wyraz�w wolnych b o wymiarach
% zale�nych od ilo�ci znalezionych dopasowa�
b = zeros(numberOfMatches*2, 1);

% wype�nianie macierzy A oraz wektora b, zgodnie z zale�no�ci� (4.11.)
n = 1;
for p = 1:numberOfMatches
    A(n, 1) = i1(p);
    A(n, 2) = j1(p);
    A(n, 3) = 1;
    A(n, 4) = 0;
    A(n, 5) = 0;
    A(n, 6) = 0;
    A(n, 7) = -i1(p) * i2(p);
    A(n, 8) = -j1(p) * i2(p);
    b(n) = i2(p);
    
    m = n+1;
    A(m, 1) = 0;
    A(m, 2) = 0;
    A(m, 3) = 0;
    A(m, 4) = i1(p);
    A(m, 5) = j1(p);
    A(m, 6) = 1;
    A(m, 7) = -i1(p) * j2(p);
    A(m, 8) = -j1(p) * j2(p);
    b(m) = j2(p);
    
    n = n + 2;
end

% wyznaczenie wektora wsp�czynnik�w macierzy przekszta�ce�
% na podstawie zale�no�ci (4.13.)
X = A \ b;

% przekszta�cenie wektora wsp�czynnik�w macierzy przekszta�ce�
% do oryginalnej postaci macierzy przekszta�ce� Z (4.1.)
Z = [ X(1), X(2), X(3);
      X(4), X(5), X(6);
      X(7), X(8), 1];
end