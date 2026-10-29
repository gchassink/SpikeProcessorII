%% Sr=writedata(Ts,Cs,Us,Ns)
% Appends timestamp data to a matfile and returns stimulus repsonses if
% applicable
% Ts: array with timestamps
% Cs: array with channelnumbers corresponding to the timestamps
% Us: matrix with waveshapes of the recorded spike.
% Ns: matrix with the noise values for the corresponding channel.
% fname: name of the matfile.
% Sr: stimulus reponses. The reason to calculate it here is that this saves
% the resources for opening anothre matfile instance to read them.
function Sr=write_data(Ts,Cs,Us,Ns)
global System FileInfo 
    
    
    Sr=[];
    mat = matfile(FileInfo.Name,'Writable',true);
    % be aware, mat.FileInfo is only written at initiation of a new file
    % mat.FileInfo=FileInfo; % writing fileInfo every second is too heavy
   
    %Length of Ts, Cs and Us are the same, both in memory and in the matfile.
    index=length(mat.Ts);
    [m,n]=size(Us);
    if (~isempty(Ts)) mat.Ts(index+1:index+m,1)=Ts(:,1);  end
    if (~isempty(Cs)) mat.Cs(index+1:index+m,1)=Cs(:,1); end
    if (~isempty(Us)) mat.Us(index+1:index+m,1:n)=Us(:,:); end
    if (~isempty(Ns)) mat.Ns(index+1:index+m,1)=Ns(:,1); end
    
    %% calculate stimulus response curves and store them
    % it is placed here to save resources to open another matfile session
    if FileInfo.adaptertype=="Mea2100"
    
        CsStimIndex=find(mat.Cs==88); % check if the were stimulations 289
    else
        CsStimIndex=find(mat.Cs==289); % check if the were stimulations 289
    end
    % we could consider to invoke this a subrtoutine for script clarity
    if size(System.Sr,1)<length(CsStimIndex) && ...
            FileInfo.testButtonWasPressed~=1 && ...
            ~isfield (System, 'electrode_list')
        range=CsStimIndex( size(System.Sr,1)+1:length(CsStimIndex) );
        SrCalcIndex=find( mat.Ts(range,1) < (FileInfo.RecordingTime - System.edges(end)) );  % take only response curves when last timepoint of set response window has passed
        if length(SrCalcIndex)>=1
            for i=1:length(SrCalcIndex)
                Sr(i,:)=histcounts(mat.Ts(:,1), System.edges+mat.Ts(range(SrCalcIndex(i)),1) ); %stores histograms in Sr
                % Be aware, this will also take into account timestamps from 
                % channel 88 (the stimulation log)!
            end
  
        end
        
    end

% store stimulus response as processed data       
    SrIndex=size(mat.Sr,1);
    [o,p]=size(Sr);
    if (~isempty(Sr)) mat.Sr(SrIndex+1:SrIndex+o,1:p)=Sr(:,:); end
% store temperature readings   
    TcIndex=size(mat.Tc,1);
    [q,r]=size(FileInfo.TemperatureLog);
    if (~isempty(FileInfo.TemperatureLog)) mat.Tc(TcIndex+1:TcIndex+q,1:r)=FileInfo.TemperatureLog(:,:); end

end