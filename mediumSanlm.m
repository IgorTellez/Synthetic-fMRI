function mediumSanlm(files2process)

addpath /fast/project/PG_Niendorf_fmri/applications/spm12
% cd cd /fast/project/PG_Niendorf_fmri/fmri/pipeHMR/projects/H01/fMRI_Igor/fMRIsim/Magnitude/fBOLD/sanlm/noiseLevels/gaussian/bold_gauss.x3.75
pwd
cd(files2process)
pwd

a = dir('bold*.nii');
%a = dir('*.nii');
b = struct2cell(a);
c = b(1,:);
c2 = string(pwd);
d = strcat(c2,'/',c,',1');
%e = string(d);
files = {d};
e = cellstr(files{1,1});
filesArr= e';
% filesArr;
% whos filesArr



matlabbatch{1}.spm.tools.cat.tools.sanlm.data = filesArr;
matlabbatch{1}.spm.tools.cat.tools.sanlm.spm_type = 16;
matlabbatch{1}.spm.tools.cat.tools.sanlm.prefix = 'medium_';
matlabbatch{1}.spm.tools.cat.tools.sanlm.suffix = '';
matlabbatch{1}.spm.tools.cat.tools.sanlm.intlim = 100;
matlabbatch{1}.spm.tools.cat.tools.sanlm.addnoise = 0.5;
matlabbatch{1}.spm.tools.cat.tools.sanlm.rician = 0;
matlabbatch{1}.spm.tools.cat.tools.sanlm.replaceNANandINF = 1;
matlabbatch{1}.spm.tools.cat.tools.sanlm.nlmfilter.optimized.NCstr = -Inf;


spm('defaults','FMRI')
spm_jobman('initcfg');
spm_jobman('run',matlabbatch);
exit

end

