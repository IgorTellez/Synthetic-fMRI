function plotMatrix4(data,pName,decimals,cbar,savePath,save,visible)

a = data;

if isa(a,'string')
    b = str2double(a);
    roundn = @(x,n) round(x*10^n)./10^n;
    c = roundn(b,decimals);
else 
    b = a;
    roundn = @(x,n) round(x*10^n)./10^n;
    c = roundn(b,decimals);
end

% Generate Labels
t = num2cell(c); % extact values into cells
t = cellfun(@num2str, t, 'UniformOutput', false); % convert to string
sizePlot = size(data);
x = sort(repmat(1:sizePlot(2),1,sizePlot(1)));
y = repmat(1:sizePlot(1),1,sizePlot(2));


exportme = figure('visible',visible);
exportme.Position = [100 200 (sizePlot(1,2)*100) (sizePlot(1,1)*100)];

% Save the image
imagesc(b)

xticklabels({'Unfiltered', '1.5 mm', '2.5 mm', '3.5 mm', 'light', 'medium', 'strong', 'AWS'});
yticklabels({'','1%','','2%','','4%','','8%','','16%'});

set(gca ,'fontweight','bold', 'FontSize', 15, 'TickLength',[0 0]);
box on
if strcmp(cbar, 'full')
    caxis([0 100]);
elseif strcmp(cbar, 'fullC')
    c = colorbar;
    caxis([0 100]);
elseif strcmp(cbar, 'colorbar')
    c = colorbar;
    c.Label.String = '\bf [%]';
    c.Label.FontSize = 15;
elseif strcmp(cbar, 'zmax')
    caxis([0 35]);
elseif strcmp(cbar, 'zmen')
    caxis([0 25]);
elseif strcmp(cbar, 'zstd')
    caxis([0 10]);
elseif strcmp(cbar, 'fp')
    caxis([0 30]);
elseif strcmp(cbar, 'fpC')
    text(x(:), y(:), t, 'HorizontalAlignment', 'Center', 'FontSize', 15, 'FontWeigh', 'bold')
    caxis([0 30]);
    c = colorbar;
elseif strcmp(cbar, 'spes')
    caxis([85 100]);
elseif strcmp(cbar, 'acc')
    caxis([50 100])
elseif strcmp(cbar, 'rsi')
    text(x(:), y(:), t, 'HorizontalAlignment', 'Center', 'FontSize', 15, 'FontWeigh', 'bold')
    set(gca,'YTick',[],'XTick',[])
%     caxis([2 15])
%     c = colorbar;
elseif strcmp(cbar, 'awsPar')
    text(x(:), y(:), t, 'HorizontalAlignment', 'Center', 'FontSize', 30, 'FontWeigh', 'bold')
    caxis([60 100])
        set(gca,'YTick',[],'XTick',[]) % remove labels
elseif strcmp(cbar, 'FnFp')
    text(x(:), y(:), t, 'HorizontalAlignment', 'Center', 'FontSize', 30, 'FontWeigh', 'bold')
%     c = colorbar;
    caxis([0 max(b,[],"all")])
        set(gca,'YTick',[],'XTick',[]) % remove labels
%     c.Label.String = '\bf [%]';
%     c.Label.FontSize = 15;
elseif strcmp(cbar, 'NoLabels')
    text(x(:), y(:), t, 'HorizontalAlignment', 'Center', 'FontSize', 30, 'FontWeigh', 'bold')
%     c = colorbar;
    caxis([0 100])
        set(gca,'YTick',[],'XTick',[]) % remove labels
%     c.Label.String = '\bf [%]';
%     c.Label.FontSize = 15;
elseif strcmp(cbar, 'Labels')
    text(x(:), y(:), t, 'HorizontalAlignment', 'Center', 'FontSize', 15, 'FontWeigh', 'bold')
     c = colorbar;
%     caxis([50 100])
%     set(gca,'YTick',[],'XTick',[]) % remove labels
%     c.Label.String = '\bf [%]';
%     c.Label.FontSize = 15;
end


map = [ 
    0 0.5 1
    0 0.7 1
    0 0.85 1
    0 1 1
    0 1 0.7 % half
    0 1 0.2
    0.6 1 0
    1 0.8 0
    1 0.9 0
    1 1 0]; % highest

colormap(map)

    if save == 1
        exportgraphics(exportme,...
        strcat(savePath,'/',pName,'.tif'),...
        'Resolution',400)
    else
    end


end

