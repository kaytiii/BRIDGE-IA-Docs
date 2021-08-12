clc
clear all
tic

%%--------------------------------------------------------------------------------
%
% Segmentation via SPM Script
% Kayti Keith
% 9/5/18
%
%----------------------------------------------------------------------------------

%% Paths and variables
Warps = '/Path/to/study/Skeletonized_Maps/'; %Orig Files
Natives = '/Path/to/study/DKE/';
Segs = '/Path/to/study/Skeletonized_Maps/';
SPM_path = '/Applications/spm12/tpm/TPM.nii'; %probability map nii file from SPM folder
id_list = {'ID1' 'ID2' 'ID3' 'IDn'};

threshold = ''; %binarization threshold; enter ONLY the values after the decimal, ex. for a threshold if 0.50, enter "50"
file_name = '_skele_bin'
  
%% File Setup
for i=1:length(subj)
    mkdir([New_Path  subj{i}])
    copyfile([Path 'MRI_Processed/dcm2niix_T1/' subj{i} '_MPRAGE_SAG.nii'],[New_Path subj{i} '/' subj{i} '_T1.nii']);
%     copyfile([Path 'MRI_Processed/dcm2niix_T2/' subj{i} '_T2_FLAIR.nii'],[New_Path subj{i} '/' subj{i} '_T2.nii']);
%     copyfile([Path 'MRI_Processed/MIND_DKE_2.6_2018/' subj{i} '/nifti_2018_06/combined/B0_avg.nii'],[New_Path subj{i} '/' subj{i} '_B0.nii']);
    copyfile([Path 'MRI_Processed/MIND_DKE_2.6_2018/' subj{i} '/nifti_2018_06/combined/B0_avg.nii'],[New_Path subj{i} '/' subj{i} '_B0.nii']);
end

for i=1:length(subj)
delete([New_Path subj{i} '/*.mat'])
% copyfile(['/Volumes/research/benitez/MIND_shared/_MIND/MRI_Processed/dcm2niix_T2/' subj{i} '_T2_FLAIR.nii'],[Path, subj{i}, '/' subj{i} '_T2.nii'])
end

for i=1:length(subj)
% copyfile([Natives subj{i} '/' subj{i} '_T2.nii'],[Natives subj{i} '/Orig' subj{i} '_T2.nii'])
copyfile([Natives subj{i} '/' subj{i} '_T1.nii'],[Natives subj{i} '/Orig' subj{i} '_T1.nii'])
copyfile([Natives subj{i} '/' subj{i} '_B0.nii'],[Natives subj{i} '/Orig' subj{i} '_B0.nii'])
end


for i=1:length(subj)
%% Segmentation
clear matlabbatch
matlabbatch{1}.spm.spatial.preproc.channel.vols = {[New_Path subj{i} '/' subj{i} '_T1.nii']};
matlabbatch{1}.spm.spatial.preproc.channel.biasreg = 0.001;
matlabbatch{1}.spm.spatial.preproc.channel.biasfwhm = 60;
matlabbatch{1}.spm.spatial.preproc.channel.write = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(1).tpm = {[SPM_path ',1']};
matlabbatch{1}.spm.spatial.preproc.tissue(1).ngaus = 1;
matlabbatch{1}.spm.spatial.preproc.tissue(1).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(1).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(2).tpm = {[SPM_path ',2']};
matlabbatch{1}.spm.spatial.preproc.tissue(2).ngaus = 1;
matlabbatch{1}.spm.spatial.preproc.tissue(2).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(2).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(3).tpm = {[SPM_path ',3']};
matlabbatch{1}.spm.spatial.preproc.tissue(3).ngaus = 2;
matlabbatch{1}.spm.spatial.preproc.tissue(3).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(3).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(4).tpm = {[SPM_path ',4']};
matlabbatch{1}.spm.spatial.preproc.tissue(4).ngaus = 3;
matlabbatch{1}.spm.spatial.preproc.tissue(4).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(4).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(5).tpm = {[SPM_path ',5']};
matlabbatch{1}.spm.spatial.preproc.tissue(5).ngaus = 4;
matlabbatch{1}.spm.spatial.preproc.tissue(5).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(5).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(6).tpm = {[SPM_path ',6']};
matlabbatch{1}.spm.spatial.preproc.tissue(6).ngaus = 2;
matlabbatch{1}.spm.spatial.preproc.tissue(6).native = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(6).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.warp.mrf = 1;
matlabbatch{1}.spm.spatial.preproc.warp.cleanup = 1;
matlabbatch{1}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
matlabbatch{1}.spm.spatial.preproc.warp.affreg = 'mni';
matlabbatch{1}.spm.spatial.preproc.warp.fwhm = 0;
matlabbatch{1}.spm.spatial.preproc.warp.samp = 3;
matlabbatch{1}.spm.spatial.preproc.warp.write = [0 0];
spm_jobman('run',matlabbatch);
    
movefile([New_Path, subj{i} '/' 'c1' subj{i} '_T1.nii'], [New_Path, subj{i} '/' subj{i} '_GM.nii'])
movefile([New_Path, subj{i} '/' 'c2' subj{i} '_T1.nii'], [New_Path, subj{i} '/' subj{i} '_WM.nii'])
movefile([New_Path, subj{i} '/' 'c3' subj{i} '_T1.nii'], [New_Path, subj{i} '/' subj{i} '_CSF.nii'])
movefile([New_Path, subj{i} '/' 'c4' subj{i} '_T1.nii'], [New_Path, subj{i} '/' subj{i} '_other1.nii'])
movefile([New_Path, subj{i} '/' 'c5' subj{i} '_T1.nii'], [New_Path, subj{i} '/' subj{i} '_other2.nii'])
delete([New_Path subj{i} '/*.mat'])

delete([Path, subj{i} '/' 'c3' subj{i} '_T1.nii'])
delete([Path, subj{i} '/' 'c4' subj{i} '_T1.nii'])
delete([Path, subj{i} '/' 'c5' subj{i} '_T1.nii'])
delete([Path, subj{i} '/' subj{i} '_T1_seg8.mat'])
    
%% Binarize GM WM CSF segments

clear matlabbatch
matlabbatch{1}.spm.util.imcalc.input = {[Segs '/' subj{i} '/' subj{i} '_filled_GM.nii']};
matlabbatch{1}.spm.util.imcalc.output = [subj{i} file_name threshold '.nii'];
matlabbatch{1}.spm.util.imcalc.outdir = {[Segs '/' subj{i} '/']};
matlabbatch{1}.spm.util.imcalc.expression = ['i1>0.' threshold];
matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 1;
matlabbatch{1}.spm.util.imcalc.options.dtype = 4;
spm_jobman('run',matlabbatch);

clear matlabbatch
matlabbatch{1}.spm.util.imcalc.input = {[Segs '/' subj{i} '/' subj{i} '_filled_WM.nii']};
matlabbatch{1}.spm.util.imcalc.output = [subj{i} file_name threshold '.nii'];
matlabbatch{1}.spm.util.imcalc.outdir = {[Segs '/' subj{i} '/']};
matlabbatch{1}.spm.util.imcalc.expression = ['i1>0.' threshold];
matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 1;
matlabbatch{1}.spm.util.imcalc.options.dtype = 4;
spm_jobman('run',matlabbatch);
end

for i=1:length(subj)
    
% mkdir([Natives subj{i} '/' subj{i}])
% copyfile([New_Path '/' subj{i} '/' subj{i} '_B0.nii'],[Natives subj{i} '/' subj{i} '_B0.nii'])
% copyfile([New_Path '/' subj{i} '/' subj{i} '_T1.nii'],[Natives subj{i} '/' subj{i} '_T1.nii'])

%% Coreg T1 to B0
clear matlabbatch
matlabbatch{1}.spm.spatial.coreg.estwrite.ref = {[Natives subj{i} '/' subj{i} '_B0.nii,1']};
matlabbatch{1}.spm.spatial.coreg.estwrite.source = {[Segs subj{i} '/' subj{i} file_name threshold '.nii,1']};
matlabbatch{1}.spm.spatial.coreg.estwrite.other = {
%                                                    [Segs subj{i} '/' subj{i} file_name threshold '.nii,1']
%                                                    [Segs subj{i} '/' subj{i} file_name threshold '.nii,1']
                                                   };
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.interp = 0;
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.mask = 0;
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.prefix = 'r';
spm_jobman('run',matlabbatch);

% mkdir([Path subj{i}])
mkdir([Warps subj{i}])

%delete([Segs subj{i} '/r' subj{i} '_T1.nii'])
copyfile([Segs subj{i} '/r' subj{i} file_name threshold '.nii'], [Warps subj{i} '/' subj{i} '_filled_WM_0' threshold '.nii'])
copyfile([Segs subj{i} '/r' subj{i} file_name threshold '.nii'], [Warps subj{i} '/' subj{i} '_filled_GM_0' threshold '.nii'])
copyfile([Natives subj{i} '/' subj{i} '_B0.nii'],[Warps subj{i} '/' subj{i} '_B0.nii'])
end

toc