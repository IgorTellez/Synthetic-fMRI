%% looping through array of strings:
noise = {'gaussian','rician', 'thermal'};
magnitudes = {'0.5', '1', '2', '3', '4', '5','6'};
for noiseType = 1:length(noise) % consider using parfor
    currentNoise = noise{noiseType};
    for magnitudeLevel = 1:length(magnitudes) % consider using parfor
        currentMagnitude = magnitudes{magnitudeLevel};
        mainPath = '/Path/to/read/data/';
        save2Path = '/Main/path/to/save/plots';
        savePlotPath = strcat(save2Path,'/',currentNoise); % , '/',currentMagnitude); % Specific path to save plots
        cd(mainPath)
        
        % Load the text files into a variables, each column is a mask
        fc = string(fileread('header.txt'));
        fHeader = split(fc,newline);
        fHeader(cellfun('isempty',fHeader)) = [];
        fn_txt(:,1) = fHeader;
        fn_txt(:,2) = load('spaAcFN_M1.txt');
        fn_txt(:,3) = load('spaAcFN_M2.txt');
        fn_txt(:,4) = load('spaAcFN_M3.txt');
        fn_txt(:,5) = load('spaAcFN_M4.txt');

        fp_txt(:,1) = fHeader;
        fp_txt(:,2) = load('spaAcFP_M1.txt');
        fp_txt(:,3) = load('spaAcFP_M2.txt');
        fp_txt(:,4) = load('spaAcFP_M3.txt');
        fp_txt(:,5) = load('spaAcFP_M4.txt');
        
        fpWB_txt(:,1) = fHeader;
        fpWB_txt(:,2) = load('WB_fp.txt');

        % Separate the noise level, each dimension is a noise level 1,2,4%
        fn_Header(:,:,1) = fn_txt(contains(fn_txt, "x1"),:);      
        fn_Header(:,:,2) = fn_txt(contains(fn_txt, "x2"),:);
        fn_Header(:,:,3) = fn_txt(contains(fn_txt, "x4"),:);

        fp_Header(:,:,1) = fp_txt(contains(fp_txt, "x1"),:);
        fp_Header(:,:,2) = fp_txt(contains(fp_txt, "x2"),:);
        fp_Header(:,:,3) = fp_txt(contains(fp_txt, "x4"),:);

        fpWB_Header(:,:,1) = fpWB_txt(contains(fpWB_txt, "x1"),:);
        fpWB_Header(:,:,2) = fpWB_txt(contains(fpWB_txt, "x2"),:);
        fpWB_Header(:,:,3) = fpWB_txt(contains(fpWB_txt, "x4"),:);

        % Arrange positions: unfiltered, s1.5, 2.5, 3.5, light, medium, stron, aws
        % columns: mask 4 (small), mask 3 (complex), mask2 (circle), mask 1 (circle)
        fn_Header1=fn_Header;
        fn_Header1 = reshape(fn_Header1,[10 5 9 3]);
        fp_Header1=fp_Header;
        fp_Header1 = reshape(fp_Header1,[10 5 9 3]);
        fpWB_Header1=fpWB_Header;
        fpWB_Header1 = reshape(fpWB_Header1,[10 2 9 3]);
            
        fn_Header1(:,:,1,:) = fn_Header(~contains(fn_Header(:,1,1), "_"),:,:);
        fn_Header1(:,:,2,:) = fn_Header(contains(fn_Header(:,1,1), "S1.0"),:,:);
        fn_Header1(:,:,3,:) = fn_Header(contains(fn_Header(:,1,1), "S1.5"),:,:);
        fn_Header1(:,:,4,:) = fn_Header(contains(fn_Header(:,1,1), "S2.5"),:,:);
        fn_Header1(:,:,5,:) = fn_Header(contains(fn_Header(:,1,1), "light"),:,:);
        fn_Header1(:,:,6,:) = fn_Header(contains(fn_Header(:,1,1), "medium"),:,:);
        fn_Header1(:,:,7,:) = fn_Header(contains(fn_Header(:,1,1), "strong"),:,:);
        fn_Header1(:,:,8,:) = fn_Header(contains(fn_Header(:,1,1), "aws1"),:,:);
        fn_Header1(:,:,9,:) = fn_Header(contains(fn_Header(:,1,1), "aws0.8"),:,:);

        fp_Header1(:,:,1,:) = fp_Header(~contains(fp_Header(:,1,1), "_"),:,:);
        fp_Header1(:,:,2,:) = fp_Header(contains(fp_Header(:,1,1), "S1.0"),:,:);
        fp_Header1(:,:,3,:) = fp_Header(contains(fp_Header(:,1,1), "S1.5"),:,:);
        fp_Header1(:,:,4,:) = fp_Header(contains(fp_Header(:,1,1), "S2.5"),:,:);
        fp_Header1(:,:,5,:) = fp_Header(contains(fp_Header(:,1,1), "light"),:,:);
        fp_Header1(:,:,6,:) = fp_Header(contains(fp_Header(:,1,1), "medium"),:,:);
        fp_Header1(:,:,7,:) = fp_Header(contains(fp_Header(:,1,1), "strong"),:,:);
        fp_Header1(:,:,8,:) = fp_Header(contains(fp_Header(:,1,1), "aws1"),:,:); 
        fp_Header1(:,:,9,:) = fp_Header(contains(fp_Header(:,1,1), "aws0.8"),:,:); 

        % WB
        fpWB_Header1(:,:,1,:) = fpWB_Header(~contains(fpWB_Header(:,1,1), "_"),:,:); % for hetero
        fpWB_Header1(:,:,2,:) = fpWB_Header(contains(fpWB_Header(:,1), "S1.0"),:,:);
        fpWB_Header1(:,:,3,:) = fpWB_Header(contains(fpWB_Header(:,1), "S1.5"),:,:);
        fpWB_Header1(:,:,4,:) = fpWB_Header(contains(fpWB_Header(:,1), "S2.5"),:,:);
        fpWB_Header1(:,:,5,:) = fpWB_Header(contains(fpWB_Header(:,1), "light"),:,:);
        fpWB_Header1(:,:,6,:) = fpWB_Header(contains(fpWB_Header(:,1), "medium"),:,:);
        fpWB_Header1(:,:,7,:) = fpWB_Header(contains(fpWB_Header(:,1), "strong"),:,:);
        fpWB_Header1(:,:,8,:) = fpWB_Header(contains(fpWB_Header(:,1), "aws1"),:,:); 
        fpWB_Header1(:,:,9,:) = fpWB_Header(contains(fpWB_Header(:,1), "aws0.8"),:,:); 
            
        idxC = [1 5 4 3 2]; % to reoder the correct position of masks, (mask 1 is left, 4 is right)
        fn_Header = fn_Header1(:,idxC,:,:);
        fp_Header = fp_Header1(:,idxC,:,:);
        fpWB_Header = fpWB_Header1;

        % Extract only the values and turned them into double
        fn = str2double(fn_Header(:,2:end,:,:));
        fp = str2double(fp_Header(:,2:end,:,:));
        fpWB = str2double(fpWB_Header(:,2,:,:));
        fnWB =sum(fn,2);
        
        % true positives
        % mask 1 (m1) has 33 voxels, m2=903, m3=257, m4=257
        tp = zeros(10,4,9,3);
        tpCalc = @(x,n) ((n - x));
        tp(:,4,:,:) = tpCalc(fn(:,4,:,:),257);
        tp(:,3,:,:) = tpCalc(fn(:,3,:,:),257);
        tp(:,2,:,:) = tpCalc(fn(:,2,:,:),903);
        tp(:,1,:,:) = tpCalc(fn(:,1,:,:),33);
        
        % Sensitivity
        sensCalc = @(tp, fn) ((tp)./(tp + fn))*100;
        sens = sensCalc(tp,fn);
        sensWB = sensCalc(sum(tp,2),sum(fn,2));

        % Dice Score a.k.a. accuracy
        diceScore = @(tp, fp, fn) ((2*tp)./((2*tp)+fp+fn))*100;
        dice = diceScore(tp, fp, fn);
        diceWB = diceScore(sum(tp,2), fpWB, sum(fn,2));
        
        fnMean = permute(mean(fn,1),[2 3 4 1]);
        fpMean = permute(mean(fp,1),[2 3 4 1]);
        diceMean = permute(mean(dice,1),[2 3 4 1]);
        sensMean = permute(mean(sens,1),[2 3 4 1]);
        fpWBMean = permute(mean(fpWB,1),[1 3 4 2]);
        diceWBMean = permute(mean(diceWB,1),[1 3 4 2]);
        sensWBMean = permute(mean(sensWB,1),[1 3 4 2]);
        
        fnStd = permute(std(fn,0,1),[2 3 4 1]);
        fpStd = permute(std(fp,0,1),[2 3 4 1]);
        diceStd = permute(std(dice,0,1),[2 3 4 1]);
        sensStd = permute(std(sens,0,1),[2 3 4 1]);
        fpWBStd = permute(std(fpWB,0,1),[1 3 4 2]);
        diceWBStd = permute(std(diceWB,0,1),[1 3 4 2]);
        sensWBStd = permute(std(sensWB,0,1),[1 3 4 2]);

        % Save the values
        if strcmp(currentMagnitude,'0.5')
            my_field = strcat(currentNoise,'_','05');
        else
            my_field = strcat(currentNoise,'_',currentMagnitude);
        end

        fns.(my_field) = fnMean;
        fps.(my_field) = fpMean;
        dices.(my_field) = diceMean;
        senses.(my_field) = sensMean;
        WBsenses.(my_field) = sensWBMean;
        WBdices.(my_field) = diceWBMean;
        WBfps.(my_field) = fpWBMean;

        fns_std.(my_field) = fnStd;
        fps_std.(my_field) = fpStd;
        dices_std.(my_field) = diceStd;
        senses_std.(my_field) = sensStd;
        WBsenses_std.(my_field) = sensWBStd;
        WBdices_std.(my_field) = diceWBStd;
        WBfps_std.(my_field) = fpWBStd;
    
        clearvars -except dices senses fps fns noise magnitudes noiseType currentNoise magnitudeLevel WBsenses WBdices WBfps currentMagnitude...
            fns_std fps_std dices_std senses_std WBsenses_std WBdices_std WBfps_std

    end
end 
% additional steps
% For Xtra TS
% run accSensXtra.m
% for each mask
fields = fieldnames(senses);
% sensWB = zeros(1,8,3,7);
% dicesWB = zeros(1,8,3,7);
% sensWBstd = zeros(1,8,3,7);
% dicesWBstd = zeros(1,8,3,7);
masksWBSens = zeros(5,9,3,7);
masksWBDices = zeros(5,9,3,7);
masksWBSensStd = zeros(5,9,3,7);
masksWBDicesStd = zeros(5,9,3,7);
n = 0;
% for z=1:1 % noise type
    for i=1:7 %bold mag
        magLevel = fields{i+n};
        for j = 1:3 %noise level
%                 maskDices(:,i,k,j,z) = permute(dices.(magLevel)(:,k,j),[1 3 2]);
            masksWBSens(5,:,:,i) = WBsenses.(magLevel);
            masksWBDices(5,:,:,i) = WBdices.(magLevel);
            masksWBSensStd(5,:,:,i) = WBsenses_std.(magLevel);
            masksWBDicesStd(5,:,:,i) = WBdices_std.(magLevel);
            
            masksWBSens(1:4,:,:,i) = senses.(magLevel);
            masksWBDices(1:4,:,:,i) = dices.(magLevel);
            masksWBSensStd(1:4,:,:,i) = senses_std.(magLevel);
            masksWBDicesStd(1:4,:,:,i) = dices_std.(magLevel);

        end
    end


masksWBSens = permute(masksWBSens, [1 2 4 3]); % (1:4 masks 5 WB, filters, BOLD magnitude 0.5-6%, Noise level 1% 2% 4%)
masksWBDices = permute(masksWBDices, [1 2 4 3]);
masksWBSensStd = permute(masksWBSensStd, [1 2 4 3]);
masksWBDicesStd = permute(masksWBDicesStd, [1 2 4 3]);



% Plots

%         % Dice by noises
%         plotMatrix4(dice(:,:,1)','diceMasksx10',0,'NoLabels',savePlotPathNoises,1,'off')
%         plotMatrix4(dice(:,:,2)','diceMasksx20',0,'NoLabels',savePlotPathNoises,1,'off')
%         plotMatrix4(dice(:,:,3)','diceMasksx40',0,'NoLabels',savePlotPathNoises,1,'off')
%         plotMatrix4(mean(dice(:,:,1),2)','diceMasksx10_Mean',0,'NoLabels',savePlotPathNoises,1,'off')
%         plotMatrix4(mean(dice(:,:,2),2)','diceMasksx20_Mean',0,'NoLabels',savePlotPathNoises,1,'off')
%         plotMatrix4(mean(dice(:,:,3),2)','diceMasksx40_Mean',0,'NoLabels',savePlotPathNoises,1,'off')
%         % Sens by noises
%         plotMatrix4(sens(:,:,1)','sensMasksx10',0,'NoLabels',savePlotPathNoises,1,'off')
%         plotMatrix4(sens(:,:,2)','sensMasksx20',0,'NoLabels',savePlotPathNoises,1,'off')
%         plotMatrix4(sens(:,:,3)','sensMasksx40',0,'NoLabels',savePlotPathNoises,1,'off')
%         plotMatrix4(mean(sens(:,:,1),2)','sensMasksx10_Mean',0,'NoLabels',savePlotPathNoises,1,'off')
%         plotMatrix4(mean(sens(:,:,2),2)','sensMasksx20_Mean',0,'NoLabels',savePlotPathNoises,1,'off')
%         plotMatrix4(mean(sens(:,:,3),2)','sensMasksx40_Mean',0,'NoLabels',savePlotPathNoises,1,'off')
%         % FP by noises
%         plotMatrix4(fp(:,:,1)','fpMasksx10',0,'NoLabels',savePlotPathNoises,1,'off')
%         plotMatrix4(fp(:,:,2)','fpMasksx20',0,'NoLabels',savePlotPathNoises,1,'off')
%         plotMatrix4(fp(:,:,3)','fpMasksx40',0,'NoLabels',savePlotPathNoises,1,'off')
%         plotMatrix4(mean(fp(:,:,1),2)','fpMasksx10_Mean',0,'NoLabels',savePlotPathNoises,1,'off')
%         plotMatrix4(mean(fp(:,:,2),2)','fpMasksx20_Mean',0,'NoLabels',savePlotPathNoises,1,'off')
%         plotMatrix4(mean(fp(:,:,3),2)','fpMasksx40_Mean',0,'NoLabels',savePlotPathNoises,1,'off')
%         % FN_P by noises
% %         plotMatrix4(fn_P(:,:,1)','fn_P_Masksx10',0,'NoLabels',savePlotPathNoises,1,'off')
% %         plotMatrix4(fn_P(:,:,2)','fn_P_Masksx20',0,'NoLabels',savePlotPathNoises,1,'off')
% %         plotMatrix4(fn_P(:,:,3)','fn_P_Masksx40',0,'NoLabels',savePlotPathNoises,1,'off')
% %         plotMatrix4(mean(fn_P(:,:,1),2)','fn_P_Masksx10_Mean',0,'NoLabels',savePlotPathNoises,1,'off')
% %         plotMatrix4(mean(fn_P(:,:,2),2)','fn_P_Masksx20_Mean',0,'NoLabels',savePlotPathNoises,1,'off')
% %         plotMatrix4(mean(fn_P(:,:,3),2)','fn_P_Masksx40_Mean',0,'NoLabels',savePlotPathNoises,1,'off')
% %         FN by noises in voxels
%         plotMatrix4(fn(:,:,1)','fn_Masksx10',0,'NoLabels',savePlotPathNoises,1,'off')
%         plotMatrix4(fn(:,:,2)','fn_Masksx20',0,'NoLabels',savePlotPathNoises,1,'off')
%         plotMatrix4(fn(:,:,3)','fn_Masksx40',0,'NoLabels',savePlotPathNoises,1,'off')
%         plotMatrix4(mean(fn(:,:,1),2)','fn_Masksx10_Mean',0,'NoLabels',savePlotPathNoises,1,'off')
%         plotMatrix4(mean(fn(:,:,2),2)','fn_Masksx20_Mean',0,'NoLabels',savePlotPathNoises,1,'off')
%         plotMatrix4(mean(fn(:,:,3),2)','fn_Masksx40_Mean',0,'NoLabels',savePlotPathNoises,1,'off')
%         % WB:
% %         sizePlot = [1 8];
%         % Dice WB by noises
%         plotMatrix4(diceWB(:,:,1)','diceWBMasksx10',0,'NoLabels',savePlotPathNoises,1,'off')
%         plotMatrix4(diceWB(:,:,2)','diceWBMasksx20',0,'NoLabels',savePlotPathNoises,1,'off')
%         plotMatrix4(diceWB(:,:,3)','diceWBMasksx40',0,'NoLabels',savePlotPathNoises,1,'off')
% 
%         % Sens WB by noises
%         plotMatrix4(sensWB(:,:,1)','sensWBMasksx10',0,'NoLabels',savePlotPathNoises,1,'off')
%         plotMatrix4(sensWB(:,:,2)','sensWbMasksx20',0,'NoLabels',savePlotPathNoises,1,'off')
%         plotMatrix4(sensWB(:,:,3)','sensWBMasksx40',0,'NoLabels',savePlotPathNoises,1,'off')
% 
%         % FP WB by noises
%         plotMatrix4(fpWB(:,:,1)','fpWB10',0,'NoLabels',savePlotPathNoises,1,'off')
%         plotMatrix4(fpWB(:,:,2)','fpWB20',0,'NoLabels',savePlotPathNoises,1,'off')
%         plotMatrix4(fpWB(:,:,3)','fpWB40',0,'NoLabels',savePlotPathNoises,1,'off')
%
