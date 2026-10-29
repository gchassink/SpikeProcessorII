function callbackGroundButtons(source,event)
    %% Set channels to  ground or re-activate
    global System FileInfo  ;
    System.channeldisp = source.Value;
    if System.ground_stim_toggle== 0
        if FileInfo.Ground(System.channeldisp)==0
            ground_electrode(System.channeldisp, FileInfo.channelorder)
            
            FileInfo.Ground(System.channeldisp)=1;
            set (source,'BackgroundColor',[.7 .7 .7]);
        else
            activate_electrode(System.channeldisp, FileInfo.channelorder)
            FileInfo.Ground(System.channeldisp)=0;
            set (source,'BackgroundColor','green');
        end
    else
        if System.Stim(System.channeldisp)==0
        
            System.Stim(System.channeldisp)=1;
            set (source,'BackgroundColor','red');
        else
        
            System.Stim(System.channeldisp)=0;
            if FileInfo.Ground(System.channeldisp)==1
                set (source,'BackgroundColor', [.7 .7 .7]);
            else
                set (source,'BackgroundColor','green');
            end

        end
    end
end