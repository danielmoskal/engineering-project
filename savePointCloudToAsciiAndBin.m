function savePointCloudToAsciiAndBin(XYZ, pointCloudName)
% W = W .* 100;
% W = single(W);
ptCloud = pointCloud(XYZ);
pcwrite(ptCloud, pointCloudName)
pcwrite(ptCloud, strcat(pointCloudName,'_bin'),'PLYFormat','binary')
end