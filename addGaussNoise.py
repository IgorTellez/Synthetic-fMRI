import nibabel as nib
import numpy as np
import sys




# Paths from the Bash script
input_nifti_path = sys.argv[1]
output_nifti_path = sys.argv[2]
version_number = sys.argv[3]
noise_amp = sys.argv[4]


# Load the input BOLD NIfTI file
bold_nii = nib.load(input_nifti_path)
bold_data = bold_nii.get_fdata()
noise_amp_value = float(noise_amp)

# Create Gaussian noise
gaussian_noise = np.random.normal(0, 1, bold_data.shape)
gaussian_noise_amp = gaussian_noise * noise_amp_value

# Add Gaussian noise to BOLD data
bold_data_with_gaussian_noise = bold_data + gaussian_noise_amp

# Create a new NIfTI image
new_img = nib.Nifti1Image(bold_data_with_gaussian_noise, bold_nii.affine, bold_nii.header)

# Create names outputs
output_nifti_path_file = output_nifti_path + "/bold.g." + version_number + ".x" + noise_amp + ".nii"

# Write the output NIfTI file
nib.save(new_img, output_nifti_path_file)

