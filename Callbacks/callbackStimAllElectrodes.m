function callbackStimAllElectrodes(source,event)
    %% select all electrodes to stimulate
    global System  FileInfo
   
        if System.StimAllElectrodes==0
            for i=1 : length(FileInfo.channelorder)
                if FileInfo.channelorder(i) ~= 15 && FileInfo.channelorder(i) ~= 88 || length(FileInfo.channelorder) >70 && FileInfo.channelorder(i) ~= 289
                System.Stim(i)=1;
                set(findobj('Tag', ['ground' num2str(FileInfo.channelorder(i))]),'BackgroundColor','red');
                end
            end
            System.StimAllElectrodes=1;
        else
            for i=1 : length(FileInfo.channelorder) 
                if FileInfo.channelorder(i) ~= 15 && FileInfo.channelorder(i) ~= 88 || length(FileInfo.channelorder) >70 && FileInfo.channelorder(i) ~= 289
                System.Stim(i)=0;
                set(findobj('Tag', ['ground' num2str(FileInfo.channelorder(i))]),'BackgroundColor',['green']);
                end
            end
            System.StimAllElectrodes=0;
        end
%     else
%         if System.StimAllElectrodes==0
%             for i=1 : length(FileInfo.channelorder)
%                 if FileInfo.channelorder(i) ~= 289
%                 System.Stim(i)=1;
%                 set(findobj('Tag', ['ground' num2str(FileInfo.channelorder(i))]),'BackgroundColor','red');
%                 end
%             end
%             System.StimAllElectrodes=1;
%         else
%             for i=1 : length(FileInfo.channelorder)
%                 if  FileInfo.channelorder(i) ~= 289
%                     System.Stim(i)=0;
%                     if FileInfo.Ground(System.channeldisp)==0
%                         ground_electrode(System.channeldisp, FileInfo.channelorder)
%                         FileInfo.Ground(System.channeldisp)=1;
%                         set (findobj('Tag', ['ground' num2str(FileInfo.channelorder(i))]),'BackgroundColor',[.7 .7 .7]);
%                     else
%                         activate_electrode(System.channeldisp, FileInfo.channelorder)
%                         FileInfo.Ground(System.channeldisp)=0;
%                         set (findobj('Tag', ['ground' num2str(FileInfo.channelorder(i))]),'BackgroundColor','green');
%                     end
%                     
%                 end
%             end
%             System.StimAllElectrodes=0;
%         end
%     end
end