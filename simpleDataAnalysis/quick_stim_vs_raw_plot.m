%% quick_raw_plot
% Helperscript to quickly check quality and debug raw data with respect to
% - stimulation artifacts
% - registration of stimulations
% - stimulation timing priscission
%
% x-scale in ms
close all
clear

folder='C:\Users\HassinkGC\Dropbox\MATlab\SpikeProcessorII_1_3 - Multiwell\'
load([folder 'MEA-XXXX-0000.mat' ])
ms=double(25)
stim=find(Cs==88);TsStim=Ts(stim);CsStim=FileInfo.StimOrder(1:length(stim),2);
figure;plot(diff((TsStim/ms)));
title('interstimulus intervals');
theoreticalStim=(FileInfo.StimOrder(1:length(stim),1)*ms*1000);
AbsoluteDifference=TsStim(1)-theoreticalStim(1);
difference=theoreticalStim-TsStim;
difference=difference+AbsoluteDifference;
figure;plot(difference/ms);
title( ['stimulation error mean: ' num2str(mean(abs(difference))/25) ' ms' ]);
load([folder 'raw-MEA-XXXX-0000-00.mat' ])
step=double(20000);

t2=[];t1=[];
for j=step:step:double(size(Raw,2))
    
    
    idx=find(TsStim>(j-step) & TsStim<j);
    y(1:length(idx))=-2000;
    t1=[t1; TsStim(idx)];
    for k=1:length(idx)
        channel=find(FileInfo.channelorder==CsStim(idx(k)));
        a=diff(Raw(channel,j-(step-1):j));
        b=find([a inf]>1);
        c=diff([0 b]);  % length of the sequences
        [M, zeroInRaw]=max(c);
       
        % idx2=find(Ts>TsStim(idx(k)) & Ts<TsStim(idx(k))+(25000*1.5));
        %[M,I]=min(Us(idx2,53)& Cs(idx2)~=find(FileInfo.StimOrder(idx(k),2)));
        plotTs(idx(k))=j-(step-1)+ b(zeroInRaw-1);
        t2=[t2; plotTs(idx(k))];
        
    end
    if length(y)>0
        
        figure;
        
        p=plot(TsStim(idx)/ms,y,'*');
        %p = plot(x,y);
        p.DataTipTemplate.DataTipRows(1).Format = '%5.3f'; % x
        p.DataTipTemplate.DataTipRows(2).Format = '%5.3f'; % y
        
        hold on
        p=plot(plotTs(idx)/ms,y,'o');
        %p = plot(x,y);
        p.DataTipTemplate.DataTipRows(1).Format = '%5.3f'; % x
        p.DataTipTemplate.DataTipRows(2).Format = '%5.3f'; % y
        y=[];
        hold on
        for i =1:60
            
            p=plot((j-(step-1):j)/ms,Raw(i,j-(step-1):j)+(i*500), 'color', [i/60 0.5 0.5]);
            p.DataTipTemplate.DataTipRows(1).Format = '%5.3f'; % x
            p.DataTipTemplate.DataTipRows(2).Format = '%5.3f'; % y
            hold on
            
        end
        
        %title(folder);
    end
    
end
%figure; plot(Raw(find(FileInfo.channelorder==51),:));hold on; plot(Raw(find(FileInfo.channelorder==41),:));hold on; plot(Raw(find(FileInfo.channelorder==52),:));
mean(t2-t1)/ms
std(t2-t1)/ms
figure;plot((t2-t1)/25);ylim([-20 20]);
