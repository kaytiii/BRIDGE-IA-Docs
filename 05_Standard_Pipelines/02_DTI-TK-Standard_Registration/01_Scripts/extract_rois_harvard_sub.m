
roi_list = {'FNIRT_ROIsub_to_mean_FA.nii'};
region_code_list = {{[3 14] [4 15] [5 16] [6 17] [8 18] [9 19] [10 20]}};
region_string_list = {{'Thal' 'Cauda' 'Put' 'Pal' 'Hippo' 'Amyg' 'Accumb'}};

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
       
            
       
        
        

