%% Kumara Raja E,04-June-2022
% Objective:
        % Read '****.out' file generated by OpenFAST and plot the variables
        % of interest in both time and frequency domain.
%%
OutputData = cell( length(OutputDataFileNames), 1 );    % Declaration/Initialization of variable (OutputData) as Cell for storing results

%%  Read "Output file(s)" of OpenFAST and store Output data in "cell array" OutputData
for rr = 1 : length( OutputDataFileNames )
    Output = readtable( OutputDataFileNames(rr), 'FileType',"text", 'HeaderLines',8, "ReadVariableNames",0 );
    Output = table2array( Output );
    OutputData {rr, 1 } = Output;
    clear Output
end

% Removing data corresponding to repeated variables
% % for rr = 1:length( OutputDataFileNames )
% %     for ss = 1:length(Indx_OutputVarRepeat)
% %         OutputData{rr}(:, Indx_OutputVarRepeat(ss)) = [];
% %     end
% % end

% Plot options
LineStyle = ['-', ':','--'];
switch swtchPlots_curr
    case 1  % Motion variable plots - Time domain
        for rr = 1:length( Indx_MotionOutputVar )
            figure
            for ss = 1:length(OutputDataFileNames)
                plot( OutputData{ss}(:,1),OutputData{ss}(:,Indx_MotionOutputVar(rr)),'LineWidth',2,'LineStyle',LineStyle(ss) )
                hold on 
            end
            xlabel('Time')
            ylabel(MotionOutputVar(rr)+" "+units_dict(MotionOutputVar(rr)) )
            legend('Flexible blades','Rigid blades') 
            xlim([lower_xlim upper_xlim])
            set(gca,'FontSize',12)
            if isKey( title_dict_motion, MotionOutputVar(rr) )
                title( title_dict_motion(MotionOutputVar(rr)) )
            else
                warning("EKR:No title for the plot")
            end
        end
        
    case 2  % Force variable plots - Time domain
        for rr = 1:length( Indx_ForceOutputVar )
            figure
            for ss = 1:length(OutputDataFileNames)
                plot( OutputData{ss}(:,1), OutputData{ss}(:,Indx_ForceOutputVar(rr)),'LineWidth',2,'LineStyle',LineStyle(ss) )
                hold on 
            end
            xlabel('Time')
            ylabel( ForceOutputVar(rr)+" "+units_dict(ForceOutputVar(rr)) )
            legend('Flexible blades','Rigid blades')
            xlim([lower_xlim upper_xlim])
            set(gca,'FontSize',12)
            if isKey( title_dict_force, ForceOutputVar(rr) )
                title( title_dict_force(ForceOutputVar(rr)) )            
            else
                warning("EKR:No title for the plot")
            end
        end
        
%% Plots in Frequency Domain
    case 3  % Motion plots - Frequency domain
        for rr = 1:length( Indx_MotionOutputVar )
            figure
            for ss = 1:length(OutputDataFileNames)
            [ data_fd, freq ] = pwelch( OutputData{ss}( T_1/DT:end, Indx_MotionOutputVar(rr) ),[],[],[],Fs,'onesided');
            plot( freq, 10*log10(data_fd), 'LineWidth', 2, 'LineStyle', LineStyle(ss) )
%             plot( freq, data_fd, 'LineWidth', 2, 'LineStyle', LineStyle(ss) )            
            hold on 
            end
            xlabel('Frequency (Hz)')
            ylabel( MotionOutputVar(rr)+" "+units_dict(MotionOutputVar(rr)) )
            legend('Flexible blades','Rigid blades')
            xlim([0 2.1])
            xticks([0:0.3:2.1])            
            set(gca,'FontSize',12)
            if isKey(title_dict_motion, MotionOutputVar(rr))
                title( title_dict_motion(MotionOutputVar(rr)) )
            else
                warning("EKR:No title for the plot")
            end
        end
        
    case 4  % Force plots - Frequency domain
        for rr = 1:length( Indx_ForceOutputVar )
            figure
            for ss = 1:length(OutputDataFileNames)
            [ data_fd, freq ] = pwelch( OutputData{ss}( T_1/DT:end, Indx_ForceOutputVar(rr) ),[],[],[],Fs,'onesided');
            plot( freq, 10*log10(data_fd), 'LineWidth', 2, 'LineStyle', LineStyle(ss) )
%             plot( freq, data_fd, 'LineWidth', 2, 'LineStyle', LineStyle(ss) )                    
            hold on
            end
            xlabel('Frequency (Hz)')
            ylabel( ForceOutputVar(rr)+" "+units_dict(ForceOutputVar(rr)) )
            legend('Flexible blades','Rigid blades')
            xlim([0 2.1])
            xticks([0:0.3:2.1])
            set(gca,'FontSize',12)
            if isKey( title_dict_force, ForceOutputVar(rr) )
                title( title_dict_force(ForceOutputVar(rr)) )                        
            else
                warning("EKR:No title for the plot")
            end
        end
end
% clear rr ss