%% Waveforms = update_waveplot(Waveforms,Cs,Us,channel,maxplots,channelorder)
% plots the last n waveshapes as defined by maxplots for the selected
% channel.
function Waveforms = update_waveplot(Waveforms,Cs,Us,channel,maxplots,channelorder)
%Channel = 0 if nothing has to be displayed

if isempty(Waveforms)

    Waveforms=zeros(size(Us,2),maxplots,length(channelorder));
end
for i=1:length(Cs)
    Chan=find(channelorder==Cs(i));
%     if Cs(i)==88
%         Chan=61;
%     end
    for pos=1:maxplots-1       
        Waveforms(:,pos,Chan)=Waveforms(:,pos+1,Chan);
    end
    Waveforms(:,maxplots,Chan)=Us(i,:);
end
%plot(Waveforms(:,:,7)) % 7 = willekeurig ongebruikt kanaalnummer?
if (channel>0) 
    plot(Waveforms(:,:,channel)); 
    ylim([-300 100]);
end
end