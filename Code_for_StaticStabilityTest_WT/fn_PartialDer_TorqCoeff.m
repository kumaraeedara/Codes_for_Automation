%% Kumara Raja E, 11-May-2021
% Returns partial derivatives of the Torque coefficents with respect to
% pitch and tip speed ratio as look-up tables.
% PartDer_Cq_beta:- 
% Look-up table of Partial derivative of the aerodynamic torque coefficient
% (Cq) w.r.t pitch angle (beta).
% PartDer_Cq_lambda:- 
% Look-up table of Partial derivative of the aerodynamic torque coefficient
% (Cq) w.r.t tip speed ratio (lambda).
%%
function [ PartDer_Cq_beta, PartDer_Cq_lambda ] = ...
    fn_PartialDer_TorqCoeff( PitchAngle, TipSpeedRatio, Coeff_Torque )
    
    % Initialization
    PartDer_Cq_beta = zeros( length(TipSpeedRatio), length(PitchAngle) );
    PartDer_Cq_lambda = zeros( length(TipSpeedRatio), length(PitchAngle) );

    % Computation of partial derivative of Cq with respect to beta
    Delta_Cq_beta = Coeff_Torque(:, 2:end) - Coeff_Torque(:, 1:end-1); 
    Delta_beta = deg2rad( PitchAngle(2:end) - PitchAngle(1:end-1) );
    PartDer_Cq_beta( :, 1:end-1 ) = Delta_Cq_beta ./ Delta_beta';   
    
    % Computation of partial derivative of Cq with respect to lambda
    Coeff_Torque = Coeff_Torque';   % To perform difference between rows
    PartDer_Cq_lambda = PartDer_Cq_lambda'; % To perform difference between rows
    Delta_Cq_lambda = Coeff_Torque(:, 2:end) - Coeff_Torque(:, 1:end-1);
    Delta_lambda = TipSpeedRatio(2:end) - TipSpeedRatio(1:end-1);
    PartDer_Cq_lambda(:, 1:end-1) = Delta_Cq_lambda ./ Delta_lambda';
    PartDer_Cq_lambda = PartDer_Cq_lambda';
end