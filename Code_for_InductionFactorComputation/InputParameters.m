%% Kumara Raja E, 02-Jan-2023.
global radpersec2rpm rpm2radpersec
radpersec2rpm = 60/(2*pi);
rpm2radpersec = (2*pi)/60;
%% Switches and Flags
SwitchesAndFlags = struct( ...
    'switch_wind_type', 3, ... % 1: Uniform wind type    2: Turbulent wind type 3: Steady Wind with Vertical Shear
    'switch_rigid_tower', 1, ... % 1: Tower rigid   0: Tower flexible
    'switch_constant_rotor_speed', 0, ...  % 1: Rotor speed constant  0: Rotor speed from dynamics
    'switch_pitchrate_constraint', 1, ...  % 1:Pitch rate constraint ON  0:Pitch rate constraint OFF
    'switch_pitch_constraint', 1, ... % 1:Pitch constraint ON  0:Pitch constraint OFF
    'flag_region3', 0, ... % Initialization. (Always 0 here).
    'switch_anti_windup', 1,...    % Anti-wind up feature 0:OFF 1:ON
    'switch_generator_on', 1,...    % 0: Generator NOT connected to Rotor 1: Generator connected to Rotor
    'switch_pitch_controller_off', 0);     % 0: Pitch Controller ON  1: Pitch Controller OFF

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
% Reading blade geometry information
geom_airfoil = readtable( 'geom_airfoil.xlsx','Range','A2:D18','ReadVariableNames',false ); % This file contains 1:Radial distance of airfoil from center 2:chord of airfoil 3:twist 4:type of airfoil in order
dist_airfoil = (geom_airfoil.Var1)'; % (m)       distance of airfoil location from blade root
angle_twist_airfoil = 0*(geom_airfoil.Var2)'; % in deg
chord_airfoil = (geom_airfoil.Var3)'; % in meters
type_airfoil = (geom_airfoil.Var4)';

% Reading Aerodynamic coefficients data
AoA_table = readtable( 'AoATable.xlsx','Range','A1:A57','ReadVariableNames',false ); % Lift coefficient corresponding to the AoA
AoA_table = AoA_table.Var1;
CL_table = readtable( 'CL.xlsx','Range','A1:D57','ReadVariableNames',false ); % Angle of attack values (deg)
CL_table = [ CL_table.Var1 CL_table.Var2 CL_table.Var3 CL_table.Var4 ];
CD_table = readtable( 'CD.xlsx','Range','A1:D57','ReadVariableNames',false ); % Drag coefficient corresponding to the AoA
CD_table = [ CD_table.Var1 CD_table.Var2 CD_table.Var3 CD_table.Var4 ];

%% Parameters
Parameters = struct();

Parameters.WindTurbine = struct(...
    'no_of_blades', 3, ...                                                  % (-)       Number of blades
    'diameter',70);                                                         % (m)       Wind turbine diameter

Parameters.VelocityProfile= struct(...
    'ref_height', 84,...
    'power_law_exp', 1.5,...
    'wind_vel_at_hub_ht',11 );

Parameters.Blade = struct(...
    'mass', 4336, ...                           % (kg)      Mass of each blade
    'inertia','' , ...                           % (kg-m^2)  Inertia of each blade about rotor axis
    'initial_azimuth_blade1', 0, ...            % (deg)     Initial azimuthal position of the blade1
    'initial_pitch', 2.2);                        % (deg)     Initial pitch angle of all the blades

Parameters.Blade.Geometry = struct( ...
    'length', 33.25, ...                            % (m)       Blade length
    'no_of_airfoils', 17, ...                       % (-)       Number of airfoils in blade
    'distance_of_airfoil_from_blade_root', dist_airfoil, ...         % (m)       Distance of the airfoil location along the blade from the blade root
    'type_of_airfoil', type_airfoil, ...            % (-)       Type of Aifoil at different cross sections along the blade length
    'twist_of_airfoil', angle_twist_airfoil, ...    % (deg)     Angle of twist of the airfoil along blade length
    'chord_of_airfoil', chord_airfoil );            % (m)       Chord of airfoils located along the blade length

Parameters.Blade.AeroDyn = struct( ...
    'coeff_of_lift_table', CL_table, ...            % (-)       Table containing Lift coefficient of different airfoils along the blade length
    'coeff_of_drag_table', CD_table, ...            % (-)       Table containing Drag coefficient of different airfoils along the blade length
    'angle_of_attack_table', AoA_table );           % (deg)     Table containing angle of attack for which above coefficients are defined

Parameters.Hub = struct( ...
    'radius', 1.75, ...                             % (m)       Radius of the hub
    'mass', '', ...                                 % (kg)      Mass of hub
    'inertia', 29975 );                             % (kg-m^2)  Inertia of hub about rotor axis

Parameters.Nacelle = struct( ...
    'mass', 78055.766, ...                          % (kg)      Nacelle mass
    'inertia', '' );                                % (kg-m^2)  Nacelle inertia about rotor axis

Parameters.LowSpeeddShaft = struct( ...
    'inertia', 845.4 );                             % (kg-m^2)  Low speed shaft inertia about its own axis

Parameters.HighSpeeddShaft = struct( ...
    'inertia', '' );                                % (kg-m^2)  High speed shaft inertia about its own axis

Parameters.GearBox = struct( ...
    'gear_ratio', 87.965 );                         % (-)       Gear ratio of the gear box

Parameters.Generator = struct( ...
    'inertia', 56.442, ...                  % (kg-m^2)      Inertia of generator shaft
    'efficiency', 100, ...                  % (-)           Generator efficiency
    'constant', 0.0020868, ...
    'rated_speed', 1900, ...                % (Nm/rpm^2)    Generator torque constant
    'rated_torque', 7538.91835 );           % (Nm)      Rated torque

Parameters.Grid = struct( ...
    'height', 84, ...                       % (m)       Grid height
    'width', 84, ...                        % (m)       Grid width
    'no_of_gridpoints_alongY', 21, ...      % (-)       Number of grid points along Y
    'no_of_gridpoints_alongZ', 21, ...      % (-)       Number of grid points along Z
    'time_step_turbsim', 0.01 );            % (sec)     Time step used to generate Turbsim

Parameters.Miscellaneous = struct( ...
    'radPerSec2Rpm', 60/(2*pi), ...         % rad/s --> rpm   Unit conversion
    'rpm2RadPerSec', (2*pi)/60, ...         % rpm --> rad/s   Unit conversion
    'density_air', 1.225,...                % (kg/m^3)   Density of air
    'uniform_wind_velocity', 5);           % (m/s)     Wind velocity for the constant and uniform wind velocity

Parameters.Controller = struct( ...
    'time_pitch_control_ON', 0, ...         % (s)       Time when the pitch control should be activated
    'timeconstant_antiwindup', 0.05, ...       % (s)
    'gain_kp', 0.04, ...                   % (-)       Proportional gain
    'gain_ki', 0.025, ...                    % (-)       Integratal gain
    'gain_kd', 0);                          % (-)       Derivative gain

Parameters.Actuator = struct( ...
    'pitchrate_max', 8, ...                 % (deg/s)   Maximum pitch rate
    'pitch_low_limit', 2.2, ...             % (deg)     Lower limit on blade pitch angle
    'pitch_high_limit', 90, ...             % (deg)     Higher limit on blade pitch angle
    'pitch_optimal', 2.2 );                 % (deg)     Optimal pitch angle of blade

Parameters.Solver = struct(...
    'time_simulation',1, ...
    'time_step_simulation', 0.01, ...
    'initial_angular_speed_of_rotor', 10 );  % (rpm)     Initial angular speed of rotor

Parameters.EquivalentModel = struct( ...
    'mass_tower',107293.76 , ...            % (kg)      (33/144*M_twr + M_twrTop) Equivalent mass of tower
    'stiffness_tower', 735409.8, ...        % (N/m)     Equivalent stiffness of tower
    'damping_ratio_tower', 0.0);           % (-)

omega_init_rotor = Parameters.Solver.initial_angular_speed_of_rotor;

if SwitchesAndFlags.switch_pitch_controller_off
    Parameters.Controller.time_pitch_control_ON = 1E5;  % Set to a high value so that Pitch controller is OFF
end

