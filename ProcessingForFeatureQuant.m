%Script for quantification of radiomic features in MR Linac data that has
%already been read from the dicoms and saved into .mat libraries including
%the "Scans" and "ROI" variables, so the 3D image matrix and the GTV mask
%main output of the script is a variable Feature_Values, with all radiomic
%features from each patient and time-point
OutputFolder='XXXXXXXXXXXXXXXXX'; %folder where normalization (kidney) contours stored
% mkdir(OutputFolder)
Spacing=[1.5,1.5,3];

%example processing 26 patients
for k=1:40
%     

   if(k<10) 
   PatientNumber=strcat('Pancreas0',num2str(k));
   end
   if(k>=10) 
   PatientNumber=strcat('Pancreas',num2str(k));
   end
   
DataFolder=strcat('XXXXXXXXXXXXXXXX',PatientNumber);
% 1-simulation scan, 2-6 is fraction 1-5
for i=1:6
% ScanFolder=strcat(DataFolder,'\',ImageFolder{i});

%This was the folder and naming convention used in saving the .mat

Data=load(strcat(DataFolder,'\ScanROIFract_',num2str(i),'.mat'));

%file with healthy tissue ROIs, like kidney, used for normalization 
   load(strcat(OutputFolder,'\WholeBodyPatient_',num2str(k),'_Fract_',num2str(i),'.mat'))


roi_kidney=logical(roi_kidney);

    ROI=logical(Data.ROI);


Vol(k,i)=sum(sum(sum(ROI)));

%depending if we're normalizing the images
norm=median(Data.Scans(roi_kidney));


 Scans=double(Data.Scans/norm);
%run the Radiomics features code, in this case features calculated from the
%GTV ROI according to the IBSI guidelines. Details are available on https://ibsi.readthedocs.io/en/latest/
%The feature quantification engine is available through multiple
%implementation as described here https://theibsi.github.io/implementations/
[Status, Feature_names, FeatVals]=CalculateFeatures(Scans,ROI,Spacing);


%to protect the loop from the cases when quantification returns no radiomic
%features
if(numel(FeatVals)>3)
Feature_Values(k,i,:)=FeatVals;
end



%End result is the matrix Feature_Values including all features for all
%patients and timepoints for further analysis
clear Data ROI px_tum ROI_erode roi_wholebody FeatVals roi_kidney
end
% Feature_Values(i,:,:)=FeatValTemp;
% clear mirada
end

%Histogram feature ratios last/first fraction, as used in the manuscript
RatiosHistogram=Feature_Values(6,:,1:11)./Feature_Values(2,:,1:11);
%Texture feature ratios
RatiosTexture=Feature_Values(6,:,1:11)./Feature_Values(2,:,90:151);