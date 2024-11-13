#!/bin/bash

#$ -m ea
#$ -cwd
#$ -j Y
#$ -V
#$ -l m_mem_free=40G
#$ -pe smp 4

set -x

variant=$1
# for magnitude in 05 1 2 3 4 5 6; do
magnitude=$2
noiseAmp=$3

# Set initial paths
noiseType=gaussian
initialPath=/fast/project/PG_Niendorf_fmri/fmri/pipeHMR/projects/H01/fMRI_Igor/fMRIsim/extraTS
boldPath=$initialPath/fBOLD/$noiseType/$magnitude
derivativesPath=$initialPath/derivatives/$noiseType/$magnitude
sanlmPath=$initialPath/fBOLD/sanlm/$noiseType/$magnitude
activationFile=/fast/project/PG_Niendorf_fmri/fmri/pipeHMR/projects/H01/fMRI_Igor/fMRIsim/DoubleGamma/activationTimesCorrect.txt
fsf=/fast/project/PG_Niendorf_fmri/fmri/pipeHMR/projects/H01/fMRI_Igor/fMRIsim/DoubleGamma/code
pythonPath=/fast/project/PG_Niendorf_fmri/applications/anaconda3/bin/python
codePath=/fast/project/PG_Niendorf_fmri/fmri/pipeHMR/projects/H01/fMRI_Igor/fMRIsim/DoubleGamma/code

# Make directories
mkdir -p $boldPath
mkdir -p $derivativesPath
mkdir -p $sanlmPath

# Create the BOLD + Gaussian noise data
boldFileName=bold.g.${variant}.x${noiseAmp}

input_nifti_path=$initialPath/initialBOLD/${magnitude}_bold.nii.gz
$pythonPath $codePath/addGaussNoise.py "$input_nifti_path" "$boldPath" "$variant" "$noiseAmp"


# for noiseAmp in 10 20 40

# # Gaussian Filter
3dmerge -1blur_fwhm 1.5 -doall -prefix ${boldPath}/${boldFileName}_S1.0.nii ${boldPath}/${boldFileName}.nii 
3dmerge -1blur_fwhm 2.25 -doall -prefix ${boldPath}/${boldFileName}_S1.5.nii ${boldPath}/${boldFileName}.nii 
3dmerge -1blur_fwhm 3.75 -doall -prefix ${boldPath}/${boldFileName}_S2.5.nii ${boldPath}/${boldFileName}.nii 

echo "Done gaussian filtering"



# ##########################################################################################################
# Run FSL FEAT
nameWOext=$boldFileName
cp $fsf/feat.fsf ${derivativesPath}/${nameWOext}.fsf
sed -i "s|DIRECTORIOOUT|${derivativesPath}/${nameWOext}|g" "${derivativesPath}/${nameWOext}.fsf"
sed -i "s|ARCHIVOIN|${boldPath}/${boldFileName}|g" "${derivativesPath}/${nameWOext}.fsf"
sed -i "s|ACTIVACIONESTIEMPO|${activationFile}|g" "${derivativesPath}/${nameWOext}.fsf"
feat ${derivativesPath}/${nameWOext}.fsf
echo "Done Launching FEAT unfiltered analyses"

# RunFEAT for Gaussian filtered
for filtType in 1.0 1.5 2.5; do
    nameWOext=${boldFileName}_S${filtType}
    cp $fsf/feat.fsf ${derivativesPath}/${nameWOext}.fsf
    sed -i "s|DIRECTORIOOUT|${derivativesPath}/${nameWOext}|g" "${derivativesPath}/${nameWOext}.fsf"
    sed -i "s|ARCHIVOIN|${boldPath}/${nameWOext}|g" "${derivativesPath}/${nameWOext}.fsf"
    sed -i "s|ACTIVACIONESTIEMPO|${activationFile}|g" "${derivativesPath}/${nameWOext}.fsf"
    feat ${derivativesPath}/${nameWOext}.fsf
    echo "Done Launching FEAT unfiltered analyses"
done

# Prepare datasets (separate) for SANLM filter
mkdir -p $sanlmPath/$boldFileName
fslsplit ${boldPath}/${boldFileName}.nii $sanlmPath/$boldFileName/${boldFileName}_ -t
gunzip $sanlmPath/$boldFileName/*.gz

# SANLM Filter - medium
folder3Dpath=$sanlmPath/$boldFileName
echo "Folder with the 3D volumes: " $folder3Dpath
# fileName=${folder3Dpath##*/}

cd /fast/project/PG_Niendorf_fmri/fmri/pipeHMR/projects/H01/fMRI_Igor/fMRIsim/DoubleGamma/code
matlab -nodesktop -nosplash -r "mediumSanlm('$folder3Dpath')"
fslmerge -t ${boldPath}/${boldFileName}_medium.nii.gz ${folder3Dpath}/medium_*.nii

echo "The files that will be merged: " ${folder3Dpath}"/medium_*"
echo "The derivativesPath filter file will be:  ${boldPath}/${boldFileName}_medium.nii"

fileNameFilt=${boldPath}/${boldFileName}_medium.nii.gz
echo "Path with the file and extension: " $fileNameFilt
pathFileWOext=${fileNameFilt%.nii*}
echo "Path with file without extension: " $pathFileWOext
nameWOext=${pathFileWOext##*/}
echo "File without extension: " $nameWOext
# ################################################
cp $fsf/feat.fsf ${derivativesPath}/${nameWOext}.fsf
sed -i "s|DIRECTORIOOUT|${derivativesPath}/${nameWOext}|g" "${derivativesPath}/${nameWOext}.fsf"
sed -i "s|ARCHIVOIN|${pathFileWOext}|g" "${derivativesPath}/${nameWOext}.fsf"
sed -i "s|ACTIVACIONESTIEMPO|${activationFile}|g" "${derivativesPath}/${nameWOext}.fsf"

feat ${derivativesPath}/${nameWOext}.fsf
echo "Done SANLM medium filtering"

# SANLM Filter - light
# folder3Dpath=$boldPath/sanlm/g.$variant
# fileName=${folder3Dpath##*/}
cd /fast/project/PG_Niendorf_fmri/fmri/pipeHMR/projects/H01/fMRI_Igor/fMRIsim/DoubleGamma/code
matlab -nodesktop -nosplash -r "lightSanlm('$folder3Dpath')"
fileNameFilt=${boldPath}/${boldFileName}_light.nii.gz
fslmerge -t $fileNameFilt ${folder3Dpath}/light_*.nii
pathFileWOext=${fileNameFilt%.nii*}
nameWOext=${pathFileWOext##*/}
echo "File without extension: " $nameWOext
# ################################################
cp $fsf/feat.fsf ${derivativesPath}/${nameWOext}.fsf
sed -i "s|DIRECTORIOOUT|${derivativesPath}/${nameWOext}|g" "${derivativesPath}/${nameWOext}.fsf"
sed -i "s|ARCHIVOIN|${pathFileWOext}|g" "${derivativesPath}/${nameWOext}.fsf"
sed -i "s|ACTIVACIONESTIEMPO|${activationFile}|g" "${derivativesPath}/${nameWOext}.fsf"

feat ${derivativesPath}/${nameWOext}.fsf
echo "Done SANLM light filtering"

# SANLM Filter - strong
# folder3Dpath=$boldPath/sanlm/g.$variant
# fileName=${folder3Dpath##*/}
cd /fast/project/PG_Niendorf_fmri/fmri/pipeHMR/projects/H01/fMRI_Igor/fMRIsim/DoubleGamma/code
matlab -nodesktop -nosplash -r "strongSanlm('$folder3Dpath')"
fileNameFilt=${boldPath}/${boldFileName}_strong.nii.gz
fslmerge -t $fileNameFilt ${folder3Dpath}/strong_*.nii
pathFileWOext=${fileNameFilt%.nii*}
nameWOext=${pathFileWOext##*/}
echo "File without extension: " $nameWOext
# ################################################
cp $fsf/feat.fsf ${derivativesPath}/${nameWOext}.fsf
sed -i "s|DIRECTORIOOUT|${derivativesPath}/${nameWOext}|g" "${derivativesPath}/${nameWOext}.fsf"
sed -i "s|ARCHIVOIN|${pathFileWOext}|g" "${derivativesPath}/${nameWOext}.fsf"
sed -i "s|ACTIVACIONESTIEMPO|${activationFile}|g" "${derivativesPath}/${nameWOext}.fsf"

feat ${derivativesPath}/${nameWOext}.fsf

echo "Done SANLM strong filtering"

echo "Done everything"