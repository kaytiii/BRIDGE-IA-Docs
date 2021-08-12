%%%%%%% BASIC DKE AND DKE_FT PROCESSING - MAC

clear all

%% Variables	
subj_list={'Subj_1', 'Subj_2', 'Subj_3'} %changed based on your subject IDs
dwi_root='/Path/to/study/' %path to files you want to process with DKE
    % Folder structure should be as follows:
        %Path/to/study/subject_ID/dke/files_to_process.nii
        %Path/to/study/subject_ID/dicom/DKE_and_B0.bvec/bval
        %Note: folders within main directory should be named for each subject ID
        %   and sub folders for each subject should be named "dke" and "dicom"
dke_parameters='/Path/to/dke_parameters.txt' %path to your basic dke_parameters file
ft_parameters='/Path/to/ft_parameters.txt' %path to your basic ft_parameters file

for i=1:length(subj_list)
    b12root = [dwi_root subj_list{i}];
    
  %% make gradient file 
  %     This makes a gradient file used by DKE out of your .bvec file in your dicom folder
    cd([b12root '/dicom/']);
    name=dir('*.bvec');
    A=importdata([name(1).name]);
    B=A(:,any(A));
    Gradient=B';
    Gradient1=Gradient(1:(round(end/2)),:);
    save(fullfile(b12root,'dke/gradient_dke.txt'),'Gradient1','-ASCII')
    
    %% create ft and dke params files
    %   This will find every instance of the string "PATH_REPLACE" and
    %   replace it with each subject's folder path so that DKE knows where
    %   to look for files for every subject.
    
    %dke params
    fid=fopen(dke_parameters); %Original file 
    fout=fullfile(b12root,'dke/dke_parameters.txt');% new file 

    fidout=fopen(fout,'w');

	while(~feof(fid))
    s=fgetl(fid);
    s=strrep(s,'PATH_REPLACE',b12root); 
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
    s=strrep(s,'PATH_REPLACE',b12root); 
    fprintf(fidout,'%s\n',s);
    disp(s)
    end
    fclose(fid);
    fclose(fidout);

%% run DKE and DKE_FT

    fn_params=fullfile(b12root, 'dke', 'dke_parameters.txt')
    dke(fn_params)

    FT_parameters=fullfile(b12root, 'dke', 'ft_parameters.txt')
    dke_ft(FT_parameters)
    

end