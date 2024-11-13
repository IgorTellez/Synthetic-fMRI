#!/bin/bash

#$ -m ea
#$ -cwd
#$ -j Y
#$ -V
#$ -l m_mem_free=20G
#$ -pe smp 4

set -x

subjects=$1
# for magnitude in 05 1 2 3 4 5 6; do
magnitude=$2

# create gaussian bold 30 files
gaussPath=/fast/project/PG_Niendorf_fmri/fmri/pipeHMR/projects/H01/fMRI_Igor/fMRIsim/GaussianTS/initialFiles
gaussianNoise=$gaussPath/gaussianNoise
gaussianNoiseAmp=$gaussPath/gaussianNoiseAmp
# finalBoldFiles=$gaussPath/finalBoldFiles
mkdir -p $fBOLD/unfiltered

# 



# cd /fast/project/PG_Niendorf_fmri/fmri/pipeHMR/projects/H01/fMRI_Igor/fMRIsim/GaussianTS/initialFiles/gaussianNoiseAmp

# magnitude=6
# Check for the mean value of the time series
boldMask=/fast/project/PG_Niendorf_fmri/fmri/pipeHMR/projects/H01/fMRI_Igor/fMRIsim/Hetero7/masks/allMasks1s.nii.gz
mainPath=/fast/project/PG_Niendorf_fmri/fmri/pipeHMR/projects/H01/fMRI_Igor/fMRIsim/GaussianTS


activationFile=/fast/project/PG_Niendorf_fmri/fmri/pipeHMR/projects/H01/fMRI_Igor/fMRIsim/DoubleGamma/activationTimesCorrect.txt
fsf=/fast/project/PG_Niendorf_fmri/fmri/pipeHMR/projects/H01/fMRI_Igor/fMRIsim/DoubleGamma/code


boldFile=$gaussPath/bold_3d.nii

# for boldFile in $finalBoldFiles/bold.gaussian*.${subjects}.nii.gz; do # change!!!

    meanVoxVal=`fslstats -K $boldMask $boldFile -M`
    meanVoxVal=`echo "$meanVoxVal" | cut -d ' ' -f 1`
    fslHRF=(0.016710655 0.038645927 0.032579089 0.015442549 0.0035609 -0.00247611 -0.004834287 -0.005017789 -0.004178698 -0.003169965 -0.002382191 -0.001894107 -0.001639511 -0.001522891 -0.001494287)
    hrfPeak=$(echo "scale=6; $meanVoxVal * 0.0$magnitude" | bc)
    mag=()
    for HRFvals in {0..23}; do
        # echo ${fslHRF[$HRFvals]}
        hrf1=$(echo "${fslHRF[$HRFvals]} * $hrfPeak" | bc)
        hrf2=$(echo "scale=6; $hrf1 / ${fslHRF[1]}" | bc)
        # echo $hrf2
        mag+=($hrf2)
    done

    outFiles=$mainPath/homogeneous/noises/bold/$magnitude/$subjects
    outPut=$mainPath/homogeneous/derivatives/$magnitude
    boldPath=$mainPath/homogeneous/fBOLD/$magnitude/unfiltered

    mkdir -p $outFiles
    mkdir -p $outFiles/hrfFiles
    mkdir -p $outFiles/simVolumes
    mkdir -p $boldPath/unfiltered
    cp -r $gaussPath/initialBOLDVols/. $outFiles/simVolumes
    # fslsplit ${boldFile} $outFiles/simVolumes/bold_ -t

    #  For new heterogeneous datasets: ${mag[$i]}

    vol=62
    for i in {0..23}; do
        fslmaths $boldMask -mul ${mag[$i]} $outFiles/hrfFiles/${i}gammacluster.nii   
        fslmaths $gaussPath/bold_3d.nii -add $outFiles/hrfFiles/${i}gammacluster.nii $outFiles/simVolumes/bold_0${vol}.nii
        vol=$((vol+1))
    done

    fslmaths $masks/clustersMask1s.nii.gz -mul ${mag[$i]} $outFiles/hrfFiles/${i}gammacluster.nii

    fslmaths $gaussPath/bold_3d.nii -add $outFiles/hrfFiles/${i}gammacluster.nii $outFiles/hrfFiles/${i}gammaBold.nii

    vol=137
    for i in {0..23}; do
        fslmaths $boldMask -mul ${mag[$i]} $outFiles/hrfFiles/${i}gammacluster.nii   
        fslmaths $gaussPath/bold_3d.nii -add $outFiles/hrfFiles/${i}gammacluster.nii $outFiles/simVolumes/bold_${vol}.nii
        vol=$((vol+1))
    done

    vol=212
    for i in {0..23}; do
        fslmaths $boldMask -mul ${mag[$i]} $outFiles/hrfFiles/${i}gammacluster.nii
        fslmaths $gaussPath/bold_3d.nii -add $outFiles/hrfFiles/${i}gammacluster.nii $outFiles/simVolumes/bold_${vol}.nii
        vol=$((vol+1))
    done

    vol=287
    for i in {0..23}; do
        fslmaths $boldMask -mul ${mag[$i]} $outFiles/hrfFiles/${i}gammacluster.nii  
        fslmaths $gaussPath/bold_3d.nii -add $outFiles/hrfFiles/${i}gammacluster.nii $outFiles/simVolumes/bold_${vol}.nii
        vol=$((vol+1))
    done

    vol=362
    for i in {0..23}; do
        fslmaths $boldMask -mul ${mag[$i]} $outFiles/hrfFiles/${i}gammacluster.nii  
        fslmaths $gaussPath/bold_3d.nii -add $outFiles/hrfFiles/${i}gammacluster.nii $outFiles/simVolumes/bold_${vol}.nii
        vol=$((vol+1))
    done

    vol=437
    for i in {0..23}; do
        fslmaths $boldMask -mul ${mag[$i]} $outFiles/hrfFiles/${i}gammacluster.nii  
        fslmaths $gaussPath/bold_3d.nii -add $outFiles/hrfFiles/${i}gammacluster.nii $outFiles/simVolumes/bold_${vol}.nii
        vol=$((vol+1))
    done

    vol=512
    for i in {0..23}; do
        fslmaths $boldMask -mul ${mag[$i]} $outFiles/hrfFiles/${i}gammacluster.nii  
        fslmaths $gaussPath/bold_3d.nii -add $outFiles/hrfFiles/${i}gammacluster.nii $outFiles/simVolumes/bold_${vol}.nii
        vol=$((vol+1))
    done

    vol=587
    for i in {0..13}; do
        fslmaths $boldMask -mul ${mag[$i]} $outFiles/hrfFiles/${i}gammacluster.nii   
        fslmaths $gaussPath/bold_3d.nii -add $outFiles/hrfFiles/${i}gammacluster.nii $outFiles/simVolumes/bold_${vol}.nii
        vol=$((vol+1))
    done


    fslmerge -tr ${outFiles}/bold.gaussian.$magnitude.nii $outFiles/simVolumes/*nii* 1.2
    # gunzip ${boldPath}/*.gz