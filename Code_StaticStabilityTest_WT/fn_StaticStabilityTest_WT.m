%% Kumara Raja E, 20-May-2021
% This code returns whether turbine is statically stable about the given
% operating point or not based on the linearized model.

% Required Functions:
    % LinearizedModel_WT.m: Returns A, B, C in the equation,x_dot = Ax+Bu+Cw;
    % PartialDer_TorqCoeff.m: Function "LinearizedModel_WT" calls this.

% Equations: (are derived in Pg:91,92 Research Note book 02).
    % I*Omega_dot = Ta-Tg;
    % Ta = 0.5*Rho*A*Omega^2*Cq(lambda, beta); Tg = K*Omega^2;
% Tg is assumed constant and linearization performed. That means, this
% lineariztion is valid only for the above rated wind speed where this
% assumption is valid.

% Interpretation of results:
    % If LinModel.A is negative, it means the system is statically stable with respect to 
    % rotor speed about that operating point. Meaning, if a small perturbation 
    % is given to the rotor speed, it will restore to the original speed upon 
    % removal of it. Note that this disturbance should be a short lived and NOT 
    % a persistance one.

% Caution:---->
        % If generator torque is not constant relook at the linearized
        % equations.
%%
function [ stable_op, unstable_op, LinModel ] = ...
                                        fn_StaticStabilityTest_WT( ...
                                                    WindVel_list, ...
                                                    Pitch_list, ...
                                                    TSR_list, ...
                                                    Par, ...
                                                    PitchAngle,...
                                                    TipSpeedRatio,...
                                                    Coeff_Torque ) 
    cnt_unstable = 0;   % Counter for unstable operating points
    cnt_stable = 0;   % Conter for stable operating points

    stable_op = struct();
    unstable_op = struct();
    LinModel = struct();

    if length( WindVel_list ) == length( Pitch_list ) && ...
       length( TSR_list ) == length( Pitch_list )

        [ PartDer_Cq_beta, PartDer_Cq_lambda ]  = ...
                            fn_PartialDer_TorqCoeff( ...
                                                        PitchAngle,...
                                                        TipSpeedRatio,...
                                                        Coeff_Torque );

%% Calculation of the stability by calling the necessary functions
    for ii = 1:length( Pitch_list )
        WindVel_op = WindVel_list( ii, 1 );
        Pitch_op = Pitch_list( ii, 1 );
        TSR_op = TSR_list( ii, 1 );
        [ AA, BB, CC ] = fn_LinearizedModel_WT(     WindVel_op, ...
                                                    TSR_op,...
                                                    Pitch_op,...
                                                    Par, PitchAngle,...
                                                    TipSpeedRatio,...
                                                    Coeff_Torque, ...
                                                    PartDer_Cq_beta, ...
                                                    PartDer_Cq_lambda );
         A( ii, 1 ) = AA;
         B( ii, 1 ) = BB;
         C( ii, 1 ) = CC;

         if AA >= 0
             cnt_unstable = cnt_unstable + 1;
             unstab_pitch( cnt_unstable, 1 ) = Pitch_op;
             unstab_TSR( cnt_unstable, 1 ) = TSR_op;
             unstab_windvel( cnt_unstable, 1 ) = WindVel_op;
         else
             cnt_stable = cnt_stable + 1;
             stab_pitch( cnt_stable, 1 ) = Pitch_op;
             stab_TSR( cnt_stable, 1 ) = TSR_op;
             stab_windvel( cnt_stable, 1 ) = WindVel_op;
         end
    end
    else
        disp( [ 'Error: Size of the "wind velocity", "TSR velocty",', ...'
                '"Pitch velocity" should be same; CHECK again.']  );
        return
    end

% Assigning linear model to a structure variable         
        LinModel.A = A;
        LinModel.B = B;
        LinModel.C = C;
% Assigning stable operating points to a structure variable        
    if cnt_stable > 0
        stable_op.cnt = cnt_stable;
        stable_op.pitch = stab_pitch;
        stable_op.TSR = stab_TSR;
        stable_op.WindVel = stab_windvel;
    else
        stable_op.cnt = 0;
        stable_op.pitch = [];
        stable_op.TSR = [];
        stable_op.WindVel = [];
    end
% Assigning Unstable operating points to a structure variable
    if cnt_unstable > 0
        unstable_op.cnt = cnt_unstable;        
        unstable_op.pitch = unstab_pitch;
        unstable_op.TSR = unstab_TSR;
        unstable_op.WindVel = unstab_windvel;
        disp( [ 'Wind turbine system is statically unstable at', ...
                'some of the operating points'] )
    else
        unstable_op.cnt = 0;        
        unstable_op.pitch = [];
        unstable_op.TSR = [];
        unstable_op.WindVel = [];
    end
end