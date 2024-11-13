% Settings to plot
saveP = 1;
visible = 0;
decimals = 0;
labelss = 'NoLabels';
% Choose operating system
clusterPath ='/fast/project/PG_Niendorf_fmri';
macPath = '/Volumes/project/PG_Niendorf_fmri';
windowsPath = 'Z:/';
OStypeP = macPath;
% Paths to masks
dilMask1P = strcat(OStypeP,'/mask4_dil9.nii.gz');
dilMask2P = strcat(OStypeP,'/mask3_dil9.nii.gz');
dilMask3P = strcat(OStypeP,'//mask2_dil9.nii.gz');
dilMask4P = strcat(OStypeP,'/mask1_dil9.nii.gz');
dilMasksWBP = strcat(OStypeP,'/Allmasks_dil9.nii.gz');
dilMasksWB = niftiread(dilMasksWBP);
dilMask1 = niftiread(dilMask1P);
dilMask2 = niftiread(dilMask2P);
dilMask3 = niftiread(dilMask3P);
dilMask4 = niftiread(dilMask4P);
% activation masks:
dataset = % 'heterogeneous' 
if strcmp(dataset, 'Heterogeneous')
    refMaskP = strcat(OStypeP,'/fmri/pipeHMR/projects/H01/fMRI_Igor/fMRIsim/Hetero5/masks/threeLayers_123s.nii.gz');
elseif strcmp(dataset,'Homogeneous')
    refMaskP = strcat(OStypeP,'/fmri/pipeHMR/projects/H01/fMRI_Igor/fMRIsim/Hetero7/masks/allSkewedMasks_123.nii.gz');
end
refMask = niftiread(refMaskP);

ccAll = cell(270,6); % 270 = 3 noises * 9 filters * 10 time series
ccAllz = cell(270,6);


ccFiltOrder = strings(10,6,9,3);
ccFiltOrderz = strings(10,6,9,3);

ccNoiseOrder = strings(90,6,3);
ccNoiseOrderz = strings(90,6,3);

awsType = {'aws1','aws0.8'};
awsName = {'aws1','aws2'};

% looping through array of strings:
noise = {'gaussian','rician'};
magnitudes = {'0.5', '1', '2', '3', '4', '5','6'};
for noiseType = 1:length(noise) % consider using parallel loops
    currentNoise = noise{noiseType};
    for magnitudeLevel = 1:length(magnitudes)
        currentMagnitude = magnitudes{magnitudeLevel};
        mainPath = '/Path/to/FSL/derivatives/';
        savePath = '/Path/to/save/plots';
        newPath = strcat(mainPath,currentNoise,'/',currentMagnitude);
        cd(newPath)     
        feat = dir('*.feat*');
        foldersFeat = {feat.name}';
        foldersFeat(contains(foldersFeat, "S3.5")) = [];
        j = 211;
        for i=1:size(foldersFeat,1) 

            copeMapP = strcat(char(foldersFeat(i)),'/stats/cope1.nii.gz');
            filtZmapThP = strcat(char(foldersFeat(i)),'/thresh_zstat1.nii.gz');
            copeMap = niftiread(copeMapP);
            filtZmapTh = niftiread(filtZmapThP);

            binZmap = filtZmapTh > 0.5;
            copeMasked = copeMap.*binZmap;
            % Corr GT - COPE masked with z-map
            coefCorrThM1 = corrcoef(refMask(dilMask1>0.5),copeMasked(dilMask1>0.5));
            coefCorrThM2 = corrcoef(refMask(dilMask2>0.5),copeMasked(dilMask2>0.5));
            coefCorrThM3 = corrcoef(refMask(dilMask3>0.5),copeMasked(dilMask3>0.5));
            coefCorrThM4 = corrcoef(refMask(dilMask4>0.5),copeMasked(dilMask4>0.5));
            coefCorrThMWB = corrcoef(refMask(dilMasksWB>0.5),copeMasked(dilMasksWB>0.5));
            coefCorrThM1(isnan(coefCorrThM1))=0;
            coefCorrThM2(isnan(coefCorrThM2))=0;
            coefCorrThM3(isnan(coefCorrThM3))=0;
            coefCorrThM4(isnan(coefCorrThM4))=0;
            coefCorrThMWB(isnan(coefCorrThMWB))=0;
            
            ccAll(i,1) = foldersFeat(i);
            ccAll(i,2) = num2cell(coefCorrThM1(2,1));
            ccAll(i,3) = num2cell(coefCorrThM2(2,1));
            ccAll(i,4) = num2cell(coefCorrThM3(2,1));
            ccAll(i,5) = num2cell(coefCorrThM4(2,1));
            ccAll(i,6) = num2cell(coefCorrThMWB(2,1));
            % Corr Gt - zMap
            coefCorrThM1z = corrcoef(refMask(dilMask1>0.5),filtZmapTh(dilMask1>0.5));
            coefCorrThM2z = corrcoef(refMask(dilMask2>0.5),filtZmapTh(dilMask2>0.5));
            coefCorrThM3z = corrcoef(refMask(dilMask3>0.5),filtZmapTh(dilMask3>0.5));
            coefCorrThM4z = corrcoef(refMask(dilMask4>0.5),filtZmapTh(dilMask4>0.5));
            coefCorrThMWBz = corrcoef(refMask(dilMasksWB>0.5),filtZmapTh(dilMasksWB>0.5));
            coefCorrThM1z(isnan(coefCorrThM1z))=0;
            coefCorrThM2z(isnan(coefCorrThM2z))=0;
            coefCorrThM3z(isnan(coefCorrThM3z))=0;
            coefCorrThM4z(isnan(coefCorrThM4z))=0;
            coefCorrThMWBz(isnan(coefCorrThMWBz))=0;
            ccAllz(i,1) = foldersFeat(i);
            ccAllz(i,2) = num2cell(coefCorrThM1z(2,1));
            ccAllz(i,3) = num2cell(coefCorrThM2z(2,1));
            ccAllz(i,4) = num2cell(coefCorrThM3z(2,1));
            ccAllz(i,5) = num2cell(coefCorrThM4z(2,1));
            ccAllz(i,6) = num2cell(coefCorrThMWBz(2,1));

           

            if ~contains(char(foldersFeat(i)), "_") % For AWS

                for awsNum = 1:2
                
                    copeMapP = strcat(char(foldersFeat(i)),'/',string(awsType(awsNum)),'/AWScope.nii');
                    filtZmapThP = strcat(char(foldersFeat(i)),'/',string(awsType(awsNum)),'/aws.thr_zstat.nii.gz');
                    copeMap = niftiread(copeMapP);
                    filtZmapTh = niftiread(filtZmapThP);
                    binZmap = filtZmapTh > 0.5;
                    copeMasked = copeMap.*binZmap;
                    
                     % Corr GT - COPE masked with z-map
                    coefCorrThM1 = corrcoef(refMask(dilMask1>0.5),copeMasked(dilMask1>0.5));
                    coefCorrThM2 = corrcoef(refMask(dilMask2>0.5),copeMasked(dilMask2>0.5));
                    coefCorrThM3 = corrcoef(refMask(dilMask3>0.5),copeMasked(dilMask3>0.5));
                    coefCorrThM4 = corrcoef(refMask(dilMask4>0.5),copeMasked(dilMask4>0.5));
                    coefCorrThMWB = corrcoef(refMask(dilMasksWB>0.5),copeMasked(dilMasksWB>0.5));
                    coefCorrThM1(isnan(coefCorrThM1))=0;
                    coefCorrThM2(isnan(coefCorrThM2))=0;
                    coefCorrThM3(isnan(coefCorrThM3))=0;
                    coefCorrThM4(isnan(coefCorrThM4))=0;
                    coefCorrThMWB(isnan(coefCorrThMWB))=0;
                    ccAll(j,1) = cellstr(strcat(char(foldersFeat(i)),'_',string(awsName(awsNum)))); 
                    ccAll(j,2) = num2cell(coefCorrThM1(2,1));
                    ccAll(j,3) = num2cell(coefCorrThM2(2,1));
                    ccAll(j,4) = num2cell(coefCorrThM3(2,1));
                    ccAll(j,5) = num2cell(coefCorrThM4(2,1));
                    ccAll(j,6) = num2cell(coefCorrThMWB(2,1));
                    % Corr Gt - zMap
                    coefCorrThM1z = corrcoef(refMask(dilMask1>0.5),filtZmapTh(dilMask1>0.5));
                    coefCorrThM2z = corrcoef(refMask(dilMask2>0.5),filtZmapTh(dilMask2>0.5));
                    coefCorrThM3z = corrcoef(refMask(dilMask3>0.5),filtZmapTh(dilMask3>0.5));
                    coefCorrThM4z = corrcoef(refMask(dilMask4>0.5),filtZmapTh(dilMask4>0.5));
                    coefCorrThMWBz = corrcoef(refMask(dilMasksWB>0.5),filtZmapTh(dilMasksWB>0.5));
                    coefCorrThM1z(isnan(coefCorrThM1z))=0;
                    coefCorrThM2z(isnan(coefCorrThM2z))=0;
                    coefCorrThM3z(isnan(coefCorrThM3z))=0;
                    coefCorrThM4z(isnan(coefCorrThM4z))=0;
                    coefCorrThMWBz(isnan(coefCorrThMWBz))=0;
                    ccAllz(j,1) = cellstr(strcat(char(foldersFeat(i)),'_',string(awsName(awsNum))));
                    ccAllz(j,2) = num2cell(coefCorrThM1z(2,1));
                    ccAllz(j,3) = num2cell(coefCorrThM2z(2,1));
                    ccAllz(j,4) = num2cell(coefCorrThM3z(2,1));
                    ccAllz(j,5) = num2cell(coefCorrThM4z(2,1));
                    ccAllz(j,6) = num2cell(coefCorrThMWBz(2,1));


                    j = j + 1;
                end
            end
        end
        % DATA ARRANGEMENT:
        % ccFiltOrder = strings(10,5,8,3);
        ccNoiseOrder(:,:,1) = ccAll(contains(ccAll(:,1), "x10"),:);
        ccNoiseOrder(:,:,2) = ccAll(contains(ccAll(:,1), "x2"),:);
        ccNoiseOrder(:,:,3) = ccAll(contains(ccAll(:,1), "x4"),:);
      
        ccNoiseOrderz(:,:,1) = ccAllz(contains(ccAllz(:,1), "x10"),:);
        ccNoiseOrderz(:,:,2) = ccAllz(contains(ccAllz(:,1), "x2"),:);
        ccNoiseOrderz(:,:,3) = ccAllz(contains(ccAllz(:,1), "x4"),:);
     
        %
        ccFiltOrder(:,:,1,:) = ccNoiseOrder(~contains(ccNoiseOrder(:,1,1), "_"),:,:);
        ccFiltOrder(:,:,2,:) = ccNoiseOrder(contains(ccNoiseOrder(:,1,1), "S1.0"),:,:);
        ccFiltOrder(:,:,3,:) = ccNoiseOrder(contains(ccNoiseOrder(:,1,1), "S1.5"),:,:);
        ccFiltOrder(:,:,4,:) = ccNoiseOrder(contains(ccNoiseOrder(:,1,1), "S2.5"),:,:);
        ccFiltOrder(:,:,5,:) = ccNoiseOrder(contains(ccNoiseOrder(:,1,1), "light"),:,:);
        ccFiltOrder(:,:,6,:) = ccNoiseOrder(contains(ccNoiseOrder(:,1,1), "medium"),:,:);
        ccFiltOrder(:,:,7,:) = ccNoiseOrder(contains(ccNoiseOrder(:,1,1), "strong"),:,:);
        ccFiltOrder(:,:,8,:) = ccNoiseOrder(contains(ccNoiseOrder(:,1,1), "aws1"),:,:);
        ccFiltOrder(:,:,9,:) = ccNoiseOrder(contains(ccNoiseOrder(:,1,1), "aws2"),:,:);
        
        ccFiltOrderz(:,:,1,:) = ccNoiseOrderz(~contains(ccNoiseOrderz(:,1,1), "_"),:,:);
        ccFiltOrderz(:,:,2,:) = ccNoiseOrderz(contains(ccNoiseOrderz(:,1,1), "S1.0"),:,:);
        ccFiltOrderz(:,:,3,:) = ccNoiseOrderz(contains(ccNoiseOrderz(:,1,1), "S1.5"),:,:);
        ccFiltOrderz(:,:,4,:) = ccNoiseOrderz(contains(ccNoiseOrderz(:,1,1), "S2.5"),:,:);
        ccFiltOrderz(:,:,5,:) = ccNoiseOrderz(contains(ccNoiseOrderz(:,1,1), "light"),:,:);
        ccFiltOrderz(:,:,6,:) = ccNoiseOrderz(contains(ccNoiseOrderz(:,1,1), "medium"),:,:);
        ccFiltOrderz(:,:,7,:) = ccNoiseOrderz(contains(ccNoiseOrderz(:,1,1), "strong"),:,:);
        ccFiltOrderz(:,:,8,:) = ccNoiseOrderz(contains(ccNoiseOrderz(:,1,1), "aws1"),:,:);
        ccFiltOrderz(:,:,9,:) = ccNoiseOrderz(contains(ccNoiseOrderz(:,1,1), "aws2"),:,:);
        
        % (10,5,8,3)
        ccLabel = ccFiltOrder;
        ccLabelz = ccFiltOrderz;
        cc = str2double(ccFiltOrder(:,2:end,:,:));
        ccz = str2double(ccFiltOrderz(:,2:end,:,:));
        SImean = permute(mean(cc,1),[2 3 4 1]); % (1: masks-WB, 2:filters, 3:noiseLevel, 4:nothing)
        SImeanz = permute(mean(ccz,1),[2 3 4 1]);
        
        SIStd = permute(std(cc,0,1),[2 3 4 1]);
        SIStdz = permute(std(ccz,0,1),[2 3 4 1]);


        % Save the values
        if strcmp(currentMagnitude,'0.5')
            my_field = strcat(currentNoise,'_','05');
        else
            my_field = strcat(currentNoise,'_',currentMagnitude);
        end
        
        ccLabels.(my_field) = ccLabel;
        ccLabelsz.(my_field) = ccLabelz;
        SI.(my_field) = SImean;
        SIz.(my_field) = SImeanz;
        SIstd.(my_field) = SIStd;
        SIstdz.(my_field) = SIStdz;

        clearvars -except noise magnitudes noiseType currentNoise currentMagnitude magnitudeLevel ccLabels ccLabelsz SI SIz SIstd SIstdz refMask...
           dilMasksWB dilMask1 dilMask2 dilMask3 dilMask4 macPath awsType awsNum awsName OStypeP
    end
end
disp 'Done';



% extract the values from ccLabels

fields = fieldnames(ccLabels);

cc05 = permute(mean(str2double(ccLabels.(fields{1})(:,2:end,:,:)),1),[2 3 4 1]);
cc1 = permute(mean(cell2mat(ccLabels.(fields{2})(:,2:end,:,:)),1),[2 3 4 1]);
cc2 = permute(mean(cell2mat(ccLabels.(fields{3})(:,2:end,:,:)),1),[2 3 4 1]);
cc3 = permute(mean(cell2mat(ccLabels.(fields{4})(:,2:end,:,:)),1),[2 3 4 1]);
cc4 = permute(mean(cell2mat(ccLabels.(fields{5})(:,2:end,:,:)),1),[2 3 4 1]);
cc5 = permute(mean(cell2mat(ccLabels.(fields{6})(:,2:end,:,:)),1),[2 3 4 1]);
cc6 = permute(mean(cell2mat(ccLabels.(fields{7})(:,2:end,:,:)),1),[2 3 4 1]);
ccAll = cat(4,cc05,cc1,cc2,cc3,cc4,cc5,cc6).*100;
%
cc05s = permute(std(str2double(ccLabels.(fields{1})(:,2:end,:,:)),0,1),[2 3 4 1]);
cc1s = permute(std(cell2mat(ccLabels.(fields{2})(:,2:end,:,:)),0,1),[2 3 4 1]);
cc2s = permute(std(cell2mat(ccLabels.(fields{3})(:,2:end,:,:)),0,1),[2 3 4 1]);
cc3s = permute(std(cell2mat(ccLabels.(fields{4})(:,2:end,:,:)),0,1),[2 3 4 1]);
cc4s = permute(std(cell2mat(ccLabels.(fields{5})(:,2:end,:,:)),0,1),[2 3 4 1]);
cc5s = permute(std(cell2mat(ccLabels.(fields{6})(:,2:end,:,:)),0,1),[2 3 4 1]);
cc6s = permute(std(cell2mat(ccLabels.(fields{7})(:,2:end,:,:)),0,1),[2 3 4 1]);
ccAlls = cat(4,cc05s,cc1s,cc2s,cc3s,cc4s,cc5s,cc6s).*100; % 1:masks 2:filts 3:noise level 4:bold mag

%%
ccAll = cat(4,cc05,cc1,cc2,cc3,cc4,cc5,cc6).*100;
%% for z values
fields = fieldnames(ccLabels);
cc05z = permute(mean(str2double(ccLabelsz.(fields{1})(:,2:end,:,:)),1),[2 3 4 1]);
cc1z = permute(mean(cell2mat(ccLabelsz.(fields{2})(:,2:end,:,:)),1),[2 3 4 1]);
cc2z = permute(mean(cell2mat(ccLabelsz.(fields{3})(:,2:end,:,:)),1),[2 3 4 1]);
cc3z = permute(mean(cell2mat(ccLabelsz.(fields{4})(:,2:end,:,:)),1),[2 3 4 1]);
cc4z = permute(mean(cell2mat(ccLabelsz.(fields{5})(:,2:end,:,:)),1),[2 3 4 1]);
cc5z = permute(mean(cell2mat(ccLabelsz.(fields{6})(:,2:end,:,:)),1),[2 3 4 1]);
cc6z = permute(mean(cell2mat(ccLabelsz.(fields{7})(:,2:end,:,:)),1),[2 3 4 1]);
ccAllz = cat(4,cc05z,cc1z,cc2z,cc3z,cc4z,cc5z,cc6z).*100;
%
cc05zs = permute(std(str2double(ccLabelsz.(fields{1})(:,2:end,:,:)),0,1),[2 3 4 1]);
cc1zs = permute(std(cell2mat(ccLabelsz.(fields{2})(:,2:end,:,:)),0,1),[2 3 4 1]);
cc2zs = permute(std(cell2mat(ccLabelsz.(fields{3})(:,2:end,:,:)),0,1),[2 3 4 1]);
cc3zs = permute(std(cell2mat(ccLabelsz.(fields{4})(:,2:end,:,:)),0,1),[2 3 4 1]);
cc4zs = permute(std(cell2mat(ccLabelsz.(fields{5})(:,2:end,:,:)),0,1),[2 3 4 1]);
cc5zs = permute(std(cell2mat(ccLabelsz.(fields{6})(:,2:end,:,:)),0,1),[2 3 4 1]);
cc6zs = permute(std(cell2mat(ccLabelsz.(fields{7})(:,2:end,:,:)),0,1),[2 3 4 1]);
ccAllzs = cat(4,cc05zs,cc1zs,cc2zs,cc3zs,cc4zs,cc5zs,cc6zs).*100; % 1:masks 2:filts 3:noise level 4:bold mag
%% data to plot

% masksWBSens = permute(masksWBSens, [1 2 4 3]); % (1:4 masks 5 WB, filters, BOLD magnitude 0.5-6%, Noise level 1% 2% 4%)

ccAll_plot = permute(ccAll, [4 2 1 3]).*100;
ccAlls_plot = permute(ccAlls, [4 2 1 3]).*100;

%% Plot SI
mLabels ={'mask1','mask2','mask3','mask4','WB'};


for nAmp = 1:3
    for mask = 1:5
    meansAll = ccAll_plot(:,:,mask, nAmp);
    stdAll = ccAlls_plot(:,:,mask, nAmp);
    exportme = figure('visible','off');

    % Plot bars
    b = bar(meansAll);
    b(1).FaceColor = "#D500F9";
    b(2).FaceColor = "#B2EBF2";
    b(3).FaceColor = "#00BCD4";
    b(4).FaceColor = "#00838F";
    b(5).FaceColor = "#FFC107";
    b(6).FaceColor = "#FF8F00";
    b(7).FaceColor = "#E65100";
    b(8).FaceColor = "#2962FF";

    % b = boxplot(a55);
    hold on;
    % errorbar([1 2 3 4],meansAll, stdAll,"LineStyle","none")

    % set(gca, 'YScale', 'log');
    %
    % Get bar positions
    numGroups = size(meansAll, 1);
    numBars = size(meansAll, 2);
    groupWidth = min(0.8, numBars/(numBars + 1.5));

    % Loop through each set of bars and set the error bars
    for i = 1:numBars
        % Calculate center of each bar
        x = (1:numGroups) - groupWidth/2 + (2*i-1) * groupWidth / (2*numBars);
        errorbar(x, meansAll(:,i), stdAll(:,i), 'k', 'linestyle', 'none', 'linewidth', 1.5);
    end

    yticks([ 0:25:100])
    ylim([-0.0023 105])
    grid on
    box on
    hold off;

    set(gca, 'XTickLabel',{'0.5%','1%','2%','3%','4%','5%','6%'},'fontweight','bold', 'FontSize', 25,'FontName','helvetica neue','FontWeight','normal');

%     legend('unfiltered', '1.0x', '1.5x',  '2.5x','light','medium','strong','AWS','Location', 'Best');

    exportme.Position = [100 200 1200 500];
            exportgraphics(exportme,...
                strcat('bar_SI-',mLabels{mask},'-noise',string(nAmp),'.tif'),...
                'Resolution',400)
    end
end


