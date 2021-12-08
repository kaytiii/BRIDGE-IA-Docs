clear all
roi_list = {'FNIRT_ROIs_to_mean_FA.nii'};
region_string_list = {{'Genu_cc' 'Body_cc' 'Splen_cc' 'Post_Limb_Int_Cap_Comb' 'Cere_ped_Comb' 'CST_Comb' 'SLF_Comb' 'Sag_Str_Comb' 'Sup_Fr_Occ_F_Comb' 'Fornix_cres_Comb' 'Unc_Fas_Comb' 'Cing_hippo'}}; 
region_code_list = {{3 4 5 [19 20] [15 16] [7 8] [41 42] [31 32] [43 44] [39 40] [45 46] [37 38]}};

img_folder ='/Users/kayti/Desktop/Projects/IAM/DTI-TK-TBSS/03_Analysis/04_ROI_Warps'
%img_folder ='/Users/kayti/Desktop/Projects/MIND/QA_DTITK/QA_DTITK_PyDesigner-FSL/03_Analysis/04_ROI_Warps'

for i = 1:length(roi_list)
    
    for j = 1:length(region_code_list{i})
        
                  
            % read roi image
            
            fn = fullfile(img_folder, [roi_list{i}]);
            
            hdr = spm_vol(fn);        
            img = spm_read_vols(hdr);   
            
            % binarize img
            
            if isscalar(region_code_list{i}{j})     % if region code is a scalar
                img = img == region_code_list{i}{j};
            else                                    % if region code is a vector
                tmp = img == region_code_list{i}{j}(1);
                for ii = 2:length(region_code_list{i}{j})
                    tmp = tmp | (img == region_code_list{i}{j}(ii));
                end
                img = tmp;
            end               
            
                     
        % write output
        hdr.fname = fullfile(img_folder, [region_string_list{i}{j} '.nii']);
        spm_write_vol(hdr, img);
    end
end 
            
       
        
        

