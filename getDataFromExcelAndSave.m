function [data, i1, j1, i2, j2] = getDataFromExcelAndSave()

data = xlsread('sift_params_data.xlsx');
i1 = data(:, 1);
j1 = data(:, 2);
i2 = data(:, 3);
j2 = data(:, 4);

save data
end