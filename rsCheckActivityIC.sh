#!/bin/bash

#$ -N act_rs
#$ -m ea
#$ -cwd
#$ -j Y
#$ -V
#$ -l m_mem_free=50G
#$ -pe smp 3

set -x

paradigm=$1
# # For whole brain:
pathIn=/fast/project/PG_Niendorf_fmri/fmri/pipeHMR/projects/H01/fMRI_Igor/fMRIsim/restingState3/derivativesIC


textOut=$pathIn/../eklundTestResultsIC/eklundTestResults6/$paradigm

if [[ ! -d $textOut ]]; then
    echo "Creating textOut directory $textOut"
    mkdir -p $textOut
fi
for paradigmFolders in $pathIn/${paradigm}*; do
    # echo $paradigmFolders
    paradigmName=$(basename ${paradigmFolders})
    for featFolders in $paradigmFolders/*.feat; do
        featName=$(basename ${featFolders} | sed s,.feat,,)
        zMap=$featFolders/thresh_zstat1.nii.gz
        mask1=$featFolders/mask.nii.gz
        ActVox1=`fslstats -K ${mask1} ${zMap} -V`
        ActVox1=`echo "$ActVox1" | cut -d ' ' -f 1`
        VoxMask=`fslstats -K $mask1 $mask1 -V`
        VoxMask=`echo "$VoxMask" | cut -d ' ' -f 1`
        PercVox=$(echo "scale=6; $ActVox1 / $VoxMask" | bc)
        echo ${ActVox1} >> ${textOut}/${paradigmName}-actVoxels.txt
        echo ${featName} >> ${textOut}/${paradigmName}-names.txt
        echo ${VoxMask} >> ${textOut}/${paradigmName}-masks.txt
        
        echo ${PercVox} >> ${textOut}/${paradigmName}-percVoxels.txt
    done
done


# AWS:

for paradigmFolders in $pathIn/${paradigm}*; do
    # echo $paradigmFolders
    paradigmName=$(basename ${paradigmFolders})
    for featFolders in $paradigmFolders/*ICclean.feat; do
        for awsType in 0.8 1; do
            featName=$(basename ${featFolders} | sed s,.feat,_aws${awsType},)
            zMap=$featFolders/aws${awsType}/aws.thr_zstat.nii.gz
            mask1=$featFolders/mask.nii.gz
            ActVox1=`fslstats -K ${mask1} ${zMap} -V`
            ActVox1=`echo "$ActVox1" | cut -d ' ' -f 1`
            VoxMask=`fslstats -K $mask1 $mask1 -V`
            VoxMask=`echo "$VoxMask" | cut -d ' ' -f 1`
            PercVox=$(echo "scale=6; $ActVox1 / $VoxMask" | bc)
            echo ${ActVox1} >> ${textOut}/${paradigmName}-actVoxels.txt
            echo ${featName} >> ${textOut}/${paradigmName}-names.txt
            echo ${VoxMask} >> ${textOut}/${paradigmName}-masks.txt
            echo ${PercVox} >> ${textOut}/${paradigmName}-percVoxels.txt
        done
    done
done
