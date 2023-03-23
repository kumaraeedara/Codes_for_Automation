%% Kumara Raja E, 29-Mar-2022
% This code is used to generate power curve.
% This code runs the MainCode.m in loop and stores the results.
% The runs are performed in "Pitch angle" and "Rotor speed" loops.
%%
clear all
clc
close all

global ConstVel angle_pitch_opt ConstRotSpd

pitch_list_temp = [-4:0.1:30];  % List of pitch angles for which the power curve needs to be generated
rotspd_list_temp = [5:0.2:35];  % List of rotor speeds for which the power curve needs to be generated - TSR variation
ConstVel = 12 ;

% pitch_list_temp = [2 10];
% rotspd_list_temp = [10 20];

cnt1 = 0;
for tt =  1:length(rotspd_list_temp) % Looping over Pitch angle
    cnt1 = cnt1 + 1;    
    ConstRotSpd = rotspd_list_temp(tt, 1);
    cnt2 = 0;
    for uu = 1:length(pitch_list_temp) % Looping over Rotor speeds
        cnt2 = cnt2 + 1;
        angle_pitch_opt = pitch_list_temp(uu, 1);
        filename = "PowerCurve_"+num2str(cnt1,"%03d")+num2str(cnt2,"%03d");
        run MainCode.m
        TSR_OwnModel(tt, 1) = rad_turbine*ConstRotSpd*rpm2radpersec/ConstVel;
        Pitch_OwnModel(uu, 1) = angle_pitch_opt;        
        force_thrust_OwnModel(tt, uu) = force_thrust(end);
        torque_aero_OwnModel(tt, uu) = torque_aero(end);
        power_OwnModel(tt, uu) = torque_aero_OwnModel(tt, uu)*ConstRotSpd*rpm2radpersec;
        Cp_OwnModel(tt, uu) = power_OwnModel(tt, uu)/(0.5*dens_air*pi*rad_turbine^2*ConstVel^3);
        Cq_OwnModel(tt, uu) = Cp_OwnModel(tt, uu)/TSR_OwnModel(tt, 1);
        Ct_OwnModel(tt, uu) = force_thrust_OwnModel(tt, uu)/(0.5*dens_air*pi*rad_turbine^2*ConstVel^2);
    end
end
clearvars -except Cp_OwnModel Cq_OwnModel Ct_OwnModel TSR_OwnModel ...
                    Pitch_OwnModel force_thrust_OwnModel ...
                    torque_aero_OwnModel power_OwnModel
%%
% % Replacing negative power coefficients with zero
for ii = 1:length(TSR_OwnModel)
    for jj = 1:length(Pitch_OwnModel)
        if Cp_OwnModel(ii,jj)<0
            Cp_OwnModel(ii, jj)=0;
        else
            Cp_OwnModel(ii, jj) = Cp_OwnModel(ii, jj);
        end
        
        if Cq_OwnModel(ii, jj)<0
            Cq_OwnModel(ii, jj) = 0;
        else
            Cq_OwnModel(ii, jj) = Cq_OwnModel(ii, jj);
        end
        
        if Ct_OwnModel(ii, jj)<0
            Ct_OwnModel(ii, jj) = 0;
        else
            
            Ct_OwnModel(ii, jj) = Ct_OwnModel(ii, jj);
        end
    end
end
save("PowerCurve_OwnModel")