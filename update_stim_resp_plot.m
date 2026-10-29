%% meanSr = update_stim_resp_plot(meanSr,edges,StimOrder,Sr,channel,channelorder)
% Adds new histograms to the stimululus reponse matrix per stimulated electrode
% Channel = 0 if nothing has to be displayed

function meanSr = update_stim_resp_plot(meanSr,edges,StimOrder,Sr,channel,channelorder)

    % initialize matrices
    uniqueEL=unique(StimOrder(:,2));
    uniqueAMP=unique(StimOrder(:,3));
    responses=nan(size(StimOrder,1),length(edges));
    responses(1:size(Sr,1),1:size(Sr,2))=Sr;
    if isempty(meanSr)
        % make a matrix size histogram, different amplitudes, used electrodes 
        meanSr=nan(length(edges),length(uniqueAMP),87);
    end

    % take the mean per electrode per amplitude
    for EL=1:length(uniqueEL)
        for AMP=1:length(uniqueAMP)
            idx=find (StimOrder(:,2)==uniqueEL(EL) & StimOrder(:,3)==uniqueAMP(AMP) );
            if ~isempty(idx)
            meanSr(:,AMP,uniqueEL(EL))=nanmean(responses(idx,:),1);
            end
        end
    end
    
    % plot the responses in the selected channel
    if (channel>0)
        legend1=num2cell(uniqueAMP);
        plot(edges/25,meanSr(:,:,channelorder(channel)) ); 
        legend(string(legend1));
        thisplot=meanSr(:,:,channelorder(channel));
        if ~isempty(thisplot)
        %max(max(thisplot))
            ylim([0 50])
        end
    end
end