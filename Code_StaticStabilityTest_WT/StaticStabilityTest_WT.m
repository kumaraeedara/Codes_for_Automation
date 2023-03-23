%% Kumara Raja E, 10-June-2021
% This code returns whether turbine is statically stable or not about the 
% given operating based on the linearized model.

% Required Functions:
    % fn_OperatingPts_Cp:- 
        % Returns the (pitch, tsr) values for a given Cp value.    
    % fn_LinearizedModel_WT.m:-
        % Returns A, B, C in the equation,x_dot = Ax+Bu+Cw.
    % fn_PartialDer_TorqCoeff.m:-
        % Function "LinearizedModel_WT" calls this.

% Results "stable_op","unstable_op","LinModel" are stored as structures.
% Use dot (.) operation to get access the data.
% Caution:---->
        % If generator torque is not constant the linearized model used may
        % not be valid. Check the equations.
%%
clear all
close all
clc
%% ------------Parameters of the wind turbine------------%%
Par = struct;
Par.Dens = 1.225;     % kg/m^3
Par.Radius = 35;     % m
Par.GearRatio = 87.965; 
Par.Inertia = 2962443.500;    % kg-m^2 (Only Rotor inertia, Do NOT include Generator inertia)

%% 
load PowerCurve_Flex_Grav_WP1500kW.mat

%% ------------  Rotor speed (RPM) to TSR conversion (DO NOT DELETE)---%%
%  Uncomment this block of code to calculate Tip speed ratio, 
%  when rotor speed and wind velocity are available as inputs.

% % rotspeed_list = []; % RPM
% % rotspeed_list = [] * pi/30; % RPM to  rad/s
% % WindVel_list = ones( length(rotspeed_list), 1 );
% % if length( WindVel_list ) ~= length( rotspeed_op_list )
% %     disp( [  'Length of the "wind vel list" and "rotor speed list"',...
% %                   'must be same, but they are NOT. CHECK AGAIN' ]);
% %     return
% % end
% % TSR_list = Par.Radius * rotspeed_op_list ./ WindVel_list ;

%% ---- Pitch and Tip speed Ratio values corresponding to a given Cp --- 

% % levels_Cp = [   0.479086758 0.368260778 0.289647075 0.231907662 0.188549518 ...
% %                 0.155360016 0.129524654 0.109114305 0.092776589 0.079544328 ]';

level_Cp = 0.368260778;    % Desired Cp value
[ Pitch_list, TSR_list, num_branch ] = fn_OperatingPts_Cp(  ...
                                                    level_Cp, ...
                                                    PitchAngle, ...
                                                    TipSpeedRatio, ...
                                                    Coeff_Power );
WindVel_list = ones( length(Pitch_list), 1 ); 

if length( WindVel_list ) == length( Pitch_list ) && ...
   length( TSR_list ) == length( Pitch_list )

% ------------- Stability Calculation----------------%
    [ stable_op, unstable_op, LinModel ] = ...
                                            fn_StaticStabilityTest_WT( ...
                                                        WindVel_list, ...
                                                        Pitch_list, ...
                                                        TSR_list, ...
                                                        Par, ...
                                                        PitchAngle,...
                                                        TipSpeedRatio,...
                                                        Coeff_Torque );
else
    disp([ 'Size of the "wind velocity", "TSR velocty", "Pitch velocity"',...
           'should be same, but they are not. CHECK Again.']);
    return
end
%% plots
scatter(stable_op.pitch,stable_op.TSR,'Marker','.','SizeData',56)
hold on
scatter(unstable_op.pitch,unstable_op.TSR,'Marker','.','SizeData',56)
xlabel('Pitch (deg)')
ylabel('TSR')
legend('Stable','Unstable')