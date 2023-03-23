%% Author: KUMARA RAJA E, 05-Sep_2022
% Function to calculate settling time
%%
% Warning:------->
    %   For the case of tower top displacement to be maximum in the
    %   negative direction, review the code.
%%
function [ overshoot, overshoot_percentage ] = fun_Overshoot( ...
                                                steady_state_value, ...
                                                input_signal, ...
                                                flag_ignore_endpoint)
% Changing input data as a single row
if ~isrow(input_signal)
    input_signal = input_signal';
end

if flag_ignore_endpoint
    input_signal = input_signal(1, 1:end-1);    % Last two points of the data is ignored
end

for ii = 1:length(input_signal)
    if any( input_signal >= steady_state_value ) % Compare if all the elements of the row are less than the settling limit value
        overshoot = ( max( input_signal ) - steady_state_value )/ steady_state_value;
        overshoot_percentage = 100*overshoot/steady_state_value;
    else % For overdamped case like behavior, no overshoot exists.
        overshoot = 0;
        overshoot_percentage = 0;
    end
end