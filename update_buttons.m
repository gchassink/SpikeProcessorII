%% update_buttons(btn_channel, Ras,channelorder, rasterlayout, System.noisevalues) 
%  updates buttons using channelorder, so electrode 12 is
%  number 21 of channelorder and i=1 is electrode 47
%  The buttons are colorcoded the followin way:
%       red=actual activity, 
%       green=average activity, 
%       blue is channel noise.
function update_buttons(btn_channel, Ras,channelorder, rasterlayout, noisevalues,indicatorSet)
                
                Ras_mean=mean(Ras ,2);
                grid_activity=Ras(1:3:end,size(Ras,2)); %  follows raster layout ! not channelorder electrode
                meanFiringRatePerChannel=(Ras_mean(1:3:end)).^2; % mean firing rate per channel in raster layout order the more active, the more close to zero
                for i = 1 : length(noisevalues) % follow channel order i=1 is electrode 47
                    
                    j=find(rasterlayout==channelorder(i));
                    if meanFiringRatePerChannel(j)>1
                        meanFiringRatePerChannel(j)=1;
                    end
                    noise=(noisevalues(i)^5)/15^4; %are in channel order already
                    if noise > 1 
                        noise=1;
                    end
                    show=[1-grid_activity(j) 1-meanFiringRatePerChannel(j) noise];
                    for j=1:3
                        if indicatorSet(j)==0
                            show(j)=0;
                        end
                    end
                    set(findobj(btn_channel(channelorder(i)),'Tag', num2str(channelorder(i))),'BackgroundColor',show); 
                                   

                end
end