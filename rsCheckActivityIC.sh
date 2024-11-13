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









# for subject in {001..009}; do
#     for paradigmType in B1 B2 E1 E2; do
#         derivativePath=$pathIn/$subject/eklundTest/derivatives/$paradigmType
#         for derivativeFolder in $derivativePath/*.feat; do
#             nameWOext=$(echo $(basename $derivativeFolder) | sed s,.feat,,)
#             textOut=$pathIn/eklundTestResults/$paradigmType
#             if [[ ! -d $textOut ]]; then
#                 echo "Creating textOut directory $textOut"
#                 mkdir -p $textOut
#             fi
#             mask1=${derivativeFolder}/mask.nii.gz
#             zMap=${derivativeFolder}/thresh_zstat1.nii
#             ActVox1=`fslstats -K ${mask1} ${zMap} -V`
#             ActVox1=`echo "$ActVox1" | cut -d ' ' -f 1`
#             VoxMask=`fslstats -K $mask1 $mask1 -V`
#             VoxMask=`echo "$VoxMask" | cut -d ' ' -f 1`
#             PercVox=$(echo "scale=6; $ActVox1 / $VoxMask" | bc)
#             echo ${ActVox1} >> ${textOut}/actVoxels.txt
#             echo ${nameWOext} >> ${textOut}/names.txt
#             echo ${VoxMask} >> ${textOut}/masks.txt
#             echo ${PercVox} >> ${textOut}/percVoxels.txt
#         done
#     done
# done
# ################################################################################################################################################################






# # change only this:
# dataset=fullTimeSeries
# # ################################################################################################################################################################
# pathIn=/fast/project/PG_Niendorf_fmri/fmri/pipeHMR/projects/H01/fMRI_Igor/fMRIsim/restingState/mniSpace/$dataset
# fsf=/fast/project/PG_Niendorf_fmri/fmri/pipeHMR/projects/H01/fMRI_Igor/fMRIsim/restingState/paradigms/$dataset

# for filterType in noNordic nordic; do
#     # outPut=/fast/project/PG_Niendorf_fmri/fmri/pipeHMR/projects/H01/fMRI_Igor/fMRIsim/restingState/mniSpace/$dataset/$filterType/derivatives
#     outPut=/fast/project/PG_Niendorf_fmri/fmri/pipeHMR/projects/H01/fMRI_Igor/fMRIsim/restingState/mniSpace/$filterType/derivatives
#     for subject in {001..009}; do
#         for fileName in $pathIn/$filterType/sub-${subject}/func/*.ni*; do
#             echo "Path with the file and extension: " $fileName
#             pathFileWOext=${fileName%.nii*}
#             echo "Path with file without extension: " $pathFileWOext
#             nameWOext=${pathFileWOext##*/}
#             echo "File without extension: " $nameWOext
#             for paradigmType in B1 B2 E1 E2; do
#                 activationFile=/fast/project/PG_Niendorf_fmri/fmri/pipeHMR/projects/H01/fMRI_Igor/fMRIsim/restingState/paradigms/$dataset/${paradigmType}.txt
#                 # Check for output directories ##################
#                 if [[ ! -d ${outPut}/sub-${subject}/$paradigmType  ]]; then
#                     echo "Creating output directory " ${outPut}/sub-${subject}/$paradigmType
#                     mkdir -p ${outPut}/sub-${subject}/$paradigmType
#                 else
#                     echo "Output folder exists: ${outPut}/sub-${subject}/$paradigmType"
#                     folders3=${outPut}/sub-${subject}/$paradigmType/${nameWOext}.feat
#                     if [[ ! -f ${folders3}/stats/cope1.nii.gz  ]]; then
#                         echo "ERROR - FAIL GLM for file: " ${folders3}
#                         # rm ${folders3}.fsf
#                         # rm -r ${folders3}.feat
#                         continue
#                      else
#                         echo "OK"
#                      fi
#                 fi
#                 # ################################################
#                 # textOut=${outPut}/sub-${subject}/$paradigmType
#                     # rm ${textOut}/${paradigmType}_actVoxels.txt
#                     # rm ${textOut}/${paradigmType}_names.txt
#                     # rm ${textOut}/${paradigmType}_masks.txt
#                     # rm ${textOut}/${paradigmType}_percVoxels.txt


#                 # mask1=${folders3}/mask.nii.gz
#                 # zMap=${folders3}/thresh_zstat1.nii
#                 # textOut=${outPut}/sub-${subject}/$paradigmType
#                 # ActVox1=`fslstats -K ${mask1} ${zMap} -V`
#                 # ActVox1=`echo "$ActVox1" | cut -d ' ' -f 1`
#                 # VoxMask=`fslstats -K $mask1 $mask1 -V`
#                 # VoxMask==`echo "$ActVox1" | cut -d ' ' -f 1`
#                 # PercVox=$(echo "$ActVox1 / $VoxMask" | bc)
#                 # echo ${ActVox1} >> ${textOut}/${paradigmType}_actVoxels.txt
#                 # echo ${nameWOext} >> ${textOut}/${paradigmType}_names.txt
#                 # echo ${VoxMask} >> ${textOut}/${paradigmType}_masks.txt
#                 # echo ${PercVox} >> ${textOut}/${paradigmType}_percVoxels.txt

#                 # ################################################
#             done
#         done
#     done
# done
# # ################################################################################################################################################################