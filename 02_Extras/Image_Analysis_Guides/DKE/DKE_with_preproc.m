%%%%%%% DKI PROCESSING - MAC

clear all
dbstop if error

%% Variables	
subj_list={'Subj_1', 'Subj_2', 'Subj_3'} %changed based on your subject IDs
dwi_root='/Path/to/study/' %path to files you want to process with DKE
% Folder structure should be as follows:
        %Path/to/study/subject_ID/dke/files_to_process.nii
        %Path/to/study/subject_ID/dicom/DKE_and_B0.bvec/bval
        %Note: folders within main directory should be named for each subject ID
        %   and sub folders for each subject should be named "dke" and "dicom"
B0_seq='DKI_BIPOLAR_2.5mm_64dir_Trio_b0'; %name of B0 sequence (folder name after dicom_sort)
DKI1_seq='DKI_BIPOLAR_2.5mm_64dir_Trio'; %name of DKI1 sequence (folder name after dicom_sort)
dke_parameters='/Path/to/dke_parameters.txt' %path to your basic dke_parameters file
ft_parameters='/Path/to/ft_parameters.txt' %path to your basic ft_parameters file                                  
mrtrix_path = '/Path/to/mrtrix3'; %path to MRtrix3


for i=1:length(subj_list)
    b12root = [dwi_root subj_list{i}];

    %% convert dcm to nii

    eval(['!/Applications/MRIcroGL/dcm2niix -f %p ''' b12root '/dicom/' '''']);
    
    %% move new niis
    mkdir([b12root '/nifti']);
    
    %move b0s
    in_b0=fullfile(b12root, 'dicom', [B0_seq '.nii']);
    out_b0=fullfile(b12root, 'nifti', [B0_seq '.nii']);
    movefile(in_b0,out_b0);
    
    %move dki1
    in_dki=fullfile(b12root, 'dicom', [DKI1_seq '.nii']);
    out_dki=fullfile(b12root, 'nifti', [DKI1_seq '.nii']);
    movefile(in_dki,out_dki);
    
    %% Combine B0 and DKI into one 4D
    hdr_b0=spm_vol(out_b0);
    hdr_dki=spm_vol(out_dki);

    for j=1:length(hdr_b0)
        img_b0=spm_read_vols(hdr_b0(j));
        hdr_all_dki(j)=hdr_b0(j);
        hdr_all_dki(j).fname=[b12root '/nifti/DKI.nii'];
        spm_write_vol(hdr_all_dki(j),img_b0);
    end
    
    for k=1:length(hdr_dki)
        img_dki=spm_read_vols(hdr_dki(k));
        hdr_all_dki(j+k)=hdr_dki(k);
        hdr_all_dki(j+k).fname=[b12root '/nifti/DKI.nii'];
        hdr_all_dki(j+k).n=[(j+k),1];
        spm_write_vol(hdr_all_dki(j+k),img_dki);
    end
    
    delete(out_b0);
    delete(out_dki);
   
    %% DENOISE DKI.nii
    
    %Note: path to MRtrix3 modules needs to be set for this step and the next step to function.

     %denoise
    eval(['!/Path/to/mrtrix3/bin/dwidenoise ''' b12root '/nifti/DKI.nii'' ''' b12root '/nifti/DKI_DN.nii'' ' '-noise ''' b12root '/nifti/noise.nii''']);
    
     %calculate residual maps for QC
    eval(['!/Path/to/mrtrix3/bin/mrcalc ''' b12root '/nifti/DKI.nii'' ''' b12root '/nifti/DKI_DN.nii'' ' '-subtract ''' b12root '/nifti/res.nii''']);

    %% UNRING DKI_DN.nii
 
    eval(['!/Path/to/mrtrix3/bin/mrdegibbs ''' b12root '/nifti/DKI_DN.nii'' ''' b12root '/nifti/DKI_DN_UR.nii''']);

 %% Split 4D nii into 3D nii (to average and coregister b0s)
        
V=fullfile(b12root, 'nifti/DKI_DN_UR.nii');
Vo = spm_file_split(V,[b12root '/nifti']);

%% reorganize files

%move dki1 to new folder
mkdir([b12root '/nifti/DKI1'])
dir_3D = dir(fullfile(b12root, 'nifti/DKI_DN_UR_0*.nii'));
for l=25:length(dir_3D)
    movefile([b12root '/nifti/' dir_3D(l).name], [b12root '/nifti/DKI1/' dir_3D(l).name]);
end

%move b0s to new folder
mkdir([b12root '/nifti/B0'])
dir_b0=dir_3D(1:24);
for l=1:length(dir_b0)
    dir_b0(l).newname=['B0_' dir_b0(l).name]
    movefile([b12root '/nifti/' dir_b0(l).name], [b12root '/nifti/B0/' dir_b0(l).newname]);
end

%% coregister b0s to b0 - 

%coregister b0s from separate series to b0 from dki1
fprintf('Co-registering images...\n')

fn_source = fullfile(b12root, 'nifti/B0', dir_b0(1).newname); % source file is the first b = 0 image in b0 series (00001)
fn_target = fullfile(b12root, 'nifti/DKI1', dir_3D(25).name);   % target file is b = 0 image in DKI1 series (00025)
           
M=coregister(fn_target, fn_source, fullfile(b12root, 'nifti/B0'), '.nii');

delete(fullfile(b12root, 'nifti/DKI1', ['r' dir_3D(25).name]));
movefile(fullfile(b12root, 'nifti/B0/r*.nii'),fullfile(b12root, 'nifti/B0_coreg')); 
fprintf('Co-registration complete.\n')      

%% average b0's
list = dir(fullfile(b12root,'nifti/B0_coreg/r*.nii'));
hdr = spm_vol(fullfile(b12root,'nifti/B0_coreg',list(1).name));
imgavg = spm_read_vols(hdr);

for j = 2:length(list)
    hdr = spm_vol(fullfile(b12root,'nifti/B0_coreg',list(j).name));
    img = spm_read_vols(hdr);
    imgavg = imgavg + img;
end
hdr = spm_vol(fullfile(b12root,'nifti/DKI1' ,dir_3D(25).name));
img = spm_read_vols(hdr);
imgavg = imgavg + img;
imgavg = imgavg / (length(list)+1);

mkdir(b12root, '/nifti/combined');
hdr.dt=[16 0];
hdr.fname = fullfile(b12root,'nifti/combined/B0_avg.nii');
imgavg(isnan(imgavg))=0;
spm_write_vol(hdr, imgavg);

delete(fullfile(b12root,'nifti/DKI1' ,dir_3D(25).name));

%% move DKI & make 4D nii

mkdir([b12root '/dke']);
copyfile([b12root '/nifti/DKI1/*.nii'], [b12root '/nifti/combined']);
files = dir([b12root '/nifti/combined/*.nii']);

%make 4D
for j=1:length(files)
 hdr=spm_vol(fullfile(b12root, 'nifti/combined', files(j).name));
 img=spm_read_vols(hdr);
 img(isnan(img))=0;
 hdr_final(j)=hdr;
 hdr_final(j).fname=[b12root '/dke/4D.nii'];
 hdr_final(j).n=[(j),1];
  spm_write_vol(hdr_final(j),img);
end
 
  %% make gradient file
    cd([b12root '/dicom/']);
    name=dir('*.bvec');
    A=importdata([name(1).name]);
    B=A(:,any(A));
    Gradient=B';
    Gradient1=Gradient(1:(round(end/2)),:);
    save(fullfile(b12root,'dke/gradient_dke.txt'),'Gradient1','-ASCII')
    
    %% create ft and dke params files
    
    %dke params
    fid=fopen(dke_parameters); %Original file 
    fout=fullfile(b12root,'dke/dke_parameters.txt');% new file 

    fidout=fopen(fout,'w');

	while(~feof(fid))
    s=fgetl(fid);
    s=strrep(s,'PATH_REPLACE',b12root); %s=strrep(s,'A201', subject_list{i}) replace subject
    fprintf(fidout,'%s\n',s);
    disp(s)
    end
    fclose(fid);
    fclose(fidout);
        
    %ft params
    fid=fopen(ft_parameters); %Original file 
    fout=fullfile(b12root,'dke/ft_parameters.txt');% new file 

    fidout=fopen(fout,'w');

	while(~feof(fid))
    s=fgetl(fid);
    s=strrep(s,'PATH_REPLACE',b12root); %s=strrep(s,'A201', subject_list{i}) replace subject
    fprintf(fidout,'%s\n',s);
    disp(s)
    end
    fclose(fid);
    fclose(fidout);

%% run DKE and DKE_FT

    fn_params=fullfile(b12root, 'dke', 'dke_parameters.txt')
    dke(fn_params)

    FT_parameters=fullfile(b12root, dke', 'ft_parameters.txt')
    dke_ft(FT_parameters)
    

end