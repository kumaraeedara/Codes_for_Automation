%% AUTHOR: KUMARA RAJA E, 05-Sep_2022
% Function to calculate settling time
%%
function [ settling_time, flag_settled ] = fun_SettlingTime( ...
                                            time_step_of_data, ...
                                            llimit_for_settling, ...
                                            ulimit_for_settling, ...
                                            input_signal, ...
                                            flag_ignore_endpoint )
flag_settled = 0;                                  
% Changing input data as a single row
if ~isrow(input_signal)
    input_signal = input_signal';
end

if flag_ignore_endpoint
    input_signal = input_signal(1, 1:end-1);    % Last data point is ignored
end

for ii = 1:length(input_signal)
    if all( input_signal(1, ii:end) >= llimit_for_settling ) && all( input_signal(1, ii:end) <= ulimit_for_settling ) % Compare if all the elements of the row are less than the settling limit value
        settling_time =(ii - 1)*time_step_of_data;
        flag_settled = 1;
        break;
    end
end
if flag_settled == 0    % Error message for signal not settled and assigning a default value
    warning('EKR!Signal has NOT settled as per the limits set.');
    warning('EKR!Settling time is set to an arbitrary large value');
    settling_time = ii*time_step_of_data;
end