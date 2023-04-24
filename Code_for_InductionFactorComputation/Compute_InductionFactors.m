%% Author: Kumara Raja
% To generate Induction Factors (Axial and Tangential) for the given
% operating conditions ( Pitch angle, Rotor speed, Wind Velocity).
% NOTE:-
%   The induction factor computations used here are validated with
%   OpenFAST. The indction factors generated here are later used for
%   generating lookup table.
%
%%
clear all
close all
clc

run InputParameters.m

counter = 0;

PitchAng_llim = -20;  % deg     Lower limit of the pitch angle
PitchAng_ulim = 40;   % deg     Upper limit of the pitch angle
PitchAng_step = 0.5;  % deg     Pitch angle step

RotSpd_llim = 0;    % RPM       Lower limit of the Rotor speed
RotSpd_ulim = 40;   % RPM       Upper limit of the Rotor speed
RotSpd_step = 0.5;    % RPM     Rotor speed step

WindVel_llim = -5;   % m/s      Lower limit of the Wind velotiy
WindVel_ulim = 30;  % m/s       Upper limit of the Wind velotiy
WindVel_step = 0.5;   % m/s     Wind velocity step

count_PitchAng = 0;
for PitchAng = PitchAng_llim : PitchAng_step : PitchAng_ulim
    count_PitchAng = count_PitchAng + 1
    PitchAng_list( count_PitchAng, 1 ) = PitchAng;
    
    count_RotSpd = 0;
    for RotSpd = RotSpd_llim : RotSpd_step : RotSpd_ulim
        count_RotSpd = count_RotSpd + 1;
        RotSpd_list( count_RotSpd, 1 ) = RotSpd;
        states = [ 0 0 RotSpd*rpm2radpersec];     % [twrDisp twrVel RotSpd]
        
        count_WindVel = 0;
        for WindVel = WindVel_llim : WindVel_step : WindVel_ulim
            count_WindVel = count_WindVel + 1;
            counter = counter + 1;
            WindVel_list( count_WindVel, 1 ) = WindVel;
            
            [ InductionFactorsAtAirfoils, InflowAngleAtAirfoils ] = ...
                fun_IndFact_InflowAng_AtAirfoils( ...
                Parameters, ...
                PitchAng, ...
                states, ...
                WindVel );
            
            AxialInductionFactorsTable( counter, : ) = ...
                InductionFactorsAtAirfoils.axial.blade1;
            TanInductionFactorsTable( counter, : ) = ...
                InductionFactorsAtAirfoils.tangential.blade1;
        end     % Wind Velocity Loop
    end     % Rotor Speed Loop
end     % Pitch angle Loop
save InductionFactorsLookupTable