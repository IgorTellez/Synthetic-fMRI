import nibabel as nib
import numpy as np
import sys




# Paths from the Bash script
input_nifti_path = sys.argv[1]
output_nifti_path = sys.argv[2]
version_number = sys.argv[3]
noise_amp = sys.argv[4]


# input_nifti_path = "/fast/project/PG_Niendorf_fmri/fmri/pipeHMR/projects/H01/fMRI_Igor/fMRIsim/HomoTempNoise/initialBOLD/6_bold.nii.gz"
# output_nifti_path = "/fast/project/PG_Niendorf_fmri/fmri/pipeHMR/projects/H01/fMRI_Igor/fMRIsim/GaussianTS/AR_tests"
# version_number = "7"

# Load the input BOLD NIfTI file
bold_nii = nib.load(input_nifti_path)
bold_data = bold_nii.get_fdata()
noise_amp_value = float(noise_amp)

# Create Gaussian noise
gaussian_noise = np.random.normal(0, 1, bold_data.shape)
gaussian_noise_amp = gaussian_noise * noise_amp_value
# gaussian_noise_20std = gaussian_noise_10std * 2
# gaussian_noise_40std = gaussian_noise_10std * 4

# Add Gaussian noise to BOLD data
bold_data_with_gaussian_noise = bold_data + gaussian_noise_amp
# bold_data_with_gaussian_noise_10std = bold_data + gaussian_noise_10std
# bold_data_with_gaussian_noise_20std = bold_data + gaussian_noise_20std
# bold_data_with_gaussian_noise_40std = bold_data + gaussian_noise_40std

# Create a new NIfTI image
new_img = nib.Nifti1Image(bold_data_with_gaussian_noise, bold_nii.affine, bold_nii.header)
# new_img_10std = nib.Nifti1Image(bold_data_with_gaussian_noise_10std, bold_nii.affine, bold_nii.header)
# new_img_20std = nib.Nifti1Image(bold_data_with_gaussian_noise_20std, bold_nii.affine, bold_nii.header)
# new_img_40std = nib.Nifti1Image(bold_data_with_gaussian_noise_40std, bold_nii.affine, bold_nii.header)

# Create names outputs
output_nifti_path_file = output_nifti_path + "/bold.g." + version_number + ".x" + noise_amp + ".nii"
# output_nifti_path_10std = output_nifti_path + "/g." + version_number + ".x10.nii"
# output_nifti_path_20std = output_nifti_path + "/g." + version_number + ".x20.nii"
# output_nifti_path_40std = output_nifti_path + "/g." + version_number + ".x40.nii"


# Write the output NIfTI file
nib.save(new_img, output_nifti_path_file)
# nib.save(new_img_10std, output_nifti_path_10std)
# nib.save(new_img_20std, output_nifti_path_20std)
# nib.save(new_img_40std, output_nifti_path_40std)
