function [binstart normfreq freq avg stddev vol] = map_histogram(fn_map, fn_mask_incl1, val_incl1, fn_mask_incl2, val_incl2, fn_mask_incl3, val_incl3, fn_img_excl, T_excl, fn_output, nbin, lolim, uplim, excl_nslice, excl_bin1, roi_QC)

%map_histogram  Create the histogram of voxel values of an image within a
%               volume-of-interest (VOI) and outside of a volume-of-
%               disinterest (VOD)
%               
%               Input images may be in NIfTI or Analyze format. Input files
%               with extension 'nii' are read as NIfTI and files with extension 
%               'hdr' are read as Analyze. Analyze files may be in IEEE big- or 
%               little-endian format.
%
%Syntax
%
%   [binstart normfreq avg stddev volume] = map_histogram(fn_img, fn_incl1, fn_incl2, fn_img_excl, T_excl, fn_output, nbin, lolim, uplim, excl_bin1, excl_nslice, visualize)
%
%Inputs
%   roi_QC      full path to ROI for QC
%
%   fn_img      Image (map) file name
%
%   fn_incl1    VOI 1 file name
%               Any voxel with a value other than zero is regarded as a VOI
%               voxel
%               This can be a cell array. In that case, the union of the
%               VOI's in the files will be used as the VOI.
%
%   fn_incl2    VOI 2 file name
%               Any voxel with a value other than zero is regarded as a VOI
%               voxel
%               Set fn_incl2 = '' (i.e., empty string) if it is not to be
%               used
%
%   fn_img_excl Image (map) from which to determine the VOD
%               Any voxel with a value greater than T_excl is excluded
%               Set fn_img_excl = '' (i.e., empty string) if it is not to be
%               used
%
%   T_excl      Threshold for creating a VOD
%               Voxels with values greater than T_excl in the image will be
%               excluded from histogram computation
%               If fn_img_incl = '', T_excl will be ignored
%
%   fn_output   Output file name where histogram data will be saved
%
%   nbin        Number of histogram bins
%
%   lolim       Histogram lower limit
%               Voxel values below this limit are counted in bin 1 of
%               histogram
%
%   uplim       Histogram upper limit
%               Voxel values above this limit are counted in bin nbin of
%               histogram
%
%   excl_bin1   (optional) (default = 1)
%               1: set the voxel counts in first bin to zero
%               Otherwise: Leave counts in first bin unchanged
%
%   excl_nslice (optional) (default = 0) 
%               Number of slices from the beginning and end of volumes (map
%               and mask) to exclude from histogram computation
%
%Outputs
%
%   binstart    nbin-by-1 vector specifying the start of histogram bins    
%
%   normfreq    nbin-by-1 vector containing normalized frequencies of the
%               histogram
%   
%   avg         average within the VOI and outside of VOD
%
%   stddev      standard deviation within the VOI and outside of VOD
%
%   volume      volume of the VOI in voxels
%
%
%Notes
%
%1. Supported data types for NIfTI images are unsigned char (8 bits/voxel),
%   signed short (16 bits/voxel), signed int (32 bits/voxel) and float (32
%   bits/voxel)
%
%2. Supported data types for Analyze images are unsigned char (8 bits/voxel),
%   signed short (16 bits/voxel), signed int (32 bits/voxel), float (32
%   bits/voxel), and 64-bit float (64 bits/voxel)

% Author: Ali Tabesh
% Last modified: 07/19/10
%Modified by Corinne McGill 2/21/18 to add line 

% read map

map_img = read_img(fn_map);
nslice = size(map_img, 3);

% read inclusion masks

mask_incl1_img = int16(read_img(fn_mask_incl1));           % mask_incl1_img
% if isscalar(val_incl1)
%     mask_incl1_img = mask_incl1_img == val_incl1;
% else
%     tmp = mask_incl1_img == val_incl1(1);
%     for i = 2:length(val_incl1)
%         tmp = tmp | (mask_incl1_img == val_incl1(i));
%     end
%     mask_incl1_img = tmp;
% end
    
if ~isempty(fn_mask_incl2)                          % mask_incl2_img
    mask_incl2_img = read_img(fn_mask_incl2);      
    mask_incl2_img = mask_incl2_img < val_incl2;
else
    mask_incl2_img = ones(size(mask_incl1_img));    % include everything
end

if ~isempty(fn_mask_incl3)                          % mask_incl3_img
    mask_incl3_img = read_img(fn_mask_incl3);      
    tmp_img = mask_incl3_img;
    mask_incl3_img = mask_incl3_img >= val_incl3;
else
    mask_incl3_img = ones(size(mask_incl1_img));    % include everything
end

% read exclusion image and determine exclusion mask

if ~isempty(fn_img_excl)                                          
    map_excl_img = read_img(fn_img_excl);
    mask_excl_img = map_excl_img > T_excl;
else
    mask_excl_img = zeros(size(mask_incl1_img));    % exclude nothing
end
    
% check map and mask dimensions

if any(size(map_img)~=size(mask_incl1_img)) || ...
        (~isempty(fn_mask_incl2) && any(size(map_img)~=size(mask_incl2_img))) || ...
        (~isempty(fn_mask_incl3) && any(size(map_img)~=size(mask_incl3_img))) || ...
        (~isempty(fn_img_excl) && any(size(map_img)~=size(mask_excl_img)))
    error('Map and mask(s) have different dimensions!')
end

% combine masks

mask_img = mask_incl1_img & mask_incl2_img & mask_incl3_img & (~mask_excl_img);

% exclude excl_nslice slices from the beginning and end of mask and volume

incl_slices = (1+excl_nslice):(nslice-excl_nslice);
mask_img = mask_img(:, :, incl_slices);
map_img = map_img(:, :, incl_slices);
nslice = nslice - 2*excl_nslice;

% exclude map voxels with zero values caused by registration or
% reconstruction from the mask

mask_img = mask_img & (map_img ~= 0);

% %% WRITE mask_img to QC
% hdr_roi = spm_vol(fn_mask_incl1);
% hdr_roi.fname = roi_QC
% spm_write_vol(hdr_roi,mask_img);
%%

% visualize map and mask images at slice s

s = 80;
%figure(1), imagesc(rot90(map_img(:,:,s))), title('Map'), axis equal, colormap gray
%figure(2), imagesc(rot90(mask_incl1_img(:,:,s))), title('FreeSurfer ROI'), axis equal, colormap gray
%figure(3), imagesc(rot90(tmp_img(:,:,s))), title('Sum of segmentation masks'), axis equal, colormap jet
%figure(3), imagesc(rot90(mask_incl2_img(:,:,s))), title('Outliers mask'), axis equal, colormap gray
%figure(4), imagesc(rot90(mask_incl3_img(:,:,s))), title('Consensus ROI'), axis equal, colormap gray
%figure(5), imagesc(rot90(mask_excl_img(:,:,s))), title('MD mask'), axis equal, colormap gray
%figure(6), imagesc(rot90(mask_img(:,:,s))), title('Final (intersection) mask'), axis equal, colormap gray
%pause

% find "on" voxels in mask and obtain histogram of map for those voxels
% for verbosity, we do this on a slice-by-slice basis (even though it's slower)

step = (uplim - lolim) / (nbin);
bincenters = (lolim + step/2):step:(uplim - step/2);
i = 1:nbin;  % bin indices
N = zeros(nbin, nslice);
for islice = 1:nslice
    mask_slice = mask_img(:, :, islice);
    map_slice = map_img(:, :, islice);
    N(:, islice) = (hist(map_slice(mask_slice(:) ~= 0), bincenters))';  % frequencies
    if excl_bin1
        N(1, islice) = 0;
    end
end

% open histogram file

[fid msg] = fopen(fn_output, 'w');
if fid == -1
    error([fn_output ': ' msg])
end

% write column headers

fprintf(fid, 'Bin number\tBin start\tTotal frequency\tNormalized frequency\t');
for islice = (1+excl_nslice):(nslice+excl_nslice-1)
    fprintf(fid, 'slice %d\t', islice);
end
fprintf(fid, 'slice %d\n', nslice+excl_nslice);

% write histogram

for ibin = 1:nbin
    normfreq(ibin) = sum(N(ibin, :)) / sum(N(:));
    binstart(ibin) = bincenters(ibin) - step/2;
    freq(ibin)=sum(N(ibin, :));
    fprintf(fid, '%d\t%f\t%f\t%f\t', [i(ibin); bincenters(ibin) - step/2; sum(N(ibin, :)); sum(N(ibin, :)) / sum(N(:))]);
    for islice = 1:(nslice-1)
        fprintf(fid, '%d\t', N(ibin, islice));
    end
    fprintf(fid, '%d\n', N(ibin, nslice));
end

% compute and write mean, std dev, and volume

avg = mean(map_img(mask_img(:) ~= 0));
stddev = std(map_img(mask_img(:) ~= 0));
vol = sum(mask_img(:) ~= 0);

fprintf(fid, '\n');
fprintf(fid, 'Mean:\t%f\n', avg);
fprintf(fid, 'Std dev:\t%f\n', stddev);
fprintf(fid, 'Volume:\t%f\n', vol);

fclose(fid);

% -------------------------------------------------------------------------
% function to read input image file (either nii or Analyze)
% -------------------------------------------------------------------------

function img = read_img(fn)

hdr = spm_vol(fn);         % read header
img = spm_read_vols(hdr);  % read image
