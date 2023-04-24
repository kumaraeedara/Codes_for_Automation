%% Kumara Raja E, 02-Jan-2023
%           **** Induction Factors and Inflow Angle Computation At Airfoil ****

% Output:
%   'Induction factors' at all the airfoils on each of the three blades.
%   'Inflow Angle' at all the airfoils on each of the three blades.

% Comments:
%   This function requires the functions:
%   1)  fun_InflowAngleUsingBEMT
%   2)  fun_InductionFactorUsingBEMT

% Note:---->
% 'Twist angle' and 'Pitch angle' are passed in as degress.

%%
function [ InductionFactorsAtAirfoils, InflowAngleAtAirfoils ] = ...
    fun_IndFact_InflowAng_AtAirfoils( ...
    Parameters, ...
    angle_pitch_commaded, ...
    state_current, ...
    WindVel )
%% Induction Factor calculation %%

global rpm2radpersec

no_of_airfoils = Parameters.Blade.Geometry.no_of_airfoils;
type_airfoil = Parameters.Blade.Geometry.type_of_airfoil;
angle_twist_airfoil = Parameters.Blade.Geometry.twist_of_airfoil;

loc_af_frm_hub_centr = ...
    Parameters.Blade.Geometry.distance_of_airfoil_from_blade_root + ...
    Parameters.Hub.radius;
vel_twr = state_current(1, 2);
omega_rotor = state_current(1, end);
chord_airfoil = Parameters.Blade.Geometry.chord_of_airfoil;
CL_table = Parameters.Blade.AeroDyn.coeff_of_lift_table;
CD_table = Parameters.Blade.AeroDyn.coeff_of_drag_table;

vel_wind_airfoil_B1 = WindVel*ones(1, no_of_airfoils);   %VelocityOfWindAtAirfoils.blade1;

phi_temp_B1 = atan2( vel_wind_airfoil_B1 , ...
    (loc_af_frm_hub_centr' .* omega_rotor) );

AxIndFactor_B1 = zeros( 1, no_of_airfoils );    % Initialization
TanIndFactor_B1 = zeros( 1, no_of_airfoils );   % Initialization

%% Blade01 Induction factor calculation

omega = omega_rotor;
pitch = deg2rad( angle_pitch_commaded );

for pp = 1 : no_of_airfoils
    qq = type_airfoil( pp );
    resid_tol = 1E-6;
    twist = deg2rad( angle_twist_airfoil(1, pp) );
    pitch_twist = pitch + twist; % rad
    radius_af = loc_af_frm_hub_centr(1, pp);
    chord_af = chord_airfoil(1, pp);
%     chord_af = 2.2690;
    Vx = vel_wind_airfoil_B1(1, pp); % wind velocity
    Vx = Vx - vel_twr;
    Vy = loc_af_frm_hub_centr(1, pp) * omega_rotor;
    phi = phi_temp_B1(1, pp);
    CL_table_local = CL_table(:, qq);
    CD_table_local = CD_table(:, qq);
    PhiStar1 = fun_InflowAngleUsingBEMT(  Parameters, pitch,twist, ...
        radius_af, ...
        chord_af,...
        CL_table_local, ...
        CD_table_local,...
        Vx, Vy );
    [ AxInd, TanInd ] = fun_InductionFactorsUsingBEMT( Parameters,...
        PhiStar1, pitch,twist,...
        radius_af, chord_af,...
        CL_table_local,...
        CD_table_local,...
        Vx, Vy  );
    AxIndFactor_B1(1, pp) = AxInd;
    TanIndFactor_B1(1, pp) = TanInd;
    InflowAngle_B1(1, pp) = PhiStar1;
end

AxialInductionFactors = struct( ...
    'blade1', AxIndFactor_B1   );

TangentialInductionFactors = struct( ...
    'blade1', TanIndFactor_B1 );

InductionFactorsAtAirfoils = struct( ...
    'axial',AxialInductionFactors, ...
    'tangential',TangentialInductionFactors );

InflowAngleAtAirfoils = struct( ...
    'blade1', InflowAngle_B1 );
end