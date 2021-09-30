%function to make the whole abdomen ROI as used for comparison of tumor
%specific and technical trends in the signal changes, and normalization
function roi_wholebody=WholeBodyMakeFunct(Scans,ROI)

%find slices where tumor ROI is
Sums=squeeze(sum(sum(ROI,1),2));
[tc,~]=find(Sums>0);

%find the middle slice of the tumor ROI, it will also be the middle slice
%of the abdomen ROI, which will span 5 slices on both sides
Medsl=floor(median(tc));

%make disks to fill out the abdomen ROI and make sure it covers the whole
%cross-section of body
se=strel('disk',10);
se2=strel('disk',5);
roi_wholebody=zeros(size(Scans));
%in each slice threshold by signal intensity to identify body, fill holes
%and remove arms which may be present in the slice
for sl=Medsl-5:Medsl+5
    ROItemp=Data.Scans(:,:,sl)>80;
    ROItemp=imfill(ROItemp,'holes');
    ROItemp=imerode(ROItemp,se2);
    ROIEroded=imerode(ROItemp,se);
    ROInoArmExc=bwareaopen(ROIEroded,10000);
    ROIArm=ROIEroded & ~ROInoArmExc;
    ROIArm=imdilate(ROIArm,se);
    ROItemp(ROIArm)=0;
    ROItemp=bwareaopen(ROItemp,10000);
       roi_wholebody(:,:,sl)=ROItemp;
end
roi_wholebody=logical(roi_wholebody);
%exclude the tumor ROI from the rest of the abdomen
roi_wholebody(ROI)=0;

