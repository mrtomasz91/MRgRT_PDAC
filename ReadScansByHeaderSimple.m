%script to read a sequence of 2D dicom images into a single 3D image,
%matching and recording the slice positions
function [Scans,slicePos]=ReadScansByHeaderSimple(ScanFolder)

AllFiles=dir(fullfile(ScanFolder,'*.DCM'));

for i=1:size(AllFiles,1)
infoTemp=dicominfo(strcat(AllFiles(i).folder,'\',AllFiles(i).name));

posTemp=infoTemp.ImagePositionPatient;
imgTemp(:,:,i)=dicomread(strcat(AllFiles(i).folder,'\',AllFiles(i).name));  



slicePosTemp(i)=posTemp(3);

end
%in case the images were not in slice order, sort them
         [slicePos,ord]=sort(slicePosTemp);
         Scans=imgTemp(:,:,ord);
        

end