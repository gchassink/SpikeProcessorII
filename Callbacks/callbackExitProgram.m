function callbackExitProgram(src,event)
    % Close request function 
    % to display a question dialog box 
    global System Figures
    selection = questdlg('Close SpikeProcessorII ?', ...
        'Close Request Function', ...
        'Yes','No','Yes'); 
    switch selection 
        case 'Yes'
            System.exit = 1;
            set(gcf, 'CloseRequestFcn', 'closereq', 'CreateFcn', '');% reset windows close button for this figure
            %set(Figures.fig, 'CloseRequestFcn', 'closereq', 'CreateFcn', '');% reset windows close button for this figure
            %delete(Figures.fig)
            return
        case 'No'
            return 
    end
end