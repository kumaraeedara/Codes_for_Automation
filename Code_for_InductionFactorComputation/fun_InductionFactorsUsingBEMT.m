%% Author: Kumara Raja E, 02-Jan-2023
%% Help text:-
    % The objective of this program is to calculate the Induction factors 
    % at the given airfoil section on the blade corresponding to the wind 
    % flow conditions Vx, Vy.
%%    
function [ a, a_prime ]  = fun_InductionFactorsUsingBEMT( Parameters, ...
                                phi, ...
                                pitch, twist, ...
                                radius_af, ...
                                chord_af, ...
                                CL_table_local, ...
                                CD_table_local, ...
                                Vx, Vy )
                                            
    MaxAxInd = 1.5;
    MinAxInd = 1;
    MaxTnInd = 1;
    MinTnInd = -1;
    noSolution = 0; %
    InductionLimit = 1000000;
    
R_turbine = Parameters.WindTurbine.diameter/2;
R_hub = Parameters.Hub.radius;
B = Parameters.WindTurbine.no_of_blades;
r = radius_af;
c = chord_af;
Cl_af = CL_table_local;
Cd_af = CD_table_local;
AoA_data = Parameters.Blade.AeroDyn.angle_of_attack_table; 
    
    sigmaPrime = B*c /( 2*pi*r );
%     Hub and tip loss correction factor
    if sin(phi) == 0    % Taken from FAST "getHubTipLossCorrection"
        F_tip = 1;
        F_hub = 1;
    else
        fact_tip = B*(R_turbine - r)/( 2*r*abs( sin(phi) ) );   % Always positive
        fact_hub = B*(r - R_hub)/( 2*R_hub*abs( sin(phi) ) );   % Always positive
        F_tip = 2/pi*acos( min(1.0, exp(-fact_tip)));   % Tip loss factor
        F_hub = 2/pi*acos( min(1.0, exp(-fact_hub)));   % Hub loss factor
    end
    F = F_tip * F_hub;  % Tip/Hub loss factor

    
    % Wind flow zero or Angular speed zero case
    if ( Vx == 0 || Vy == 0) % WHY SHOULD THIS BE A PROBLEM?? IT was set in FAST "BEMTU_InductionWithResidual" function
        a = 0;
        a_prime = 0;
        residual = 0;   % FAST - BEMTU_InductionWithResidual
        return;
    end
    
       % At tip and hub
    if ((R_turbine - r) == 0 || (r - R_hub)== 0)   % This happens at the tip and hub
        a = 1;      % At the tip and hub hard coded Induction factors
        a_prime = 0;
        residual = 0;   % FAST - BEMTU_InductionWithResidual
        return;
    end
    
    alpha = phi - (pitch + twist); % rad
    Cl = interp1( AoA_data, Cl_af, rad2deg( alpha ) );    % Here only the CL column corresponding to the type of airfoil is passed
    Cd = interp1( AoA_data, Cd_af, rad2deg( alpha ) );    % Here only the CD column corresponding to the type of airfoil is passed
   
    Cn = Cl * cos( phi ) + Cd * sin( phi );
    Ct = Cl * sin( phi ) - Cd * cos( phi );
    
    % Induction factor for the non-singular case (i.e
    % momentum/emperical/propeller brake region

    flag_momOrEmpRegion =  ( phi > 0.0 && Vx >= 0.0 ) || ...
                           ( phi < 0.0 && Vx < 0.0 );
                       
    k = ( sigmaPrime*Cn )/( 4*F*sin( phi )^2 );     % non-dimensional axial parameter
    
    if flag_momOrEmpRegion  % Momentum or Emperical region
        flag_momentumRegion = (k <= 2/3);
        if flag_momentumRegion   % Momentum region (Thrust coefficient (CT) from momentum theory is equated to CT from Blade element theory.
            if k == -1.0
                var_sign = ( (1.0+k)>=0 )-( (1+k)<0 ); % SIGN def in FORTRAN: Returns 1, when (1+k)>= 0 and returns -1, when (1+k) < 0;  
                a = -axIndLim*var_sign;   % In FAST it is implemented using SIGN to make sure
            else
                a = k/(1+k);
            end
            if k < -1   % k < -1 cannot be a solution in momentum region (this is equivalent to a>1.0)
                noSolution = 1; % CHECK: IN THESE CASES FAST SETS a, a' = 0;
            end
        else % Emperical region (Thrust coefficient (CT) from Glaurt's theory is equated to CT from Blade element theory.
            gamma1 = 2.0 * F * k - (10/9 - F);
            gamma2 = 2.0 * F * k - F * (4/3 - F);
            gamma3 = 2.0 * F * k - (25/9 - 2 * F);
            if ( abs(gamma3) < 1E-6 )   % avoiding singularity case, gamma3 == 0
                a = 1.0 - 0.5/sqrt(gamma2);
            else
                a = ( gamma1 - sqrt(abs(gamma2)) )/gamma3;  % gamma2 is always greater than zero.
            end
        end
    else % Propeller brake region
        if k == 1
            noSolution = 1;     % In this case a, a' are set to '0'.
            a = InductionLimit; 
        else
            a = k/(k-1);
        end
        
        if k <= 1 % k <= 1 cannot be a solution in propeller brake region (this is equivalent to a<1.0)
            noSolution = 1;
        elseif (a > MaxAxInd)    % propeller brake region is for induction factors > 1, but not too large; 
            a = MaxAxInd;       % note that we use k in the residual equation instead of a in the propeller brake region, so we can put the limit here
        end
    end
    
    %% Tangential induction factor (a') evaluation
    % Unlike in the case of Axial induction factor(a), the the tangential
    % induction factor (a') is always calculated using a' = k'/(k'-1);
    if cos( phi )==0     % Singularity for the K' calculation; Hence set a large value for K'
        var_sign_1 = ct*sin(phi);
        var_sign_1 = (var_sign_1 >= 0)-( var_sign_1 < 0 ); % SIGN def in FORTRAN: Returns 1, when (ct*sphi)>= 0 and returns -1, when (ct*sphi) < 0;
        var_sign_2 = ( Vx >= 0 )-(Vx < 0);  % SIGN def in FORTRAN: Returns 1, when (ct*sphi)>= 0 and returns -1, when (ct*sphi) < 0;
        k_prime =  InductionLimit*var_sign_1*var_sign_2;  % Assigning a large value to K'
        a_prime = -1; % for large K' (or when K' = 1/0), a' = K'/(1-K');
    else
        k_prime = sigmaPrime*Ct/(4*F*sin(phi)*cos(phi));
        if (Vx < 0)
            k_prime = -k_prime;
        end
        
        if (k_prime == 1.0 )    % a' blows up; Hence set value for a'; Set a' to a large value
            var_sign_3 = 1.0-k_prime;
            var_sign_3 = (var_sign_3 >= 0)-(var_sign_3 < 0);
            a_prime = InductionLimit*var_sign_3;    % Setting a' to a large value
        else
            a_prime = k_prime/(1-k_prime);  % a' calculation using regular formula
        end
    % bandaid so that this doesn't blow up. Note that we're not using ap in the residual calculation, so we can modify it here.        
        a_prime = min( a_prime, MaxTnInd );
        a_prime = max( a_prime, MinTnInd );
    end
   

    % WHEN THIS FUNCTION IS USED FOR CALCULATING INDUCTION FACTORS, RETURN
    % a,a' as InductionFactors.
   
%% Residual calculation (for momentum/emperical/propeller brake region)
    % By the time the program reaches here the values for a, k, k' should be
    % available. a' is not needed because, in the expression for the residual 
    % a' is replaced with k'/(1-k').
% %     
% %     if flag_momOrEmpRegion  % Momentum of emperical region
% %         if a == 1
% %             residual = - cos(phi) * (Vx/Vy) * (1 - k_prime);    % CHECK WHY?
% %         else
% %             residual = sin(phi)/(1 - a) - (Vx/Vy) * ( cos(phi)*(1 - k_prime) );
% %             a = max(a, MaxAxInd);   % Bandaid in so that induction factor doesn't blow up; From FAST
% %         end
% %     else  % Propeller brake region  % HOW TO COMPUTE RESIDUAL FOR TIP/HUB CASE
% %         residual = sin(phi) * (1-k) - cos(phi) * (Vx/Vy) * (1 - k_prime); % CHECK; 
% %     end

    % Intentionally kept after residual calculation as done in FAST
     if noSolution   % taken from "inductionFactors" subroutine
        a = 0;
        a_prime = 0;
     end
     axInd = a;
    tanInd = a_prime;
end     % End of function "fun_ResidualCalc".