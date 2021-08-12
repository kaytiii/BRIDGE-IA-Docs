clear all;
tic;

%%--------------------------------------------------------------------------------
%
% Combines the total_frequency output tables across segments and metrics
% into one table.
%
%----------------------------------------------------------------------------------

%% Folder Paths

base_folder = '/Path/to/study/03_Analysis/03_Histograms_Custom_ROIs';

%% ROI and Metric list

roi_list = {'filled_GM_095_masked' 'filled_WM_095_masked'};
metric_list = {'kmean' 'kax' 'krad' 'dmean' 'dax' 'drad' 'FA' 'wmm_awf' 'wmm_da' 'wmm_de_ax' 'wmm_de_rad' 'wmm_tort'};   

%% Processing

for i = 1:length(roi_list)
    for j = 1:length(metric_list)
        
        %read in tables
        orig_txt = fullfile(base_folder, roi_list{i}, metric_list{j}, [metric_list{j} '_' roi_list{i} '_total_frequency.txt']); 
        orig_table = readtable(orig_txt);
        orig_table([65,66,67],:) = []; %delete lines 65, 66, 67
        
        %save edited tables as .txt files
        new_table_location = fullfile(base_folder, [metric_list{j} '_' roi_list{i} '_total_frequency.txt'])
        writetable(orig_table, new_table_location)
        
    end
end

    %GM metric tables edit and reorient
        % GM dmean
        bin_label = ['GM_dmean_bin01'; 'GM_dmean_bin02'; 'GM_dmean_bin03'; 'GM_dmean_bin04'; 'GM_dmean_bin05'; 'GM_dmean_bin06'; 'GM_dmean_bin07'; 'GM_dmean_bin08'; 'GM_dmean_bin09'; 'GM_dmean_bin10'; 'GM_dmean_bin11'; 'GM_dmean_bin12'; 'GM_dmean_bin13'; 'GM_dmean_bin14'; 'GM_dmean_bin15'; 'GM_dmean_bin16'; 'GM_dmean_bin17'; 'GM_dmean_bin18'; 'GM_dmean_bin19'; 'GM_dmean_bin20'; 'GM_dmean_bin21'; 'GM_dmean_bin22'; 'GM_dmean_bin23'; 'GM_dmean_bin24'; 'GM_dmean_bin25'; 'GM_dmean_bin26'; 'GM_dmean_bin27'; 'GM_dmean_bin28'; 'GM_dmean_bin29'; 'GM_dmean_bin30'; 'GM_dmean_bin31'; 'GM_dmean_bin32'; 'GM_dmean_bin33'; 'GM_dmean_bin34'; 'GM_dmean_bin35'; 'GM_dmean_bin36'; 'GM_dmean_bin37'; 'GM_dmean_bin38'; 'GM_dmean_bin39'; 'GM_dmean_bin40'; 'GM_dmean_bin41'; 'GM_dmean_bin42'; 'GM_dmean_bin43'; 'GM_dmean_bin44'; 'GM_dmean_bin45'; 'GM_dmean_bin46'; 'GM_dmean_bin47'; 'GM_dmean_bin48'; 'GM_dmean_bin49'; 'GM_dmean_bin50'; 'GM_dmean_bin51'; 'GM_dmean_bin52'; 'GM_dmean_bin53'; 'GM_dmean_bin54'; 'GM_dmean_bin55'; 'GM_dmean_bin56'; 'GM_dmean_bin57'; 'GM_dmean_bin58'; 'GM_dmean_bin59'; 'GM_dmean_bin60'; 'GM_dmean_bin61'; 'GM_dmean_bin62'; 'GM_dmean_bin63'; 'GM_dmean_bin64'];
        orig_txt_dmean_GM = fullfile(base_folder, ['dmean_filled_GM_095_masked_total_frequency.txt']); 
        dmean_GM = readtable(orig_txt_dmean_GM);
        dmean_GM.BinLabel = [bin_label];
        dmean_GM = dmean_GM(:,[1 150 2:149]);
        dmean_GM.BinStart = [];
        dmean_GM_transp = rows2vars(dmean_GM,'VariableNamesSource','BinLabel');
        
        % GM dax
        bin_label = ['GM_dax_bin01'; 'GM_dax_bin02'; 'GM_dax_bin03'; 'GM_dax_bin04'; 'GM_dax_bin05'; 'GM_dax_bin06'; 'GM_dax_bin07'; 'GM_dax_bin08'; 'GM_dax_bin09'; 'GM_dax_bin10'; 'GM_dax_bin11'; 'GM_dax_bin12'; 'GM_dax_bin13'; 'GM_dax_bin14'; 'GM_dax_bin15'; 'GM_dax_bin16'; 'GM_dax_bin17'; 'GM_dax_bin18'; 'GM_dax_bin19'; 'GM_dax_bin20'; 'GM_dax_bin21'; 'GM_dax_bin22'; 'GM_dax_bin23'; 'GM_dax_bin24'; 'GM_dax_bin25'; 'GM_dax_bin26'; 'GM_dax_bin27'; 'GM_dax_bin28'; 'GM_dax_bin29'; 'GM_dax_bin30'; 'GM_dax_bin31'; 'GM_dax_bin32'; 'GM_dax_bin33'; 'GM_dax_bin34'; 'GM_dax_bin35'; 'GM_dax_bin36'; 'GM_dax_bin37'; 'GM_dax_bin38'; 'GM_dax_bin39'; 'GM_dax_bin40'; 'GM_dax_bin41'; 'GM_dax_bin42'; 'GM_dax_bin43'; 'GM_dax_bin44'; 'GM_dax_bin45'; 'GM_dax_bin46'; 'GM_dax_bin47'; 'GM_dax_bin48'; 'GM_dax_bin49'; 'GM_dax_bin50'; 'GM_dax_bin51'; 'GM_dax_bin52'; 'GM_dax_bin53'; 'GM_dax_bin54'; 'GM_dax_bin55'; 'GM_dax_bin56'; 'GM_dax_bin57'; 'GM_dax_bin58'; 'GM_dax_bin59'; 'GM_dax_bin60'; 'GM_dax_bin61'; 'GM_dax_bin62'; 'GM_dax_bin63'; 'GM_dax_bin64'];
        orig_txt_dax_GM = fullfile(base_folder, ['dax_filled_GM_095_masked_total_frequency.txt']); 
        dax_GM = readtable(orig_txt_dax_GM);
        dax_GM.BinLabel = [bin_label];
        dax_GM = dax_GM(:,[1 150 2:149]);
        dax_GM.BinStart = [];
        dax_GM_transp = rows2vars(dax_GM,'VariableNamesSource','BinLabel');
        dax_GM_transp.OriginalVariableNames = [];
        
        % GM drad
        bin_label = ['GM_drad_bin01'; 'GM_drad_bin02'; 'GM_drad_bin03'; 'GM_drad_bin04'; 'GM_drad_bin05'; 'GM_drad_bin06'; 'GM_drad_bin07'; 'GM_drad_bin08'; 'GM_drad_bin09'; 'GM_drad_bin10'; 'GM_drad_bin11'; 'GM_drad_bin12'; 'GM_drad_bin13'; 'GM_drad_bin14'; 'GM_drad_bin15'; 'GM_drad_bin16'; 'GM_drad_bin17'; 'GM_drad_bin18'; 'GM_drad_bin19'; 'GM_drad_bin20'; 'GM_drad_bin21'; 'GM_drad_bin22'; 'GM_drad_bin23'; 'GM_drad_bin24'; 'GM_drad_bin25'; 'GM_drad_bin26'; 'GM_drad_bin27'; 'GM_drad_bin28'; 'GM_drad_bin29'; 'GM_drad_bin30'; 'GM_drad_bin31'; 'GM_drad_bin32'; 'GM_drad_bin33'; 'GM_drad_bin34'; 'GM_drad_bin35'; 'GM_drad_bin36'; 'GM_drad_bin37'; 'GM_drad_bin38'; 'GM_drad_bin39'; 'GM_drad_bin40'; 'GM_drad_bin41'; 'GM_drad_bin42'; 'GM_drad_bin43'; 'GM_drad_bin44'; 'GM_drad_bin45'; 'GM_drad_bin46'; 'GM_drad_bin47'; 'GM_drad_bin48'; 'GM_drad_bin49'; 'GM_drad_bin50'; 'GM_drad_bin51'; 'GM_drad_bin52'; 'GM_drad_bin53'; 'GM_drad_bin54'; 'GM_drad_bin55'; 'GM_drad_bin56'; 'GM_drad_bin57'; 'GM_drad_bin58'; 'GM_drad_bin59'; 'GM_drad_bin60'; 'GM_drad_bin61'; 'GM_drad_bin62'; 'GM_drad_bin63'; 'GM_drad_bin64'];
        orig_txt_drad_GM = fullfile(base_folder, ['drad_filled_GM_095_masked_total_frequency.txt']); 
        drad_GM = readtable(orig_txt_drad_GM);
        drad_GM.BinLabel = [bin_label];
        drad_GM = drad_GM(:,[1 150 2:149]);
        drad_GM.BinStart = [];
        drad_GM_transp = rows2vars(drad_GM,'VariableNamesSource','BinLabel');
        drad_GM_transp.OriginalVariableNames = [];
        
        % GM FA
        bin_label = ['GM_FA_bin01'; 'GM_FA_bin02'; 'GM_FA_bin03'; 'GM_FA_bin04'; 'GM_FA_bin05'; 'GM_FA_bin06'; 'GM_FA_bin07'; 'GM_FA_bin08'; 'GM_FA_bin09'; 'GM_FA_bin10'; 'GM_FA_bin11'; 'GM_FA_bin12'; 'GM_FA_bin13'; 'GM_FA_bin14'; 'GM_FA_bin15'; 'GM_FA_bin16'; 'GM_FA_bin17'; 'GM_FA_bin18'; 'GM_FA_bin19'; 'GM_FA_bin20'; 'GM_FA_bin21'; 'GM_FA_bin22'; 'GM_FA_bin23'; 'GM_FA_bin24'; 'GM_FA_bin25'; 'GM_FA_bin26'; 'GM_FA_bin27'; 'GM_FA_bin28'; 'GM_FA_bin29'; 'GM_FA_bin30'; 'GM_FA_bin31'; 'GM_FA_bin32'; 'GM_FA_bin33'; 'GM_FA_bin34'; 'GM_FA_bin35'; 'GM_FA_bin36'; 'GM_FA_bin37'; 'GM_FA_bin38'; 'GM_FA_bin39'; 'GM_FA_bin40'; 'GM_FA_bin41'; 'GM_FA_bin42'; 'GM_FA_bin43'; 'GM_FA_bin44'; 'GM_FA_bin45'; 'GM_FA_bin46'; 'GM_FA_bin47'; 'GM_FA_bin48'; 'GM_FA_bin49'; 'GM_FA_bin50'; 'GM_FA_bin51'; 'GM_FA_bin52'; 'GM_FA_bin53'; 'GM_FA_bin54'; 'GM_FA_bin55'; 'GM_FA_bin56'; 'GM_FA_bin57'; 'GM_FA_bin58'; 'GM_FA_bin59'; 'GM_FA_bin60'; 'GM_FA_bin61'; 'GM_FA_bin62'; 'GM_FA_bin63'; 'GM_FA_bin64'];
        orig_txt_FA_GM = fullfile(base_folder, ['FA_filled_GM_095_masked_total_frequency.txt']); 
        FA_GM = readtable(orig_txt_FA_GM);
        FA_GM.BinLabel = [bin_label];
        FA_GM = FA_GM(:,[1 150 2:149]);
        FA_GM.BinStart = [];
        FA_GM_transp = rows2vars(FA_GM,'VariableNamesSource','BinLabel');
        FA_GM_transp.OriginalVariableNames = [];
        
        % GM kmean
        bin_label = ['GM_kmean_bin01'; 'GM_kmean_bin02'; 'GM_kmean_bin03'; 'GM_kmean_bin04'; 'GM_kmean_bin05'; 'GM_kmean_bin06'; 'GM_kmean_bin07'; 'GM_kmean_bin08'; 'GM_kmean_bin09'; 'GM_kmean_bin10'; 'GM_kmean_bin11'; 'GM_kmean_bin12'; 'GM_kmean_bin13'; 'GM_kmean_bin14'; 'GM_kmean_bin15'; 'GM_kmean_bin16'; 'GM_kmean_bin17'; 'GM_kmean_bin18'; 'GM_kmean_bin19'; 'GM_kmean_bin20'; 'GM_kmean_bin21'; 'GM_kmean_bin22'; 'GM_kmean_bin23'; 'GM_kmean_bin24'; 'GM_kmean_bin25'; 'GM_kmean_bin26'; 'GM_kmean_bin27'; 'GM_kmean_bin28'; 'GM_kmean_bin29'; 'GM_kmean_bin30'; 'GM_kmean_bin31'; 'GM_kmean_bin32'; 'GM_kmean_bin33'; 'GM_kmean_bin34'; 'GM_kmean_bin35'; 'GM_kmean_bin36'; 'GM_kmean_bin37'; 'GM_kmean_bin38'; 'GM_kmean_bin39'; 'GM_kmean_bin40'; 'GM_kmean_bin41'; 'GM_kmean_bin42'; 'GM_kmean_bin43'; 'GM_kmean_bin44'; 'GM_kmean_bin45'; 'GM_kmean_bin46'; 'GM_kmean_bin47'; 'GM_kmean_bin48'; 'GM_kmean_bin49'; 'GM_kmean_bin50'; 'GM_kmean_bin51'; 'GM_kmean_bin52'; 'GM_kmean_bin53'; 'GM_kmean_bin54'; 'GM_kmean_bin55'; 'GM_kmean_bin56'; 'GM_kmean_bin57'; 'GM_kmean_bin58'; 'GM_kmean_bin59'; 'GM_kmean_bin60'; 'GM_kmean_bin61'; 'GM_kmean_bin62'; 'GM_kmean_bin63'; 'GM_kmean_bin64'];
        orig_txt_kmean_GM = fullfile(base_folder, ['kmean_filled_GM_095_masked_total_frequency.txt']); 
        kmean_GM = readtable(orig_txt_kmean_GM);
        kmean_GM.BinLabel = [bin_label];
        kmean_GM = kmean_GM(:,[1 150 2:149]);
        kmean_GM.BinStart = [];
        kmean_GM_transp = rows2vars(kmean_GM,'VariableNamesSource','BinLabel');
        kmean_GM_transp.OriginalVariableNames = [];
        
        % GM kax
        bin_label = ['GM_kax_bin01'; 'GM_kax_bin02'; 'GM_kax_bin03'; 'GM_kax_bin04'; 'GM_kax_bin05'; 'GM_kax_bin06'; 'GM_kax_bin07'; 'GM_kax_bin08'; 'GM_kax_bin09'; 'GM_kax_bin10'; 'GM_kax_bin11'; 'GM_kax_bin12'; 'GM_kax_bin13'; 'GM_kax_bin14'; 'GM_kax_bin15'; 'GM_kax_bin16'; 'GM_kax_bin17'; 'GM_kax_bin18'; 'GM_kax_bin19'; 'GM_kax_bin20'; 'GM_kax_bin21'; 'GM_kax_bin22'; 'GM_kax_bin23'; 'GM_kax_bin24'; 'GM_kax_bin25'; 'GM_kax_bin26'; 'GM_kax_bin27'; 'GM_kax_bin28'; 'GM_kax_bin29'; 'GM_kax_bin30'; 'GM_kax_bin31'; 'GM_kax_bin32'; 'GM_kax_bin33'; 'GM_kax_bin34'; 'GM_kax_bin35'; 'GM_kax_bin36'; 'GM_kax_bin37'; 'GM_kax_bin38'; 'GM_kax_bin39'; 'GM_kax_bin40'; 'GM_kax_bin41'; 'GM_kax_bin42'; 'GM_kax_bin43'; 'GM_kax_bin44'; 'GM_kax_bin45'; 'GM_kax_bin46'; 'GM_kax_bin47'; 'GM_kax_bin48'; 'GM_kax_bin49'; 'GM_kax_bin50'; 'GM_kax_bin51'; 'GM_kax_bin52'; 'GM_kax_bin53'; 'GM_kax_bin54'; 'GM_kax_bin55'; 'GM_kax_bin56'; 'GM_kax_bin57'; 'GM_kax_bin58'; 'GM_kax_bin59'; 'GM_kax_bin60'; 'GM_kax_bin61'; 'GM_kax_bin62'; 'GM_kax_bin63'; 'GM_kax_bin64'];
        orig_txt_kax_GM = fullfile(base_folder, ['kax_filled_GM_095_masked_total_frequency.txt']); 
        kax_GM = readtable(orig_txt_kax_GM);
        kax_GM.BinLabel = [bin_label];
        kax_GM = kax_GM(:,[1 150 2:149]);
        kax_GM.BinStart = [];
        kax_GM_transp = rows2vars(kax_GM,'VariableNamesSource','BinLabel');
        kax_GM_transp.OriginalVariableNames = [];
        
        % GM krad
        bin_label = ['GM_krad_bin01'; 'GM_krad_bin02'; 'GM_krad_bin03'; 'GM_krad_bin04'; 'GM_krad_bin05'; 'GM_krad_bin06'; 'GM_krad_bin07'; 'GM_krad_bin08'; 'GM_krad_bin09'; 'GM_krad_bin10'; 'GM_krad_bin11'; 'GM_krad_bin12'; 'GM_krad_bin13'; 'GM_krad_bin14'; 'GM_krad_bin15'; 'GM_krad_bin16'; 'GM_krad_bin17'; 'GM_krad_bin18'; 'GM_krad_bin19'; 'GM_krad_bin20'; 'GM_krad_bin21'; 'GM_krad_bin22'; 'GM_krad_bin23'; 'GM_krad_bin24'; 'GM_krad_bin25'; 'GM_krad_bin26'; 'GM_krad_bin27'; 'GM_krad_bin28'; 'GM_krad_bin29'; 'GM_krad_bin30'; 'GM_krad_bin31'; 'GM_krad_bin32'; 'GM_krad_bin33'; 'GM_krad_bin34'; 'GM_krad_bin35'; 'GM_krad_bin36'; 'GM_krad_bin37'; 'GM_krad_bin38'; 'GM_krad_bin39'; 'GM_krad_bin40'; 'GM_krad_bin41'; 'GM_krad_bin42'; 'GM_krad_bin43'; 'GM_krad_bin44'; 'GM_krad_bin45'; 'GM_krad_bin46'; 'GM_krad_bin47'; 'GM_krad_bin48'; 'GM_krad_bin49'; 'GM_krad_bin50'; 'GM_krad_bin51'; 'GM_krad_bin52'; 'GM_krad_bin53'; 'GM_krad_bin54'; 'GM_krad_bin55'; 'GM_krad_bin56'; 'GM_krad_bin57'; 'GM_krad_bin58'; 'GM_krad_bin59'; 'GM_krad_bin60'; 'GM_krad_bin61'; 'GM_krad_bin62'; 'GM_krad_bin63'; 'GM_krad_bin64'];
        orig_txt_krad_GM = fullfile(base_folder, ['krad_filled_GM_095_masked_total_frequency.txt']); 
        krad_GM = readtable(orig_txt_krad_GM);
        krad_GM.BinLabel = [bin_label];
        krad_GM = krad_GM(:,[1 150 2:149]);
        krad_GM.BinStart = [];
        krad_GM_transp = rows2vars(krad_GM,'VariableNamesSource','BinLabel');
        krad_GM_transp.OriginalVariableNames = [];
        
        % GM wmm_awf
        bin_label = ['GM_wmm_awf_bin01'; 'GM_wmm_awf_bin02'; 'GM_wmm_awf_bin03'; 'GM_wmm_awf_bin04'; 'GM_wmm_awf_bin05'; 'GM_wmm_awf_bin06'; 'GM_wmm_awf_bin07'; 'GM_wmm_awf_bin08'; 'GM_wmm_awf_bin09'; 'GM_wmm_awf_bin10'; 'GM_wmm_awf_bin11'; 'GM_wmm_awf_bin12'; 'GM_wmm_awf_bin13'; 'GM_wmm_awf_bin14'; 'GM_wmm_awf_bin15'; 'GM_wmm_awf_bin16'; 'GM_wmm_awf_bin17'; 'GM_wmm_awf_bin18'; 'GM_wmm_awf_bin19'; 'GM_wmm_awf_bin20'; 'GM_wmm_awf_bin21'; 'GM_wmm_awf_bin22'; 'GM_wmm_awf_bin23'; 'GM_wmm_awf_bin24'; 'GM_wmm_awf_bin25'; 'GM_wmm_awf_bin26'; 'GM_wmm_awf_bin27'; 'GM_wmm_awf_bin28'; 'GM_wmm_awf_bin29'; 'GM_wmm_awf_bin30'; 'GM_wmm_awf_bin31'; 'GM_wmm_awf_bin32'; 'GM_wmm_awf_bin33'; 'GM_wmm_awf_bin34'; 'GM_wmm_awf_bin35'; 'GM_wmm_awf_bin36'; 'GM_wmm_awf_bin37'; 'GM_wmm_awf_bin38'; 'GM_wmm_awf_bin39'; 'GM_wmm_awf_bin40'; 'GM_wmm_awf_bin41'; 'GM_wmm_awf_bin42'; 'GM_wmm_awf_bin43'; 'GM_wmm_awf_bin44'; 'GM_wmm_awf_bin45'; 'GM_wmm_awf_bin46'; 'GM_wmm_awf_bin47'; 'GM_wmm_awf_bin48'; 'GM_wmm_awf_bin49'; 'GM_wmm_awf_bin50'; 'GM_wmm_awf_bin51'; 'GM_wmm_awf_bin52'; 'GM_wmm_awf_bin53'; 'GM_wmm_awf_bin54'; 'GM_wmm_awf_bin55'; 'GM_wmm_awf_bin56'; 'GM_wmm_awf_bin57'; 'GM_wmm_awf_bin58'; 'GM_wmm_awf_bin59'; 'GM_wmm_awf_bin60'; 'GM_wmm_awf_bin61'; 'GM_wmm_awf_bin62'; 'GM_wmm_awf_bin63'; 'GM_wmm_awf_bin64'];
        orig_txt_wmm_awf_GM = fullfile(base_folder, ['wmm_awf_filled_GM_095_masked_total_frequency.txt']); 
        wmm_awf_GM = readtable(orig_txt_wmm_awf_GM);
        wmm_awf_GM.BinLabel = [bin_label];
        wmm_awf_GM = wmm_awf_GM(:,[1 150 2:149]);
        wmm_awf_GM.BinStart = [];
        wmm_awf_GM_transp = rows2vars(wmm_awf_GM,'VariableNamesSource','BinLabel');
        wmm_awf_GM_transp.OriginalVariableNames = [];
        
        % GM wmm_da
        bin_label = ['GM_wmm_da_bin01'; 'GM_wmm_da_bin02'; 'GM_wmm_da_bin03'; 'GM_wmm_da_bin04'; 'GM_wmm_da_bin05'; 'GM_wmm_da_bin06'; 'GM_wmm_da_bin07'; 'GM_wmm_da_bin08'; 'GM_wmm_da_bin09'; 'GM_wmm_da_bin10'; 'GM_wmm_da_bin11'; 'GM_wmm_da_bin12'; 'GM_wmm_da_bin13'; 'GM_wmm_da_bin14'; 'GM_wmm_da_bin15'; 'GM_wmm_da_bin16'; 'GM_wmm_da_bin17'; 'GM_wmm_da_bin18'; 'GM_wmm_da_bin19'; 'GM_wmm_da_bin20'; 'GM_wmm_da_bin21'; 'GM_wmm_da_bin22'; 'GM_wmm_da_bin23'; 'GM_wmm_da_bin24'; 'GM_wmm_da_bin25'; 'GM_wmm_da_bin26'; 'GM_wmm_da_bin27'; 'GM_wmm_da_bin28'; 'GM_wmm_da_bin29'; 'GM_wmm_da_bin30'; 'GM_wmm_da_bin31'; 'GM_wmm_da_bin32'; 'GM_wmm_da_bin33'; 'GM_wmm_da_bin34'; 'GM_wmm_da_bin35'; 'GM_wmm_da_bin36'; 'GM_wmm_da_bin37'; 'GM_wmm_da_bin38'; 'GM_wmm_da_bin39'; 'GM_wmm_da_bin40'; 'GM_wmm_da_bin41'; 'GM_wmm_da_bin42'; 'GM_wmm_da_bin43'; 'GM_wmm_da_bin44'; 'GM_wmm_da_bin45'; 'GM_wmm_da_bin46'; 'GM_wmm_da_bin47'; 'GM_wmm_da_bin48'; 'GM_wmm_da_bin49'; 'GM_wmm_da_bin50'; 'GM_wmm_da_bin51'; 'GM_wmm_da_bin52'; 'GM_wmm_da_bin53'; 'GM_wmm_da_bin54'; 'GM_wmm_da_bin55'; 'GM_wmm_da_bin56'; 'GM_wmm_da_bin57'; 'GM_wmm_da_bin58'; 'GM_wmm_da_bin59'; 'GM_wmm_da_bin60'; 'GM_wmm_da_bin61'; 'GM_wmm_da_bin62'; 'GM_wmm_da_bin63'; 'GM_wmm_da_bin64'];
        orig_txt_wmm_da_GM = fullfile(base_folder, ['wmm_da_filled_GM_095_masked_total_frequency.txt']); 
        wmm_da_GM = readtable(orig_txt_wmm_da_GM);
        wmm_da_GM.BinLabel = [bin_label];
        wmm_da_GM = wmm_da_GM(:,[1 150 2:149]);
        wmm_da_GM.BinStart = [];
        wmm_da_GM_transp = rows2vars(wmm_da_GM,'VariableNamesSource','BinLabel');
        wmm_da_GM_transp.OriginalVariableNames = [];
        
        % GM wmm_de_ax
        bin_label = ['GM_wmm_de_ax_bin01'; 'GM_wmm_de_ax_bin02'; 'GM_wmm_de_ax_bin03'; 'GM_wmm_de_ax_bin04'; 'GM_wmm_de_ax_bin05'; 'GM_wmm_de_ax_bin06'; 'GM_wmm_de_ax_bin07'; 'GM_wmm_de_ax_bin08'; 'GM_wmm_de_ax_bin09'; 'GM_wmm_de_ax_bin10'; 'GM_wmm_de_ax_bin11'; 'GM_wmm_de_ax_bin12'; 'GM_wmm_de_ax_bin13'; 'GM_wmm_de_ax_bin14'; 'GM_wmm_de_ax_bin15'; 'GM_wmm_de_ax_bin16'; 'GM_wmm_de_ax_bin17'; 'GM_wmm_de_ax_bin18'; 'GM_wmm_de_ax_bin19'; 'GM_wmm_de_ax_bin20'; 'GM_wmm_de_ax_bin21'; 'GM_wmm_de_ax_bin22'; 'GM_wmm_de_ax_bin23'; 'GM_wmm_de_ax_bin24'; 'GM_wmm_de_ax_bin25'; 'GM_wmm_de_ax_bin26'; 'GM_wmm_de_ax_bin27'; 'GM_wmm_de_ax_bin28'; 'GM_wmm_de_ax_bin29'; 'GM_wmm_de_ax_bin30'; 'GM_wmm_de_ax_bin31'; 'GM_wmm_de_ax_bin32'; 'GM_wmm_de_ax_bin33'; 'GM_wmm_de_ax_bin34'; 'GM_wmm_de_ax_bin35'; 'GM_wmm_de_ax_bin36'; 'GM_wmm_de_ax_bin37'; 'GM_wmm_de_ax_bin38'; 'GM_wmm_de_ax_bin39'; 'GM_wmm_de_ax_bin40'; 'GM_wmm_de_ax_bin41'; 'GM_wmm_de_ax_bin42'; 'GM_wmm_de_ax_bin43'; 'GM_wmm_de_ax_bin44'; 'GM_wmm_de_ax_bin45'; 'GM_wmm_de_ax_bin46'; 'GM_wmm_de_ax_bin47'; 'GM_wmm_de_ax_bin48'; 'GM_wmm_de_ax_bin49'; 'GM_wmm_de_ax_bin50'; 'GM_wmm_de_ax_bin51'; 'GM_wmm_de_ax_bin52'; 'GM_wmm_de_ax_bin53'; 'GM_wmm_de_ax_bin54'; 'GM_wmm_de_ax_bin55'; 'GM_wmm_de_ax_bin56'; 'GM_wmm_de_ax_bin57'; 'GM_wmm_de_ax_bin58'; 'GM_wmm_de_ax_bin59'; 'GM_wmm_de_ax_bin60'; 'GM_wmm_de_ax_bin61'; 'GM_wmm_de_ax_bin62'; 'GM_wmm_de_ax_bin63'; 'GM_wmm_de_ax_bin64'];
        orig_txt_wmm_de_ax_GM = fullfile(base_folder, ['wmm_de_ax_filled_GM_095_masked_total_frequency.txt']); 
        wmm_de_ax_GM = readtable(orig_txt_wmm_de_ax_GM);
        wmm_de_ax_GM.BinLabel = [bin_label];
        wmm_de_ax_GM = wmm_de_ax_GM(:,[1 150 2:149]);
        wmm_de_ax_GM.BinStart = [];
        wmm_de_ax_GM_transp = rows2vars(wmm_de_ax_GM,'VariableNamesSource','BinLabel');
        wmm_de_ax_GM_transp.OriginalVariableNames = [];
        
        % GM wmm_de_rad
        bin_label = ['GM_wmm_de_rad_bin01'; 'GM_wmm_de_rad_bin02'; 'GM_wmm_de_rad_bin03'; 'GM_wmm_de_rad_bin04'; 'GM_wmm_de_rad_bin05'; 'GM_wmm_de_rad_bin06'; 'GM_wmm_de_rad_bin07'; 'GM_wmm_de_rad_bin08'; 'GM_wmm_de_rad_bin09'; 'GM_wmm_de_rad_bin10'; 'GM_wmm_de_rad_bin11'; 'GM_wmm_de_rad_bin12'; 'GM_wmm_de_rad_bin13'; 'GM_wmm_de_rad_bin14'; 'GM_wmm_de_rad_bin15'; 'GM_wmm_de_rad_bin16'; 'GM_wmm_de_rad_bin17'; 'GM_wmm_de_rad_bin18'; 'GM_wmm_de_rad_bin19'; 'GM_wmm_de_rad_bin20'; 'GM_wmm_de_rad_bin21'; 'GM_wmm_de_rad_bin22'; 'GM_wmm_de_rad_bin23'; 'GM_wmm_de_rad_bin24'; 'GM_wmm_de_rad_bin25'; 'GM_wmm_de_rad_bin26'; 'GM_wmm_de_rad_bin27'; 'GM_wmm_de_rad_bin28'; 'GM_wmm_de_rad_bin29'; 'GM_wmm_de_rad_bin30'; 'GM_wmm_de_rad_bin31'; 'GM_wmm_de_rad_bin32'; 'GM_wmm_de_rad_bin33'; 'GM_wmm_de_rad_bin34'; 'GM_wmm_de_rad_bin35'; 'GM_wmm_de_rad_bin36'; 'GM_wmm_de_rad_bin37'; 'GM_wmm_de_rad_bin38'; 'GM_wmm_de_rad_bin39'; 'GM_wmm_de_rad_bin40'; 'GM_wmm_de_rad_bin41'; 'GM_wmm_de_rad_bin42'; 'GM_wmm_de_rad_bin43'; 'GM_wmm_de_rad_bin44'; 'GM_wmm_de_rad_bin45'; 'GM_wmm_de_rad_bin46'; 'GM_wmm_de_rad_bin47'; 'GM_wmm_de_rad_bin48'; 'GM_wmm_de_rad_bin49'; 'GM_wmm_de_rad_bin50'; 'GM_wmm_de_rad_bin51'; 'GM_wmm_de_rad_bin52'; 'GM_wmm_de_rad_bin53'; 'GM_wmm_de_rad_bin54'; 'GM_wmm_de_rad_bin55'; 'GM_wmm_de_rad_bin56'; 'GM_wmm_de_rad_bin57'; 'GM_wmm_de_rad_bin58'; 'GM_wmm_de_rad_bin59'; 'GM_wmm_de_rad_bin60'; 'GM_wmm_de_rad_bin61'; 'GM_wmm_de_rad_bin62'; 'GM_wmm_de_rad_bin63'; 'GM_wmm_de_rad_bin64'];
        orig_txt_wmm_de_rad_GM = fullfile(base_folder, ['wmm_de_rad_filled_GM_095_masked_total_frequency.txt']); 
        wmm_de_rad_GM = readtable(orig_txt_wmm_de_rad_GM);
        wmm_de_rad_GM.BinLabel = [bin_label];
        wmm_de_rad_GM = wmm_de_rad_GM(:,[1 150 2:149]);
        wmm_de_rad_GM.BinStart = [];
        wmm_de_rad_GM_transp = rows2vars(wmm_de_rad_GM,'VariableNamesSource','BinLabel');
        wmm_de_rad_GM_transp.OriginalVariableNames = [];
        
        % GM wmm_tort
        bin_label = ['GM_wmm_tort_bin01'; 'GM_wmm_tort_bin02'; 'GM_wmm_tort_bin03'; 'GM_wmm_tort_bin04'; 'GM_wmm_tort_bin05'; 'GM_wmm_tort_bin06'; 'GM_wmm_tort_bin07'; 'GM_wmm_tort_bin08'; 'GM_wmm_tort_bin09'; 'GM_wmm_tort_bin10'; 'GM_wmm_tort_bin11'; 'GM_wmm_tort_bin12'; 'GM_wmm_tort_bin13'; 'GM_wmm_tort_bin14'; 'GM_wmm_tort_bin15'; 'GM_wmm_tort_bin16'; 'GM_wmm_tort_bin17'; 'GM_wmm_tort_bin18'; 'GM_wmm_tort_bin19'; 'GM_wmm_tort_bin20'; 'GM_wmm_tort_bin21'; 'GM_wmm_tort_bin22'; 'GM_wmm_tort_bin23'; 'GM_wmm_tort_bin24'; 'GM_wmm_tort_bin25'; 'GM_wmm_tort_bin26'; 'GM_wmm_tort_bin27'; 'GM_wmm_tort_bin28'; 'GM_wmm_tort_bin29'; 'GM_wmm_tort_bin30'; 'GM_wmm_tort_bin31'; 'GM_wmm_tort_bin32'; 'GM_wmm_tort_bin33'; 'GM_wmm_tort_bin34'; 'GM_wmm_tort_bin35'; 'GM_wmm_tort_bin36'; 'GM_wmm_tort_bin37'; 'GM_wmm_tort_bin38'; 'GM_wmm_tort_bin39'; 'GM_wmm_tort_bin40'; 'GM_wmm_tort_bin41'; 'GM_wmm_tort_bin42'; 'GM_wmm_tort_bin43'; 'GM_wmm_tort_bin44'; 'GM_wmm_tort_bin45'; 'GM_wmm_tort_bin46'; 'GM_wmm_tort_bin47'; 'GM_wmm_tort_bin48'; 'GM_wmm_tort_bin49'; 'GM_wmm_tort_bin50'; 'GM_wmm_tort_bin51'; 'GM_wmm_tort_bin52'; 'GM_wmm_tort_bin53'; 'GM_wmm_tort_bin54'; 'GM_wmm_tort_bin55'; 'GM_wmm_tort_bin56'; 'GM_wmm_tort_bin57'; 'GM_wmm_tort_bin58'; 'GM_wmm_tort_bin59'; 'GM_wmm_tort_bin60'; 'GM_wmm_tort_bin61'; 'GM_wmm_tort_bin62'; 'GM_wmm_tort_bin63'; 'GM_wmm_tort_bin64'];
        orig_txt_wmm_tort_GM = fullfile(base_folder, ['wmm_tort_filled_GM_095_masked_total_frequency.txt']); 
        wmm_tort_GM = readtable(orig_txt_wmm_tort_GM);
        wmm_tort_GM.BinLabel = [bin_label];
        wmm_tort_GM = wmm_tort_GM(:,[1 150 2:149]);
        wmm_tort_GM.BinStart = [];
        wmm_tort_GM_transp = rows2vars(wmm_tort_GM,'VariableNamesSource','BinLabel');
        wmm_tort_GM_transp.OriginalVariableNames = [];
        
    %WM metric tables edit and reorient
        % WM dmean
        bin_label = ['WM_dmean_bin01'; 'WM_dmean_bin02'; 'WM_dmean_bin03'; 'WM_dmean_bin04'; 'WM_dmean_bin05'; 'WM_dmean_bin06'; 'WM_dmean_bin07'; 'WM_dmean_bin08'; 'WM_dmean_bin09'; 'WM_dmean_bin10'; 'WM_dmean_bin11'; 'WM_dmean_bin12'; 'WM_dmean_bin13'; 'WM_dmean_bin14'; 'WM_dmean_bin15'; 'WM_dmean_bin16'; 'WM_dmean_bin17'; 'WM_dmean_bin18'; 'WM_dmean_bin19'; 'WM_dmean_bin20'; 'WM_dmean_bin21'; 'WM_dmean_bin22'; 'WM_dmean_bin23'; 'WM_dmean_bin24'; 'WM_dmean_bin25'; 'WM_dmean_bin26'; 'WM_dmean_bin27'; 'WM_dmean_bin28'; 'WM_dmean_bin29'; 'WM_dmean_bin30'; 'WM_dmean_bin31'; 'WM_dmean_bin32'; 'WM_dmean_bin33'; 'WM_dmean_bin34'; 'WM_dmean_bin35'; 'WM_dmean_bin36'; 'WM_dmean_bin37'; 'WM_dmean_bin38'; 'WM_dmean_bin39'; 'WM_dmean_bin40'; 'WM_dmean_bin41'; 'WM_dmean_bin42'; 'WM_dmean_bin43'; 'WM_dmean_bin44'; 'WM_dmean_bin45'; 'WM_dmean_bin46'; 'WM_dmean_bin47'; 'WM_dmean_bin48'; 'WM_dmean_bin49'; 'WM_dmean_bin50'; 'WM_dmean_bin51'; 'WM_dmean_bin52'; 'WM_dmean_bin53'; 'WM_dmean_bin54'; 'WM_dmean_bin55'; 'WM_dmean_bin56'; 'WM_dmean_bin57'; 'WM_dmean_bin58'; 'WM_dmean_bin59'; 'WM_dmean_bin60'; 'WM_dmean_bin61'; 'WM_dmean_bin62'; 'WM_dmean_bin63'; 'WM_dmean_bin64'];
        orig_txt_dmean_WM = fullfile(base_folder, ['dmean_filled_WM_095_masked_total_frequency.txt']); 
        dmean_WM = readtable(orig_txt_dmean_WM);
        dmean_WM.BinLabel = [bin_label];
        dmean_WM = dmean_WM(:,[1 150 2:149]);
        dmean_WM.BinStart = [];
        dmean_WM_transp = rows2vars(dmean_WM,'VariableNamesSource','BinLabel');
        dmean_WM_transp.OriginalVariableNames = [];
        
        % WM dax
        bin_label = ['WM_dax_bin01'; 'WM_dax_bin02'; 'WM_dax_bin03'; 'WM_dax_bin04'; 'WM_dax_bin05'; 'WM_dax_bin06'; 'WM_dax_bin07'; 'WM_dax_bin08'; 'WM_dax_bin09'; 'WM_dax_bin10'; 'WM_dax_bin11'; 'WM_dax_bin12'; 'WM_dax_bin13'; 'WM_dax_bin14'; 'WM_dax_bin15'; 'WM_dax_bin16'; 'WM_dax_bin17'; 'WM_dax_bin18'; 'WM_dax_bin19'; 'WM_dax_bin20'; 'WM_dax_bin21'; 'WM_dax_bin22'; 'WM_dax_bin23'; 'WM_dax_bin24'; 'WM_dax_bin25'; 'WM_dax_bin26'; 'WM_dax_bin27'; 'WM_dax_bin28'; 'WM_dax_bin29'; 'WM_dax_bin30'; 'WM_dax_bin31'; 'WM_dax_bin32'; 'WM_dax_bin33'; 'WM_dax_bin34'; 'WM_dax_bin35'; 'WM_dax_bin36'; 'WM_dax_bin37'; 'WM_dax_bin38'; 'WM_dax_bin39'; 'WM_dax_bin40'; 'WM_dax_bin41'; 'WM_dax_bin42'; 'WM_dax_bin43'; 'WM_dax_bin44'; 'WM_dax_bin45'; 'WM_dax_bin46'; 'WM_dax_bin47'; 'WM_dax_bin48'; 'WM_dax_bin49'; 'WM_dax_bin50'; 'WM_dax_bin51'; 'WM_dax_bin52'; 'WM_dax_bin53'; 'WM_dax_bin54'; 'WM_dax_bin55'; 'WM_dax_bin56'; 'WM_dax_bin57'; 'WM_dax_bin58'; 'WM_dax_bin59'; 'WM_dax_bin60'; 'WM_dax_bin61'; 'WM_dax_bin62'; 'WM_dax_bin63'; 'WM_dax_bin64'];
        orig_txt_dax_WM = fullfile(base_folder, ['dax_filled_WM_095_masked_total_frequency.txt']); 
        dax_WM = readtable(orig_txt_dax_WM);
        dax_WM.BinLabel = [bin_label];
        dax_WM = dax_WM(:,[1 150 2:149]);
        dax_WM.BinStart = [];
        dax_WM_transp = rows2vars(dax_WM,'VariableNamesSource','BinLabel');
        dax_WM_transp.OriginalVariableNames = [];
        
        % WM drad
        bin_label = ['WM_drad_bin01'; 'WM_drad_bin02'; 'WM_drad_bin03'; 'WM_drad_bin04'; 'WM_drad_bin05'; 'WM_drad_bin06'; 'WM_drad_bin07'; 'WM_drad_bin08'; 'WM_drad_bin09'; 'WM_drad_bin10'; 'WM_drad_bin11'; 'WM_drad_bin12'; 'WM_drad_bin13'; 'WM_drad_bin14'; 'WM_drad_bin15'; 'WM_drad_bin16'; 'WM_drad_bin17'; 'WM_drad_bin18'; 'WM_drad_bin19'; 'WM_drad_bin20'; 'WM_drad_bin21'; 'WM_drad_bin22'; 'WM_drad_bin23'; 'WM_drad_bin24'; 'WM_drad_bin25'; 'WM_drad_bin26'; 'WM_drad_bin27'; 'WM_drad_bin28'; 'WM_drad_bin29'; 'WM_drad_bin30'; 'WM_drad_bin31'; 'WM_drad_bin32'; 'WM_drad_bin33'; 'WM_drad_bin34'; 'WM_drad_bin35'; 'WM_drad_bin36'; 'WM_drad_bin37'; 'WM_drad_bin38'; 'WM_drad_bin39'; 'WM_drad_bin40'; 'WM_drad_bin41'; 'WM_drad_bin42'; 'WM_drad_bin43'; 'WM_drad_bin44'; 'WM_drad_bin45'; 'WM_drad_bin46'; 'WM_drad_bin47'; 'WM_drad_bin48'; 'WM_drad_bin49'; 'WM_drad_bin50'; 'WM_drad_bin51'; 'WM_drad_bin52'; 'WM_drad_bin53'; 'WM_drad_bin54'; 'WM_drad_bin55'; 'WM_drad_bin56'; 'WM_drad_bin57'; 'WM_drad_bin58'; 'WM_drad_bin59'; 'WM_drad_bin60'; 'WM_drad_bin61'; 'WM_drad_bin62'; 'WM_drad_bin63'; 'WM_drad_bin64'];
        orig_txt_drad_WM = fullfile(base_folder, ['drad_filled_WM_095_masked_total_frequency.txt']); 
        drad_WM = readtable(orig_txt_drad_WM);
        drad_WM.BinLabel = [bin_label];
        drad_WM = drad_WM(:,[1 150 2:149]);
        drad_WM.BinStart = [];
        drad_WM_transp = rows2vars(drad_WM,'VariableNamesSource','BinLabel');
        drad_WM_transp.OriginalVariableNames = [];
        
        % WM FA
        bin_label = ['WM_FA_bin01'; 'WM_FA_bin02'; 'WM_FA_bin03'; 'WM_FA_bin04'; 'WM_FA_bin05'; 'WM_FA_bin06'; 'WM_FA_bin07'; 'WM_FA_bin08'; 'WM_FA_bin09'; 'WM_FA_bin10'; 'WM_FA_bin11'; 'WM_FA_bin12'; 'WM_FA_bin13'; 'WM_FA_bin14'; 'WM_FA_bin15'; 'WM_FA_bin16'; 'WM_FA_bin17'; 'WM_FA_bin18'; 'WM_FA_bin19'; 'WM_FA_bin20'; 'WM_FA_bin21'; 'WM_FA_bin22'; 'WM_FA_bin23'; 'WM_FA_bin24'; 'WM_FA_bin25'; 'WM_FA_bin26'; 'WM_FA_bin27'; 'WM_FA_bin28'; 'WM_FA_bin29'; 'WM_FA_bin30'; 'WM_FA_bin31'; 'WM_FA_bin32'; 'WM_FA_bin33'; 'WM_FA_bin34'; 'WM_FA_bin35'; 'WM_FA_bin36'; 'WM_FA_bin37'; 'WM_FA_bin38'; 'WM_FA_bin39'; 'WM_FA_bin40'; 'WM_FA_bin41'; 'WM_FA_bin42'; 'WM_FA_bin43'; 'WM_FA_bin44'; 'WM_FA_bin45'; 'WM_FA_bin46'; 'WM_FA_bin47'; 'WM_FA_bin48'; 'WM_FA_bin49'; 'WM_FA_bin50'; 'WM_FA_bin51'; 'WM_FA_bin52'; 'WM_FA_bin53'; 'WM_FA_bin54'; 'WM_FA_bin55'; 'WM_FA_bin56'; 'WM_FA_bin57'; 'WM_FA_bin58'; 'WM_FA_bin59'; 'WM_FA_bin60'; 'WM_FA_bin61'; 'WM_FA_bin62'; 'WM_FA_bin63'; 'WM_FA_bin64'];
        orig_txt_FA_WM = fullfile(base_folder, ['FA_filled_WM_095_masked_total_frequency.txt']); 
        FA_WM = readtable(orig_txt_FA_WM);
        FA_WM.BinLabel = [bin_label];
        FA_WM = FA_WM(:,[1 150 2:149]);
        FA_WM.BinStart = [];
        FA_WM_transp = rows2vars(FA_WM,'VariableNamesSource','BinLabel');
        FA_WM_transp.OriginalVariableNames = [];
        
        % WM kmean
        bin_label = ['WM_kmean_bin01'; 'WM_kmean_bin02'; 'WM_kmean_bin03'; 'WM_kmean_bin04'; 'WM_kmean_bin05'; 'WM_kmean_bin06'; 'WM_kmean_bin07'; 'WM_kmean_bin08'; 'WM_kmean_bin09'; 'WM_kmean_bin10'; 'WM_kmean_bin11'; 'WM_kmean_bin12'; 'WM_kmean_bin13'; 'WM_kmean_bin14'; 'WM_kmean_bin15'; 'WM_kmean_bin16'; 'WM_kmean_bin17'; 'WM_kmean_bin18'; 'WM_kmean_bin19'; 'WM_kmean_bin20'; 'WM_kmean_bin21'; 'WM_kmean_bin22'; 'WM_kmean_bin23'; 'WM_kmean_bin24'; 'WM_kmean_bin25'; 'WM_kmean_bin26'; 'WM_kmean_bin27'; 'WM_kmean_bin28'; 'WM_kmean_bin29'; 'WM_kmean_bin30'; 'WM_kmean_bin31'; 'WM_kmean_bin32'; 'WM_kmean_bin33'; 'WM_kmean_bin34'; 'WM_kmean_bin35'; 'WM_kmean_bin36'; 'WM_kmean_bin37'; 'WM_kmean_bin38'; 'WM_kmean_bin39'; 'WM_kmean_bin40'; 'WM_kmean_bin41'; 'WM_kmean_bin42'; 'WM_kmean_bin43'; 'WM_kmean_bin44'; 'WM_kmean_bin45'; 'WM_kmean_bin46'; 'WM_kmean_bin47'; 'WM_kmean_bin48'; 'WM_kmean_bin49'; 'WM_kmean_bin50'; 'WM_kmean_bin51'; 'WM_kmean_bin52'; 'WM_kmean_bin53'; 'WM_kmean_bin54'; 'WM_kmean_bin55'; 'WM_kmean_bin56'; 'WM_kmean_bin57'; 'WM_kmean_bin58'; 'WM_kmean_bin59'; 'WM_kmean_bin60'; 'WM_kmean_bin61'; 'WM_kmean_bin62'; 'WM_kmean_bin63'; 'WM_kmean_bin64'];
        orig_txt_kmean_WM = fullfile(base_folder, ['kmean_filled_WM_095_masked_total_frequency.txt']); 
        kmean_WM = readtable(orig_txt_kmean_WM);
        kmean_WM.BinLabel = [bin_label];
        kmean_WM = kmean_WM(:,[1 150 2:149]);
        kmean_WM.BinStart = [];
        kmean_WM_transp = rows2vars(kmean_WM,'VariableNamesSource','BinLabel');
        kmean_WM_transp.OriginalVariableNames = [];
        
        % WM kax
        bin_label = ['WM_kax_bin01'; 'WM_kax_bin02'; 'WM_kax_bin03'; 'WM_kax_bin04'; 'WM_kax_bin05'; 'WM_kax_bin06'; 'WM_kax_bin07'; 'WM_kax_bin08'; 'WM_kax_bin09'; 'WM_kax_bin10'; 'WM_kax_bin11'; 'WM_kax_bin12'; 'WM_kax_bin13'; 'WM_kax_bin14'; 'WM_kax_bin15'; 'WM_kax_bin16'; 'WM_kax_bin17'; 'WM_kax_bin18'; 'WM_kax_bin19'; 'WM_kax_bin20'; 'WM_kax_bin21'; 'WM_kax_bin22'; 'WM_kax_bin23'; 'WM_kax_bin24'; 'WM_kax_bin25'; 'WM_kax_bin26'; 'WM_kax_bin27'; 'WM_kax_bin28'; 'WM_kax_bin29'; 'WM_kax_bin30'; 'WM_kax_bin31'; 'WM_kax_bin32'; 'WM_kax_bin33'; 'WM_kax_bin34'; 'WM_kax_bin35'; 'WM_kax_bin36'; 'WM_kax_bin37'; 'WM_kax_bin38'; 'WM_kax_bin39'; 'WM_kax_bin40'; 'WM_kax_bin41'; 'WM_kax_bin42'; 'WM_kax_bin43'; 'WM_kax_bin44'; 'WM_kax_bin45'; 'WM_kax_bin46'; 'WM_kax_bin47'; 'WM_kax_bin48'; 'WM_kax_bin49'; 'WM_kax_bin50'; 'WM_kax_bin51'; 'WM_kax_bin52'; 'WM_kax_bin53'; 'WM_kax_bin54'; 'WM_kax_bin55'; 'WM_kax_bin56'; 'WM_kax_bin57'; 'WM_kax_bin58'; 'WM_kax_bin59'; 'WM_kax_bin60'; 'WM_kax_bin61'; 'WM_kax_bin62'; 'WM_kax_bin63'; 'WM_kax_bin64'];
        orig_txt_kax_WM = fullfile(base_folder, ['kax_filled_WM_095_masked_total_frequency.txt']); 
        kax_WM = readtable(orig_txt_kax_WM);
        kax_WM.BinLabel = [bin_label];
        kax_WM = kax_WM(:,[1 150 2:149]);
        kax_WM.BinStart = [];
        kax_WM_transp = rows2vars(kax_WM,'VariableNamesSource','BinLabel');
        kax_WM_transp.OriginalVariableNames = [];
        
        % WM krad
        bin_label = ['WM_krad_bin01'; 'WM_krad_bin02'; 'WM_krad_bin03'; 'WM_krad_bin04'; 'WM_krad_bin05'; 'WM_krad_bin06'; 'WM_krad_bin07'; 'WM_krad_bin08'; 'WM_krad_bin09'; 'WM_krad_bin10'; 'WM_krad_bin11'; 'WM_krad_bin12'; 'WM_krad_bin13'; 'WM_krad_bin14'; 'WM_krad_bin15'; 'WM_krad_bin16'; 'WM_krad_bin17'; 'WM_krad_bin18'; 'WM_krad_bin19'; 'WM_krad_bin20'; 'WM_krad_bin21'; 'WM_krad_bin22'; 'WM_krad_bin23'; 'WM_krad_bin24'; 'WM_krad_bin25'; 'WM_krad_bin26'; 'WM_krad_bin27'; 'WM_krad_bin28'; 'WM_krad_bin29'; 'WM_krad_bin30'; 'WM_krad_bin31'; 'WM_krad_bin32'; 'WM_krad_bin33'; 'WM_krad_bin34'; 'WM_krad_bin35'; 'WM_krad_bin36'; 'WM_krad_bin37'; 'WM_krad_bin38'; 'WM_krad_bin39'; 'WM_krad_bin40'; 'WM_krad_bin41'; 'WM_krad_bin42'; 'WM_krad_bin43'; 'WM_krad_bin44'; 'WM_krad_bin45'; 'WM_krad_bin46'; 'WM_krad_bin47'; 'WM_krad_bin48'; 'WM_krad_bin49'; 'WM_krad_bin50'; 'WM_krad_bin51'; 'WM_krad_bin52'; 'WM_krad_bin53'; 'WM_krad_bin54'; 'WM_krad_bin55'; 'WM_krad_bin56'; 'WM_krad_bin57'; 'WM_krad_bin58'; 'WM_krad_bin59'; 'WM_krad_bin60'; 'WM_krad_bin61'; 'WM_krad_bin62'; 'WM_krad_bin63'; 'WM_krad_bin64'];
        orig_txt_krad_WM = fullfile(base_folder, ['krad_filled_WM_095_masked_total_frequency.txt']); 
        krad_WM = readtable(orig_txt_krad_WM);
        krad_WM.BinLabel = [bin_label];
        krad_WM = krad_WM(:,[1 150 2:149]);
        krad_WM.BinStart = [];
        krad_WM_transp = rows2vars(krad_WM,'VariableNamesSource','BinLabel');
        krad_WM_transp.OriginalVariableNames = [];
        
        % WM wmm_awf
        bin_label = ['WM_wmm_awf_bin01'; 'WM_wmm_awf_bin02'; 'WM_wmm_awf_bin03'; 'WM_wmm_awf_bin04'; 'WM_wmm_awf_bin05'; 'WM_wmm_awf_bin06'; 'WM_wmm_awf_bin07'; 'WM_wmm_awf_bin08'; 'WM_wmm_awf_bin09'; 'WM_wmm_awf_bin10'; 'WM_wmm_awf_bin11'; 'WM_wmm_awf_bin12'; 'WM_wmm_awf_bin13'; 'WM_wmm_awf_bin14'; 'WM_wmm_awf_bin15'; 'WM_wmm_awf_bin16'; 'WM_wmm_awf_bin17'; 'WM_wmm_awf_bin18'; 'WM_wmm_awf_bin19'; 'WM_wmm_awf_bin20'; 'WM_wmm_awf_bin21'; 'WM_wmm_awf_bin22'; 'WM_wmm_awf_bin23'; 'WM_wmm_awf_bin24'; 'WM_wmm_awf_bin25'; 'WM_wmm_awf_bin26'; 'WM_wmm_awf_bin27'; 'WM_wmm_awf_bin28'; 'WM_wmm_awf_bin29'; 'WM_wmm_awf_bin30'; 'WM_wmm_awf_bin31'; 'WM_wmm_awf_bin32'; 'WM_wmm_awf_bin33'; 'WM_wmm_awf_bin34'; 'WM_wmm_awf_bin35'; 'WM_wmm_awf_bin36'; 'WM_wmm_awf_bin37'; 'WM_wmm_awf_bin38'; 'WM_wmm_awf_bin39'; 'WM_wmm_awf_bin40'; 'WM_wmm_awf_bin41'; 'WM_wmm_awf_bin42'; 'WM_wmm_awf_bin43'; 'WM_wmm_awf_bin44'; 'WM_wmm_awf_bin45'; 'WM_wmm_awf_bin46'; 'WM_wmm_awf_bin47'; 'WM_wmm_awf_bin48'; 'WM_wmm_awf_bin49'; 'WM_wmm_awf_bin50'; 'WM_wmm_awf_bin51'; 'WM_wmm_awf_bin52'; 'WM_wmm_awf_bin53'; 'WM_wmm_awf_bin54'; 'WM_wmm_awf_bin55'; 'WM_wmm_awf_bin56'; 'WM_wmm_awf_bin57'; 'WM_wmm_awf_bin58'; 'WM_wmm_awf_bin59'; 'WM_wmm_awf_bin60'; 'WM_wmm_awf_bin61'; 'WM_wmm_awf_bin62'; 'WM_wmm_awf_bin63'; 'WM_wmm_awf_bin64'];
        orig_txt_wmm_awf_WM = fullfile(base_folder, ['wmm_awf_filled_WM_095_masked_total_frequency.txt']); 
        wmm_awf_WM = readtable(orig_txt_wmm_awf_WM);
        wmm_awf_WM.BinLabel = [bin_label];
        wmm_awf_WM = wmm_awf_WM(:,[1 150 2:149]);
        wmm_awf_WM.BinStart = [];
        wmm_awf_WM_transp = rows2vars(wmm_awf_WM,'VariableNamesSource','BinLabel');
        wmm_awf_WM_transp.OriginalVariableNames = [];
        
        % WM wmm_da
        bin_label = ['WM_wmm_da_bin01'; 'WM_wmm_da_bin02'; 'WM_wmm_da_bin03'; 'WM_wmm_da_bin04'; 'WM_wmm_da_bin05'; 'WM_wmm_da_bin06'; 'WM_wmm_da_bin07'; 'WM_wmm_da_bin08'; 'WM_wmm_da_bin09'; 'WM_wmm_da_bin10'; 'WM_wmm_da_bin11'; 'WM_wmm_da_bin12'; 'WM_wmm_da_bin13'; 'WM_wmm_da_bin14'; 'WM_wmm_da_bin15'; 'WM_wmm_da_bin16'; 'WM_wmm_da_bin17'; 'WM_wmm_da_bin18'; 'WM_wmm_da_bin19'; 'WM_wmm_da_bin20'; 'WM_wmm_da_bin21'; 'WM_wmm_da_bin22'; 'WM_wmm_da_bin23'; 'WM_wmm_da_bin24'; 'WM_wmm_da_bin25'; 'WM_wmm_da_bin26'; 'WM_wmm_da_bin27'; 'WM_wmm_da_bin28'; 'WM_wmm_da_bin29'; 'WM_wmm_da_bin30'; 'WM_wmm_da_bin31'; 'WM_wmm_da_bin32'; 'WM_wmm_da_bin33'; 'WM_wmm_da_bin34'; 'WM_wmm_da_bin35'; 'WM_wmm_da_bin36'; 'WM_wmm_da_bin37'; 'WM_wmm_da_bin38'; 'WM_wmm_da_bin39'; 'WM_wmm_da_bin40'; 'WM_wmm_da_bin41'; 'WM_wmm_da_bin42'; 'WM_wmm_da_bin43'; 'WM_wmm_da_bin44'; 'WM_wmm_da_bin45'; 'WM_wmm_da_bin46'; 'WM_wmm_da_bin47'; 'WM_wmm_da_bin48'; 'WM_wmm_da_bin49'; 'WM_wmm_da_bin50'; 'WM_wmm_da_bin51'; 'WM_wmm_da_bin52'; 'WM_wmm_da_bin53'; 'WM_wmm_da_bin54'; 'WM_wmm_da_bin55'; 'WM_wmm_da_bin56'; 'WM_wmm_da_bin57'; 'WM_wmm_da_bin58'; 'WM_wmm_da_bin59'; 'WM_wmm_da_bin60'; 'WM_wmm_da_bin61'; 'WM_wmm_da_bin62'; 'WM_wmm_da_bin63'; 'WM_wmm_da_bin64'];
        orig_txt_wmm_da_WM = fullfile(base_folder, ['wmm_da_filled_WM_095_masked_total_frequency.txt']); 
        wmm_da_WM = readtable(orig_txt_wmm_da_WM);
        wmm_da_WM.BinLabel = [bin_label];
        wmm_da_WM = wmm_da_WM(:,[1 150 2:149]);
        wmm_da_WM.BinStart = [];
        wmm_da_WM_transp = rows2vars(wmm_da_WM,'VariableNamesSource','BinLabel');
        wmm_da_WM_transp.OriginalVariableNames = [];
        
        % WM wmm_de_ax
        bin_label = ['WM_wmm_de_ax_bin01'; 'WM_wmm_de_ax_bin02'; 'WM_wmm_de_ax_bin03'; 'WM_wmm_de_ax_bin04'; 'WM_wmm_de_ax_bin05'; 'WM_wmm_de_ax_bin06'; 'WM_wmm_de_ax_bin07'; 'WM_wmm_de_ax_bin08'; 'WM_wmm_de_ax_bin09'; 'WM_wmm_de_ax_bin10'; 'WM_wmm_de_ax_bin11'; 'WM_wmm_de_ax_bin12'; 'WM_wmm_de_ax_bin13'; 'WM_wmm_de_ax_bin14'; 'WM_wmm_de_ax_bin15'; 'WM_wmm_de_ax_bin16'; 'WM_wmm_de_ax_bin17'; 'WM_wmm_de_ax_bin18'; 'WM_wmm_de_ax_bin19'; 'WM_wmm_de_ax_bin20'; 'WM_wmm_de_ax_bin21'; 'WM_wmm_de_ax_bin22'; 'WM_wmm_de_ax_bin23'; 'WM_wmm_de_ax_bin24'; 'WM_wmm_de_ax_bin25'; 'WM_wmm_de_ax_bin26'; 'WM_wmm_de_ax_bin27'; 'WM_wmm_de_ax_bin28'; 'WM_wmm_de_ax_bin29'; 'WM_wmm_de_ax_bin30'; 'WM_wmm_de_ax_bin31'; 'WM_wmm_de_ax_bin32'; 'WM_wmm_de_ax_bin33'; 'WM_wmm_de_ax_bin34'; 'WM_wmm_de_ax_bin35'; 'WM_wmm_de_ax_bin36'; 'WM_wmm_de_ax_bin37'; 'WM_wmm_de_ax_bin38'; 'WM_wmm_de_ax_bin39'; 'WM_wmm_de_ax_bin40'; 'WM_wmm_de_ax_bin41'; 'WM_wmm_de_ax_bin42'; 'WM_wmm_de_ax_bin43'; 'WM_wmm_de_ax_bin44'; 'WM_wmm_de_ax_bin45'; 'WM_wmm_de_ax_bin46'; 'WM_wmm_de_ax_bin47'; 'WM_wmm_de_ax_bin48'; 'WM_wmm_de_ax_bin49'; 'WM_wmm_de_ax_bin50'; 'WM_wmm_de_ax_bin51'; 'WM_wmm_de_ax_bin52'; 'WM_wmm_de_ax_bin53'; 'WM_wmm_de_ax_bin54'; 'WM_wmm_de_ax_bin55'; 'WM_wmm_de_ax_bin56'; 'WM_wmm_de_ax_bin57'; 'WM_wmm_de_ax_bin58'; 'WM_wmm_de_ax_bin59'; 'WM_wmm_de_ax_bin60'; 'WM_wmm_de_ax_bin61'; 'WM_wmm_de_ax_bin62'; 'WM_wmm_de_ax_bin63'; 'WM_wmm_de_ax_bin64'];
        orig_txt_wmm_de_ax_WM = fullfile(base_folder, ['wmm_de_ax_filled_WM_095_masked_total_frequency.txt']); 
        wmm_de_ax_WM = readtable(orig_txt_wmm_de_ax_WM);
        wmm_de_ax_WM.BinLabel = [bin_label];
        wmm_de_ax_WM = wmm_de_ax_WM(:,[1 150 2:149]);
        wmm_de_ax_WM.BinStart = [];
        wmm_de_ax_WM_transp = rows2vars(wmm_de_ax_WM,'VariableNamesSource','BinLabel');
        wmm_de_ax_WM_transp.OriginalVariableNames = [];
        
        % WM wmm_de_rad
        bin_label = ['WM_wmm_de_rad_bin01'; 'WM_wmm_de_rad_bin02'; 'WM_wmm_de_rad_bin03'; 'WM_wmm_de_rad_bin04'; 'WM_wmm_de_rad_bin05'; 'WM_wmm_de_rad_bin06'; 'WM_wmm_de_rad_bin07'; 'WM_wmm_de_rad_bin08'; 'WM_wmm_de_rad_bin09'; 'WM_wmm_de_rad_bin10'; 'WM_wmm_de_rad_bin11'; 'WM_wmm_de_rad_bin12'; 'WM_wmm_de_rad_bin13'; 'WM_wmm_de_rad_bin14'; 'WM_wmm_de_rad_bin15'; 'WM_wmm_de_rad_bin16'; 'WM_wmm_de_rad_bin17'; 'WM_wmm_de_rad_bin18'; 'WM_wmm_de_rad_bin19'; 'WM_wmm_de_rad_bin20'; 'WM_wmm_de_rad_bin21'; 'WM_wmm_de_rad_bin22'; 'WM_wmm_de_rad_bin23'; 'WM_wmm_de_rad_bin24'; 'WM_wmm_de_rad_bin25'; 'WM_wmm_de_rad_bin26'; 'WM_wmm_de_rad_bin27'; 'WM_wmm_de_rad_bin28'; 'WM_wmm_de_rad_bin29'; 'WM_wmm_de_rad_bin30'; 'WM_wmm_de_rad_bin31'; 'WM_wmm_de_rad_bin32'; 'WM_wmm_de_rad_bin33'; 'WM_wmm_de_rad_bin34'; 'WM_wmm_de_rad_bin35'; 'WM_wmm_de_rad_bin36'; 'WM_wmm_de_rad_bin37'; 'WM_wmm_de_rad_bin38'; 'WM_wmm_de_rad_bin39'; 'WM_wmm_de_rad_bin40'; 'WM_wmm_de_rad_bin41'; 'WM_wmm_de_rad_bin42'; 'WM_wmm_de_rad_bin43'; 'WM_wmm_de_rad_bin44'; 'WM_wmm_de_rad_bin45'; 'WM_wmm_de_rad_bin46'; 'WM_wmm_de_rad_bin47'; 'WM_wmm_de_rad_bin48'; 'WM_wmm_de_rad_bin49'; 'WM_wmm_de_rad_bin50'; 'WM_wmm_de_rad_bin51'; 'WM_wmm_de_rad_bin52'; 'WM_wmm_de_rad_bin53'; 'WM_wmm_de_rad_bin54'; 'WM_wmm_de_rad_bin55'; 'WM_wmm_de_rad_bin56'; 'WM_wmm_de_rad_bin57'; 'WM_wmm_de_rad_bin58'; 'WM_wmm_de_rad_bin59'; 'WM_wmm_de_rad_bin60'; 'WM_wmm_de_rad_bin61'; 'WM_wmm_de_rad_bin62'; 'WM_wmm_de_rad_bin63'; 'WM_wmm_de_rad_bin64'];
        orig_txt_wmm_de_rad_WM = fullfile(base_folder, ['wmm_de_rad_filled_WM_095_masked_total_frequency.txt']); 
        wmm_de_rad_WM = readtable(orig_txt_wmm_de_rad_WM);
        wmm_de_rad_WM.BinLabel = [bin_label];
        wmm_de_rad_WM = wmm_de_rad_WM(:,[1 150 2:149]);
        wmm_de_rad_WM.BinStart = [];
        wmm_de_rad_WM_transp = rows2vars(wmm_de_rad_WM,'VariableNamesSource','BinLabel');
        wmm_de_rad_WM_transp.OriginalVariableNames = [];
        
        % WM wmm_tort
        bin_label = ['WM_wmm_tort_bin01'; 'WM_wmm_tort_bin02'; 'WM_wmm_tort_bin03'; 'WM_wmm_tort_bin04'; 'WM_wmm_tort_bin05'; 'WM_wmm_tort_bin06'; 'WM_wmm_tort_bin07'; 'WM_wmm_tort_bin08'; 'WM_wmm_tort_bin09'; 'WM_wmm_tort_bin10'; 'WM_wmm_tort_bin11'; 'WM_wmm_tort_bin12'; 'WM_wmm_tort_bin13'; 'WM_wmm_tort_bin14'; 'WM_wmm_tort_bin15'; 'WM_wmm_tort_bin16'; 'WM_wmm_tort_bin17'; 'WM_wmm_tort_bin18'; 'WM_wmm_tort_bin19'; 'WM_wmm_tort_bin20'; 'WM_wmm_tort_bin21'; 'WM_wmm_tort_bin22'; 'WM_wmm_tort_bin23'; 'WM_wmm_tort_bin24'; 'WM_wmm_tort_bin25'; 'WM_wmm_tort_bin26'; 'WM_wmm_tort_bin27'; 'WM_wmm_tort_bin28'; 'WM_wmm_tort_bin29'; 'WM_wmm_tort_bin30'; 'WM_wmm_tort_bin31'; 'WM_wmm_tort_bin32'; 'WM_wmm_tort_bin33'; 'WM_wmm_tort_bin34'; 'WM_wmm_tort_bin35'; 'WM_wmm_tort_bin36'; 'WM_wmm_tort_bin37'; 'WM_wmm_tort_bin38'; 'WM_wmm_tort_bin39'; 'WM_wmm_tort_bin40'; 'WM_wmm_tort_bin41'; 'WM_wmm_tort_bin42'; 'WM_wmm_tort_bin43'; 'WM_wmm_tort_bin44'; 'WM_wmm_tort_bin45'; 'WM_wmm_tort_bin46'; 'WM_wmm_tort_bin47'; 'WM_wmm_tort_bin48'; 'WM_wmm_tort_bin49'; 'WM_wmm_tort_bin50'; 'WM_wmm_tort_bin51'; 'WM_wmm_tort_bin52'; 'WM_wmm_tort_bin53'; 'WM_wmm_tort_bin54'; 'WM_wmm_tort_bin55'; 'WM_wmm_tort_bin56'; 'WM_wmm_tort_bin57'; 'WM_wmm_tort_bin58'; 'WM_wmm_tort_bin59'; 'WM_wmm_tort_bin60'; 'WM_wmm_tort_bin61'; 'WM_wmm_tort_bin62'; 'WM_wmm_tort_bin63'; 'WM_wmm_tort_bin64'];
        orig_txt_wmm_tort_WM = fullfile(base_folder, ['wmm_tort_filled_WM_095_masked_total_frequency.txt']); 
        wmm_tort_WM = readtable(orig_txt_wmm_tort_WM);
        wmm_tort_WM.BinLabel = [bin_label];
        wmm_tort_WM = wmm_tort_WM(:,[1 150 2:149]);
        wmm_tort_WM.BinStart = [];
        wmm_tort_WM_transp = rows2vars(wmm_tort_WM,'VariableNamesSource','BinLabel');
        wmm_tort_WM_transp.OriginalVariableNames = [];
        
    %Combine tables and write to Excel
        comb_table = [dmean_GM_transp dax_GM_transp drad_GM_transp FA_GM_transp kax_GM_transp krad_GM_transp kmean_GM_transp wmm_awf_GM_transp wmm_da_GM_transp wmm_de_ax_GM_transp wmm_de_rad_GM_transp wmm_tort_GM_transp dmean_WM_transp dax_WM_transp drad_WM_transp FA_WM_transp kax_WM_transp krad_WM_transp kmean_WM_transp wmm_awf_WM_transp wmm_da_WM_transp wmm_de_ax_WM_transp wmm_de_rad_WM_transp wmm_tort_WM_transp];
%         comb_table = [dmean_GM_transp dax_GM_transp drad_GM_transp FA_GM_transp kax_GM_transp krad_GM_transp kmean_GM_transp dmean_WM_transp dax_WM_transp drad_WM_transp FA_WM_transp kax_WM_transp krad_WM_transp kmean_WM_transp];
%         comb_table = [dmean_GM_transp dax_GM_transp drad_GM_transp FA_GM_transp kax_GM_transp krad_GM_transp kmean_GM_transp];
        comb_table.Properties.VariableNames{'OriginalVariableNames'} = 'Subject';
        excel_file = 'All_Bin_Frequencies.xlsx';
        writetable(comb_table,[base_folder, excel_file]);
    
    %Delete copies of tables    
for i = 1:length(roi_list)
    for j = 1:length(metric_list)
        
        %read in tables
        delete(fullfile(base_folder, [metric_list{j} '_' roi_list{i} '_total_frequency.txt']));
        
    end
end

toc; 