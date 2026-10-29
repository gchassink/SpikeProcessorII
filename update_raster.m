%% Raster = update_raster(Raster,Cs,rasterlayout,display)
% Adds a new line to the rasterplot when function is called, with spikes at channels Cs.
% Rasterlayout is the order of channels displayed in the plot.
% Displays the raster
function Raster = update_raster(Raster,Cs,rasterlayout,display)
hold off    
if isempty(Raster)
        Raster=ones(3*(length(rasterlayout))+3,600);
    end
    nextline=ones(3*(length(rasterlayout))+3,2);% every datapoint is 3 dots high 60 + 1(stim)=183
    for i=1:length(Cs) % every Cs in 1 second
        Channel=find(rasterlayout==Cs(i)); % --> so follows raster layout NOT channelorder!
        if nextline(Channel*3,1)==1
            nextline(Channel*3-2:Channel*3,1:2)=ones(3,2)*0.9;
        else
            nextline(Channel*3-2:Channel*3,1:2)=ones(3,2)*nextline(Channel*3,1)*0.9;
            % the more active the more close to zero
        end
    end
    Raster(:,1:2)=[];
    Raster(:,599:600)=nextline;
    if (display==1)
%         channelsFrom=((floor(8/12))*12*3)+1;
%         channelsTo=(ceil(8/12))*12*3;
%         imshow(Raster(channelsFrom:channelsTo,:)); % faster than plot or other
        imshow(Raster);%daspect auto;% pbaspect(stretch_to_fill);
        
    end
end