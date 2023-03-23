%% Kumara Raja E, 11-May-2021
% Gives the linearized system as output.
    % Par: Parameters of the turbine
    % WindVel: Velocity of the wind
    % RotSpd: Rotor speed  (NOT GENERATOR SPEED)
    % Pitch: Blade pitch (deg)
function [ der_AeroTorq_omega, der_AeroTorq_beta, der_AeroTorq_V ] = ...
    fn_LinearizedModel_WT(  WindVel, TSR, Pitch, Par, ...
                                PitchAngle,...
                                TipSpeedRatio,...
                                Coeff_Torque,...
                                PartDer_Cq_beta, ...
                                PartDer_Cq_lambda )
%% Turbine parameters
    Rho = Par.Dens;     % kg/m^3
    R = Par.Radius;     % m
    A = pi*R^2;         % m^2
    N = Par.GearRatio; 
    I = Par.Inertia;    % kg-m^2

%% Operating point
    V_op = WindVel;        % m/s
%     Omega_op = RotSpd * pi/30;  % convert from RPM to rad/s
    beta_op = Pitch;       % Deg
    lambda_op = TSR;
    Omega_op = lambda_op * V_op / R;

    Cq_op = interp2(    PitchAngle, TipSpeedRatio, Coeff_Torque, ...
                        beta_op, lambda_op );
    der_Cq_lambda = interp2( PitchAngle, TipSpeedRatio, PartDer_Cq_lambda,...
                             beta_op, lambda_op );
    der_Cq_beta = interp2(  PitchAngle, TipSpeedRatio, PartDer_Cq_beta, ...
                            beta_op, lambda_op );

%% Constants defined to make formulae look simple
    C1 = 0.5*Rho*A*V_op^2*R*Cq_op;  % This is thrust at the operating point;
    C2 = Cq_op/lambda_op;
    C3 = Cq_op/beta_op;

%% Linearized model
    der_AeroTorq_omega = ( C1/Omega_op * der_Cq_lambda/C2 )/I;    % A
    der_AeroTorq_beta = ( C1/beta_op * der_Cq_beta/C3 )/I;   % B
    der_AeroTorq_V = ( C1/V_op * ( 2 - der_Cq_lambda/C2) )/I; % C
end