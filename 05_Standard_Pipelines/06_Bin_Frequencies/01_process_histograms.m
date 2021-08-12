%%--------------------------------------------------------------------------------
%
% CAMCAN Process Histogram Script
%   ROIs from FSL's JHU & Harvard-Oxford Subcortical Atlas
%   DKI/WMM Maps from DKE2.6
%
% Creator of Original Script: Ali Tabesh
% 
%Edited: 1/14/15 by Cliff C. for Comments & Formatting
%Edited: 2/16/18 by Corinne McGill
%
%----------------------------------------------------------------------------------
%% Source of Scripts

clear all;
tic;

%% Folder Paths

%map_folder: Diffusion/CMM Maps
%roi_folder: atlas ROIs
%roi_QC_folder: output ROIs for visualization (w/CSF excluded)

base_folder = '/Path/to/study/';
roi_folder= '/Path/to/study/03_Analysis/01_Skeletonized_Maps/';
roi_QC_folder = '/Path/to/study/04_Summary/04_ROI_QC_skele/';
map_folder = '/Path/to/study/03_Analysis/01_Skeletonized_Maps/';

%% Patient ID, ROI, Processing Parameters
% Patient ID List

id_list = {'ID1' 'ID2' 'ID3' 'IDn'}
    
%roi_list = {'Genu_cc' 'Body_cc' 'Splen_cc' 'Post_Limb_Int_Cap_Comb' 'Cere_ped_Comb' 'CST_Comb' 'SLF_Comb' 'Sag_Str_Comb' 'Sup_Fr_Occ_F_Comb' 'Fornix_cres_Comb' 'Unc_Fas_Comb' 'Cing_hippo' '75_Comb_Accumbens'	'75_Comb_Amygdala'	'75_Comb_Caudate'	'75_Comb_Hippocampus'	'75_Comb_Pallidum'	'75_Comb_Putamen'	'75_Comb_Thalamus'}; 
roi_list = {'ROI1' 'ROI2' 'ROI3' 'ROIn'};

%% Maps to be analyzed for their histogram

% map_str_list = {'kmean' 'kax' 'krad' 'dmean' 'dax' 'drad' 'fa'};   
map_str_list = {'kmean' 'kax' 'krad' 'dmean' 'dax' 'drad' 'fa' 'wmm_awf' 'wmm_da' 'wmm_de_ax' 'wmm_de_rad' 'wmm_tort'};

%% Mask Outliers
fn_mask_incl_outlier = '';

% Voxels with values less than outlier_thresh are included in calculations
outlier_thresh = [15 15 15 15 15 15 15 10 10 10 10 10];  

%% Consensus Mask Threshold: Set the Percentage of agreement, Ex. 50% of 28 Subjects = consensus_thresh of 14

consensus_thresh = 0;   % voxels with consensus_thresh or more subjects agreeing on a segmentation are included
fn_mask_incl_consensus = '';

%% Histogram Processing Parameters for DKI Maps

% Histogram's Lower Limit
lolim = 0; 

% Histogram's Upper Limit
uplim_list =  [2 2 3 3 3 3 1 1 3 3 3 4.5];     

% Threshold for Dmean (Dmean > T_excl are excluded)
%T_excl = 2;                                
T_excl = 0; %fornix                               

% Number of Historam Bins
nbin = 64; 

% Whether or not to exclude first bin in histogram (default = 1)
exclude_bin1 = 1;                          

% Number of slices to exclude from the beginning and end of volumes (map and mask) to exclude from histogram computation
exclude_nslice = 0;     

region_code_list={{1}};

%% Output Locations

% mkdir(roi_QC_folder)
mkdir(fullfile(base_folder, 'Histograms_Custom_ROIs/'))
fn_out_all = fullfile(base_folder, 'Histograms_Custom_ROIs/', 'statistics_all(Histograms_Custom_ROIs).txt');


%% Processing Code

fid = fopen(fn_out_all,'w');
fprintf(fid, '\t');

for i = 1:(length(id_list)-1)
% for i = 1:(length(id_list))
    fprintf(fid, '%s\t', id_list{i});
end
fprintf(fid, '%s\n', id_list{end});
fclose(fid);



for k = 1:length(roi_list)
    
    for j = 1:length(map_str_list)
        
        map_str_list{j}
        
        %Make sure that Historam Output folder is the same & consistent as in mkdir in line 83 & 84
        output_folder = fullfile(base_folder, 'Histograms_Custom_ROIs/', roi_list{k}, map_str_list{j});
                   
        mkdir(output_folder)
            
            for i = 1:length(id_list)
                
                % Folder Containing all Maps & Masks
                img_folder = fullfile(map_folder, id_list{i});  % folder containing all maps and masks
                
                % The Maps of Volume Interest, look for the correct referencing
                fn_mask_roi = fullfile(roi_folder, id_list{i}, [roi_list{k} '.nii']);     
                
                % Mean Diffusivity Map used to Exclude CSF
                %fn_mask_excl = fullfile(img_folder, [id_list{i} '_dmean.nii']);       
                fn_mask_excl = fullfile(img_folder, [id_list{i} '_fornix.nii']);                   

                
                % Normalized / Warped Map Image
                fn_map = fullfile(img_folder, [id_list{i}, '_', map_str_list{j} '_fa0.3.nii']);                    
                
                % The Output of Histogram Files
                fn_out = fullfile(output_folder, [id_list{i} '_' map_str_list{j} '_' roi_list{k} '.txt']);    
                
                % full path to output ROI w/CSF excluded (for QC)
                roi_QC = fullfile(roi_QC_folder, [id_list{i} '_' roi_list{k} '.nii']);
                
                % The Inclusion of Voxels that are NOT Outliers
                % fn_mask_incl_outlier = fullfile(base_folder, ['C' id_list{i} '_' map_outlier_list{j} '.nii']);                         % include voxels that are NOT outliers

                % The Inclusion of Voxels within Consensus Mask (at least consensus_thresh subjects agree on segmentation)
                % AKA location of where imgsum files are located
                %fn_mask_incl_consensus = fullfile(roi_folder,  ['imgsum_' region_string_list{k}{l} '.nii']); 
               
                %% Generation of Histogram Output
                
                % With Dmean Masked & Consensus
                [binstart normfreq(:, i) freq(:, i) avg(i) stddev(i) vol(i)] = map_histogram(fn_map, fn_mask_roi, region_code_list, fn_mask_incl_outlier, outlier_thresh(j), fn_mask_incl_consensus, consensus_thresh, fn_mask_excl, T_excl, fn_out, nbin, lolim, uplim_list(j), exclude_nslice, exclude_bin1, roi_QC);

                % Column Headers for Aggregate Histogram File
                column_headers{i} = id_list{i};   % column headers for aggregate histogram file
                
            end
                        
            % write combined histogram for each map and roi
            fn_out_diff_combo = fullfile(output_folder, [map_str_list{j} '_' roi_list{k} '_combo.txt']);                % output file containing histogram
            fid = fopen(fn_out_diff_combo, 'w');
            fprintf(fid, '%s\t', 'Bin start');
            for ii = 1:(length(column_headers)-1)
                fprintf(fid, '%s\t', column_headers{ii});
            end
            fprintf(fid, '%s\n', column_headers{end});
            for ii = 1:size(normfreq, 1)
                fprintf(fid, '%f\t', binstart(ii));
                for jj = 1:(size(normfreq, 2)-1)
                    fprintf(fid, '%f\t', normfreq(ii, jj));
                end
                fprintf(fid, '%f\n', normfreq(ii, end));
            end
            
             % write combined histogram for each map and roi CM (total frequency)
          fn_out_diff_combo = fullfile(output_folder, [map_str_list{j} '_' roi_list{k} '_total_frequency.txt']);                % output file containing histogram
            fid = fopen(fn_out_diff_combo, 'w');
            fprintf(fid, '%s\t', 'Bin start');
            for ii = 1:(length(column_headers)-1)
                fprintf(fid, '%s\t', column_headers{ii});
            end
            fprintf(fid, '%s\n', column_headers{end});
            for ii = 1:size(freq, 1)
                fprintf(fid, '%f\t', binstart(ii));
                for jj = 1:(size(freq, 2)-1)
                    fprintf(fid, '%f\t', freq(ii, jj));
                end
                fprintf(fid, '%f\n', freq(ii, end));
            end  
            
            fprintf(fid, '\n');
            fprintf(fid, 'Mean:\t');
            fprintf(fid, '%f\t', avg(1:end-1));
            fprintf(fid, '%f\n', avg(end));
            fprintf(fid, 'Std dev:\t');
            fprintf(fid, '%f\t', stddev(1:end-1));
            fprintf(fid, '%f\n', stddev(end));
            fprintf(fid, 'Volume:\t');
            fprintf(fid, '%f\t', vol(1:end-1));
            fprintf(fid, '%f\n', vol(end));
            fclose(fid);

            % add means to an aggregate file
            fid = fopen(fn_out_all, 'a');
            fprintf(fid, '%s\t', [roi_list{k} '_' map_str_list{j}]);
            fprintf(fid, '%f\t', avg(1:end-1));
            fprintf(fid, '%f\n', avg(end));
            fclose(fid);
            
        end
        
end
toc;
