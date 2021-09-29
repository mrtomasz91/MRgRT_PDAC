%code to process MR guided Radiotherapy images, which normally comes with a
%simulation and several fraction scans, with the ROIs drawn in the
%simulation and co-registered to the next fractions
FullFolder='XXXXXXXXXXXXX'; %folders where subfolders with raw dicom images are stored
%names of folders containing each fraction scan
ImageFolder{1}='DIBH MRI Planning';
ImageFolder{2}='Fraction 1 Setup Scan_Reopt';
ImageFolder{3}='Fraction 2 Setup Scan_Reopt';
ImageFolder{4}='Fraction 3 Setup Scan_Reopt';
ImageFolder{5}='Fraction 4 Setup Scan_Reopt';
ImageFolder{6}='Fraction 5 Setup Scan_Reopt';
%example 26 patients are to be processed 
for k=1:26    
    %in our case the patients were named Pancreas01 etc
   if(k<10) 
   PatientNumber=strcat('Pancreas0',num2str(k));
   end
   if(k>=10) 
   PatientNumber=strcat('Pancreas',num2str(k));
   end
%folder where the image dicoms are   
DataFolder=strcat(FullFolder,'\',PatientNumber);
%in case the RT structure is somewhere else
MiradaFolder=DataFolder;%strcat(DataFolder,'\ROI');
% MiradaFolder=DataFolder;
%RT structure name
mirada=dicominfo(strcat(MiradaFolder,'\IM1 (1).DCM'));
%load the first of the ROIs in the structure, in our case GTV was Item_1,
%change if needed
FieldNameROI=mirada.ROIContourSequence.Item_1.ContourSequence;
fns=fieldnames(FieldNameROI);
%check how many slices
SlicesNrROI=length(fns);
%loop over the simulation and all 5 fraction scans (when available)
for i=1:6
ScanFolder=strcat(DataFolder,'\',ImageFolder{i});
%read the images and slice positions of each
[Scans,slicePos]=ReadScansByHeaderSimple(ScanFolder);
Scans=double(Scans);
%read the patient position for co-registration of the ROIs
Scan1Info=dicominfo(strcat(ScanFolder,'\IM1.DCM'));
PosEdge=Scan1Info.ImagePositionPatient;
PosEdge=PosEdge(1:2);

%slice by slice read the 2D map of the GTV and match it to the right image
%slice
ROI=zeros(size(Scans));
for roisl=1:SlicesNrROI% 
    ROITemp=FieldNameROI.(fns{roisl});
    ContTemp=ROITemp.ContourData;
    ContTemp=reshape(ContTemp,[3,numel(ContTemp)/3]);
    %slice position of the ROI slice currently considered
    SlicePosROI(roisl)=ContTemp(3,1);
    [tc,ROISliceNr(roisl)]=min(abs(repmat(SlicePosROI(roisl),size(slicePos))-slicePos));
    ContTemp=ContTemp(1:2,:);
    ContRes=ContTemp-repmat(PosEdge,[1,size(ContTemp,2)]);
    %the images are 1.5mm in plane resolution, hence the correction below
    %and extrapolation
    ContResVox=round(ContRes/1.5);
    ROI(:,:,ROISliceNr(roisl))=roipoly(squeeze(Scans(:,:,1)),ContResVox(1,:),ContResVox(2,:));
    
end
%save each file containing the scan and ROI
save(strcat(DataFolder,'\ScanROIFract_',num2str(i),'.mat'),'Scans','ROI')
clear Scans slicePos SlicePosROI ROISliceNr px_tum ROI ROI2
end
% clear mirada
end