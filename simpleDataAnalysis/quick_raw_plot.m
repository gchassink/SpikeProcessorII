% unique(Cs)
% reeks=unique(Cs);
% Tsmin6=Ts;%-(6*25);
% for i=1:length(reeks)
%     test=Tsmin6(Cs==reeks(i));
%     hit=find(diff(test)/25==6);
%     if ~isempty(hit)
%     reeks(i)
%     disp(num2str((mod(test(hit),(25*25))/25)));
%     disp(num2str((mod(test(hit +1),(25*25))/25)));
%    
%     end
% 
% end
% figure;plot((1:size(Raw,2))/25,Raw(2,:));
% hold on
% plot((Ts(Cs==88)/25)-(25+6),-100,'o');



figure;

for i =1: size(Raw,1)

    %     if FileInfo.channelorder(i)==61 || FileInfo.channelorder(i)==12 || i==2
    %         plot((1:size(Raw,2))/double(FileInfo.Samplerate),Raw(i,:)+(250*i))%,'LineWidth',2) ;
    %     else
    %         %plot((1:size(Raw,2))/double(FileInfo.Samplerate),Raw(i,:)+(250*i)) ;
    %     end
    
    %if ~isempty(Ts(Cs==FileInfo.channelorder(i)))
        spike=Ts(Cs==FileInfo.channelorder(i));
        if ~isempty(spike) 
            
        
            plot((1:size(Raw,2)),Raw(i,:)+(250*i))
            hold on
            plot(double((spike)), i*250, 'o');
            hold on
            pause(0.1)
        end
            

%             for j =1+625:625:size(Raw,2)
%                 %if j>spike(k) && (j-625-625-625)<spike(k)
%                     plot((j-625:j)/double(FileInfo.Samplerate),Raw(i,j-625:j)+(250*i));
%                     hold on
%                 %end
%             end

        
    end
     plot((1:size(Raw,2)),Raw(2,:)-250); hold on
    plot(Ts(Cs==88), -250, 'o');



%plot(double(Det88)/double(FileInfo.Samplerate),100,"o");