%% Author: Kumara Raja E, 20-sep-2022
    % Code for finding optimal gains
    % Matlab output files ('*.mat') for different simulations are loaded
    % and Optmial gains based on different criteria are found.
    % Plots contour plots for different results.
%%    
clear all
close all
clc
%%
output_files_path = 'E:\PhD_WT\WP1500KW_2022\AeroElasticModel\OwnModel_OwnCont\BL01_201';
output_file_list = dir( append( output_files_path,'\*mat' ) );

%%
time_start = 0;
time_duration_of_windstep = 40;
time_step_of_data = 0.01;
time_end = 400;
time_list = time_start : time_duration_of_windstep : time_end;
windspeed_list = 11:1:20;
disp_at_steadystate = [ 0.2968 0.2185 0.1913 0.1757 0.1639 0.1541 0.1461 ...
                        0.1394 0.1338 0.1287 ];     % These are obtained from the analysis

if ~( length( windspeed_list ) == length( disp_at_steadystate ) )
    warning(['EKR!Not provided steady state displacements for all ', ...
                'the wind speeds']);
    return
end

flag_ignore_endpoint = 0;   % binary variable
%%
for ii_file = 1 : length( output_file_list )
    res = load( output_file_list(ii_file).name );
    Kp_list( ii_file, 1 ) = res.Parameters.Controller.gain_kp;
    Ki_list( ii_file, 1 ) = res.Parameters.Controller.gain_ki;
    Kd_list( ii_file, 1 ) = res.Parameters.Controller.gain_kd;
    
    % Settling time calculations based on the tower top displacement
    for ii_windspeed = 1:length( windspeed_list )       % Wind speed loop
        % Tower displacement
        input_signal = res.displacement_of_towertop;
        steady_state_value = disp_at_steadystate( 1, ii_windspeed );
        llimit_for_settling = steady_state_value - 0.02*steady_state_value;
        ulimit_for_settling = steady_state_value + 0.02*steady_state_value;
        no_of_steps_lower = max( time_list(1, ii_windspeed)/time_step_of_data, 1 );   % To avoid '0' in the index
        no_of_steps_upper = time_list( 1, ii_windspeed+1 ) / time_step_of_data;
        input_signal = input_signal( no_of_steps_lower : no_of_steps_upper, 1 );

        [ settling_time_inst, flag_settled_inst ] = fun_SettlingTime( ...
                                                        time_step_of_data, ...
                                                        llimit_for_settling, ...
                                                        ulimit_for_settling, ...
                                                        input_signal, ...
                                                        flag_ignore_endpoint );
        settling_time( ii_file, ii_windspeed ) = settling_time_inst;
        flag_settled( ii_file, ii_windspeed ) = flag_settled_inst;

    % "Overshoot" of tower top displacement calculation 
        [ overshoot_inst, ...
          overshoot_percentage_inst ] = ...
        fun_Overshoot( ...
            steady_state_value, ...
            input_signal, ...
            flag_ignore_endpoint );
        
        overshoot( ii_file, ii_windspeed ) = overshoot_inst;
        overshoot_percentage( ii_file, ii_windspeed ) = ...
            overshoot_percentage_inst;
        
    % Pitch cycle count
        llim = max( time_list(1, ii_windspeed)/time_step_of_data, 1 );   % To avoid '0' in the index
        ulim = llim + ceil( settling_time(1, ii_windspeed )/time_step_of_data );
        input_signal = res.angle_pitch_of_blade1( llim:ulim, 1 );
        [ pitch_cycle ] = fun_PitchCycles( input_signal );
        pitch_cycles( ii_file, ii_windspeed ) = pitch_cycle;
        
    % L2-norm of error in power signal (Error:= Power - rate power)
        llim = max( time_list( ii_windspeed )/time_step_of_data, 1 );
        ulim = time_list( ii_windspeed+1 )/time_step_of_data;
        input_signal = res.power_generator( llim:ulim, 1 );   % W
        input_signal = 1.0E-6*input_signal;    % MW
        rated_power = 1.5; % MW
        normL2_error_generator_power( ii_file, ii_windspeed ) = norm( ...
                                        input_signal - rated_power );
                                
        % Generator speed (RPM)
        input_signal = res.angular_speed_of_generator;
        steady_state_value = 1900;
        llimit_for_settling = steady_state_value - 0.02*steady_state_value;
        ulimit_for_settling = steady_state_value + 0.02*steady_state_value;
        no_of_steps_lower = max( time_list(1, ii_windspeed)/time_step_of_data, 1 );   % To avoid '0' in the index
        no_of_steps_upper = time_list( 1, ii_windspeed+1 ) / time_step_of_data;
        input_signal = input_signal( no_of_steps_lower : no_of_steps_upper, 1 );

        [ settling_time_inst, flag_settled_inst ] = fun_SettlingTime( ...
                                                        time_step_of_data, ...
                                                        llimit_for_settling, ...
                                                        ulimit_for_settling, ...
                                                        input_signal, ...
                                                        flag_ignore_endpoint );
                                                    
        settling_time_genspd( ii_file, ii_windspeed ) = settling_time_inst;
        flag_settling_time_genspd( ii_file, ii_windspeed ) = flag_settled_inst;
    end         % END of Wind speed loop
    
    if any( flag_settled( ii_file, : )== 0 )
        flag_settled_at_all_windspeeds( ii_file, 1 ) = 0;
    else
        flag_settled_at_all_windspeeds( ii_file, 1 ) = 1;
    end
    
    if any( flag_settling_time_genspd(ii_file, :)) == 0
        flag_settled_genspd_at_all_windspeeds(ii_file, 1) = 0;
    else
        flag_settled_genspd_at_all_windspeeds(ii_file, 1) = 1;
    end
    clear res
end     % END of Files loop iteration (i.e Kp,Ki combinations)
table_output = table(   Kp_list, ...
                        Ki_list, ...
                        settling_time, ...
                        overshoot_percentage, ...
                        normL2_error_generator_power, ...
                        pitch_cycles );
%% Contour plot
kp_set = unique( Kp_list, 'stable' );
ki_set = unique( Ki_list, 'stable' );
[ ki_grid, kp_grid ] = meshgrid( ki_set, kp_set );  % Mesh grid:Kp_set rows, Ki_set colums

settling_time_grid = reshape( settling_time(:,4), ...
                                length(kp_set), length(ki_set) ); % Kp-set rows; Ki-set colums

overshoot_percentage_grid = reshape( overshoot_percentage(:,2), ...
                                       length(kp_set), length(ki_set) ); % Kp-set rows; Ki-set colums

pitch_cycles_grid = reshape( pitch_cycles(:,2), ...
                                length(kp_set), length(ki_set) );   % Kp-set rows; Ki-set colums

normL2_error_generator_power_grid = reshape(...
                                        normL2_error_generator_power(:,2), ...
                                        length(kp_set), length(ki_set) );
                                    
settling_time_genspd_grid = reshape( settling_time_genspd(:,2), ...
                                length(kp_set), length(ki_set));

flag_settled_genspd_at_all_windspeeds_grid = reshape( ...
                                    flag_settled_genspd_at_all_windspeeds,...
                                    length(kp_set), length(ki_set) );

%% Results based on original grid
% Tower top displacement
% Settling time 
[ contourMatrix, contourObj ] = contourf( ki_grid, kp_grid, ...
                                            settling_time_grid );
grid on
contourObj.LevelList = [ 10:2:40 ];
contourObj.LineStyle = "none";
xlabel('K_I')
ylabel('K_P')
xlim([0.01 0.1])
xticks([0.01:0.015:0.1])
ylim([0.01 0.1])
yticks([0.01:0.015:0.1])
[ colorbarObj ] = colorbar;
colorbarObj.Limits = [10 40];
colorbarObj.FontSize = 14;
set(gca,'FontSize',14)

% Overshoot percentage
[ contourMatrix, contourObj ] = contourf( ki_grid, kp_grid, ...
                                            overshoot_percentage_grid );
grid on
contourObj.LevelList = [ 100:25:400 ];
contourObj.LineStyle = "none";
xlabel('K_I')
ylabel('K_P')
xlim([0.01 0.1])
xticks([0.01:0.015:0.1])
ylim([0.01 0.1])
yticks([0.01:0.015:0.1])
[ colorbarObj ] = colorbar;
colorbarObj.Limits = [100 400];
colorbarObj.FontSize = 14;
set(gca,'FontSize',14)

% Generator angular speed
% Settling time
[ contourMatrix, contourObj ] = contourf( ki_grid, kp_grid, ...
                                    settling_time_genspd_grid );
grid on
contourObj.LevelList = [ 0:0.5:8 ];
contourObj.LineStyle = "none";
xlabel('K_I')
ylabel('K_P')
xlim([0.01 0.1])
xticks([0.01:0.015:0.1])
ylim([0.01 0.1])
yticks([0.01:0.015:0.1])
[ colorbarObj ] = colorbar;
colorbarObj.Limits = [0 8];
colorbarObj.FontSize = 14;
set(gca,'FontSize',14)

%
[ contourMatrix, contourObj ] = contourf( ki_grid, kp_grid, ...
                                    flag_settled_genspd_at_all_windspeeds );
grid on
contourObj.LevelList = [ 100:25:400 ];
contourObj.LineStyle = "none";
xlabel('K_I')
ylabel('K_P')
xlim([0.01 0.1])
xticks([0.01:0.015:0.1])
ylim([0.01 0.1])
yticks([0.01:0.015:0.1])
[ colorbarObj ] = colorbar;
colorbarObj.Limits = [100 400];
colorbarObj.FontSize = 14;
set(gca,'FontSize',14)

% Generator power
[ contourMatrix, contourObj ] = contourf( ki_grid, kp_grid, ...
                                        normL2_error_generator_power_grid );
grid on
contourObj.LevelList = [ 0:0.5:3 ];
contourObj.LineStyle = "none";
xlabel('K_I')
ylabel('K_P')
xlim([0.01 0.1])
xticks([0.01:0.015:0.1])
ylim([0.01 0.1])
yticks([0.01:0.015:0.1])
[ colorbarObj ] = colorbar;
colorbarObj.Limits = [0 3];
colorbarObj.FontSize = 14;
set(gca,'FontSize',14)
                                    
% Pitch activity
[ contourMatrix, contourObj ] = contourf( ki_grid, kp_grid, ...
                                          pitch_cycles_grid );
grid on
contourObj.LevelList = [ 0:1:8 ];
contourObj.LineStyle = "none";
xlabel('K_I')
ylabel('K_P')
xlim([0.01 0.1])
xticks([0.01:0.015:0.1])
ylim([0.01 0.1])
yticks([0.01:0.015:0.1])
[ colorbarObj ] = colorbar;
colorbarObj.Limits = [0 8];
colorbarObj.FontSize = 14;
set(gca,'FontSize',14)

%% Results from a refined grid
% Calculation of the above calculation on a finer grid using interpolation
% from the original data Generating refined mesh grid
kp_set_refine =  min( kp_set ) : 0.015 : max( kp_set );
ki_set_refine =  min( ki_set ) : 0.015 : max( ki_set );
[ ki_grid_fine, kp_grid_fine ] = meshgrid( ...
                                    ki_set_refine, ...
                                    kp_set_refine );  % Kp set rows, Ki set columns

% Finding the parameter values at the refined grid through interpolation
[ settling_time_grid_fine ] = griddata( ki_grid, kp_grid, ...
                                        settling_time_grid,...
                                        ki_grid_fine,...
                                        kp_grid_fine );

[ overshoot_percentage_grid_fine ] = griddata( ki_grid, kp_grid, ...
                                               overshoot_percentage_grid,...
                                               ki_grid_fine,...
                                               kp_grid_fine );
                                           
[ normL2_error_generator_power_grid_fine ] = griddata( ki_grid, kp_grid, ...
                                        normL2_error_generator_power_grid, ...
                                                        ki_grid_fine, ...
                                                        kp_grid_fine );
                                   
[ pitch_cycles_grid_fine ] = griddata( ki_grid, kp_grid, ...
                                       pitch_cycles_grid,...
                                       ki_grid_fine,...
                                       kp_grid_fine );

[ flag_settled_at_all_windspeeds_grid ] = reshape(  ...
                                            flag_settled_at_all_windspeeds,...
                                            length(kp_set), ...
                                            length(ki_set) );
                                        
%% Plots
ll = 0.01;
ul = 0.10;
ticks_size = 0.015;

[M, c] = contourf( kp_grid_fine, ki_grid_fine, settling_time_grid_fine );
view ([0 0 90]) % X-Y view
colorbar
xlim([ll ul])
xticks([ll:ticks_size:ul])
xlabel('K_I')
ylim([ll ul])
yticks([ll:ticks_size:ul])
ylabel('K_P')
title('Settling time of tower top displacement (s)')

figure
[M, c] = contourf( kp_grid_fine, ki_grid_fine, overshoot_percentage_grid_fine);
view ([0 0 90]) % X-Y view
colorbar
xlim([ll ul])
xticks([ll:ticks_size:ul])
xlabel('K_I')
ylim([ll ul])
yticks([ll:ticks_size:ul])
ylabel('K_P')
title('Percentage peak overshoot of tower top displacement')

figure
[M, c] = contourf( kp_grid_fine, ki_grid_fine, pitch_cycles_grid_fine )
view ([0 0 90]) % X-Y view
colorbar
xlim([ll ul])
xticks([ll:ticks_size:ul])
xlabel('K_I')
ylim([ll ul])
yticks([ll:ticks_size:ul])
ylabel('K_P')
title('Count of pitch cycles')

figure
[ M, c ] = contourf( kp_grid_fine, ki_grid_fine, ...
                        normL2_error_generator_power_grid_fine );
view ([0 0 90]) % X-Y view
colorbar
xlim([ll ul])
xticks([ll : ticks_size : ul])
xlabel('K_I')
ylim([ll ul])
yticks([ll : ticks_size : ul])
ylabel('K_P')
title('L_2 norm of generator power error')

figure
[M, c] = contourf( kp_grid, ki_grid, ...
                    flag_settled_at_all_windspeeds_grid );
view ([0 0 90]) % X-Y view
colorbar
xlim([ll ul])
xticks([ll : ticks_size : ul])
xlabel('K_I')
ylim([ll ul])
yticks([ll : ticks_size : ul])
ylabel('K_P')
title('Flag indiacating settling across all wind speeds')