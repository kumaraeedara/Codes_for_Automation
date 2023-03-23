%% Kumara Raja E, 04-Jun-2022
% Objective:------->
%       This code generates reports for time and frequencey domain results
%       of OpenFAST results.
% This code runs "PlotsAutomation.m" file, hence it should also be present
% in the same folder
%% 
clear all
close all
clc
%%  Inputs:
% Filenames of OpenFAST output files
OutputDataFileNames = [ "Case010.out", "Case011.out" ];
% Total Output variables present in OpenFAST output file.
OutputVarTot = ["Time	Wind1VelX	Wind1VelY	Wind1VelZ	TwrTpTDxi	TwrTpTDyi	TwrTpTDzi	YawBrTDxp	YawBrTDyp	YawBrTDzp	YawBrTDxt	YawBrTDyt	YawBrTDzt	YawBrTAxp	YawBrTAyp	YawBrTAzp	YawBrRDxt	YawBrRDyt	YawBrRDzt	YawBrRVxp	YawBrRVyp	YawBrRVzp	YawBrRAxp	YawBrRAyp	YawBrRAzp	TipDxc1	TipDyc1	TipDzc1	TipDxb1	TipDyb1	TipALxb1	TipALyb1	TipALzb1	TipRDxb1	TipRDyb1	TipRDzc1	TipClrnc1	TipDxc2	TipDyc2	TipDzc2	TipDxb2	TipDyb2	TipALxb2	TipALyb2	TipALzb2	TipRDxb2	TipRDyb2	TipRDzc2	TipClrnc2	TipDxc3	TipDyc3	TipDzc3	TipDxb3	TipDyb3	TipALxb3	TipALyb3	TipALzb3	TipRDxb3	TipRDyb3	TipRDzc3	TipClrnc3	PtchPMzc1	PtchPMzc2	PtchPMzc3	LSSTipPxa	LSSTipVxa	LSSTipAxa	LSSGagPxa	LSSGagVxa	LSSGagAxa	HSShftV	HSShftA	NcIMUTVxs	NcIMUTVys	NcIMUTVzs	NcIMUTAxs	NcIMUTAys	NcIMUTAzs	NcIMURVxs	NcIMURVys	NcIMURVzs	NcIMURAxs	NcIMURAys	NcIMURAzs	TwrTpTDxi	TwrTpTDyi	TwrTpTDzi	YawBrTDxp	YawBrTDyp	YawBrTDzp	YawBrTDxt	YawBrTDyt	YawBrTDzt	YawBrTVxp	YawBrTVyp	YawBrTVzp	YawBrTAxp	YawBrTAyp	YawBrTAzp	YawBrRDxt	YawBrRDyt	YawBrRDzt	YawBrRVxp	YawBrRVyp	YawBrRVzp	YawBrRAxp	YawBrRAyp	YawBrRAzp	YawPzn	YawVzn	YawAzn	RootFxc1	RootFyc1	RootFzc1	RootFxb1	RootFyb1	RootMxc1	RootMyc1	RootMzc1	RootMxb1	RootMyb1	RootFxc2	RootFyc2	RootFzc2	RootFxb2	RootFyb2	RootMxc2	RootMyc2	RootMzc2	RootMxb2	RootMyb2	RootFxc3	RootFyc3	RootFzc3	RootFxb3	RootFyb3	RootMxc3	RootMyc3	RootMzc3	RootMxb3	RootMyb3	LSShftFxa	LSShftFya	LSShftFza	LSShftFys	LSShftFzs	LSShftMxa	LSSTipMya	LSSTipMza	LSSTipMys	LSSTipMzs	RotPwr	HSShftTq	HSSBrTq	HSShftPwr	TwrBsFxt	TwrBsFyt	TwrBsFzt	TwrBsMxt	TwrBsMyt	TwrBsMzt	YawBrFxn	YawBrFyn	YawBrFzn	YawBrFxp	YawBrFyp	YawBrMxn	YawBrMyn	YawBrMzn	YawBrMxp	YawBrMyp	B1N1VRel	B2N1VRel	B3N1VRel	B1N1Phi	B1N2Phi	B1N3Phi	B1N4Phi	B1N5Phi	B1N6Phi	B1N7Phi	B1N8Phi	B1N9Phi	B2N1Phi	B2N2Phi	B2N3Phi	B2N4Phi	B2N5Phi	B2N6Phi	B2N7Phi	B2N8Phi	B2N9Phi	B3N1Phi	B3N2Phi	B3N3Phi	B3N4Phi	B3N5Phi	B3N6Phi	B3N7Phi	B3N8Phi	B3N9Phi	B1N1Alpha	B1N2Alpha	B1N3Alpha	B1N4Alpha	B1N5Alpha	B1N6Alpha	B1N7Alpha	B1N8Alpha	B1N9Alpha	B2N1Alpha	B2N2Alpha	B2N3Alpha	B2N4Alpha	B2N5Alpha	B2N6Alpha	B2N7Alpha	B2N8Alpha	B2N9Alpha	B3N1Alpha	B3N2Alpha	B3N3Alpha	B3N4Alpha	B3N5Alpha	B3N6Alpha	B3N7Alpha	B3N8Alpha	B3N9Alpha	B1N1Fx	B1N2Fx	B1N3Fx	B1N4Fx	B1N5Fx	B1N6Fx	B1N7Fx	B1N8Fx	B1N9Fx	B2N1Fx	B2N2Fx	B2N3Fx	B2N4Fx	B2N5Fx	B2N6Fx	B2N7Fx	B2N8Fx	B2N9Fx	B3N1Fx	B3N2Fx	B3N3Fx	B3N4Fx	B3N5Fx	B3N6Fx	B3N7Fx	B3N8Fx	B3N9Fx	B1N1Fy	B1N2Fy	B1N3Fy	B1N4Fy	B1N5Fy	B1N6Fy	B1N7Fy	B1N8Fy	B1N9Fy	B2N1Fy	B2N2Fy	B2N3Fy	B2N4Fy	B2N5Fy	B2N6Fy	B2N7Fy	B2N8Fy	B2N9Fy	B3N1Fy	B3N2Fy	B3N3Fy	B3N4Fy	B3N5Fy	B3N6Fy	B3N7Fy	B3N8Fy	B3N9Fy	B1N1Clrnc	B1N2Clrnc	B1N3Clrnc	B1N4Clrnc	B1N5Clrnc	B1N6Clrnc	B1N7Clrnc	B1N8Clrnc	B1N9Clrnc	B2N1Clrnc	B2N2Clrnc	B2N3Clrnc	B2N4Clrnc	B2N5Clrnc	B2N6Clrnc	B2N7Clrnc	B2N8Clrnc	B2N9Clrnc	B3N1Clrnc	B3N2Clrnc	B3N3Clrnc	B3N4Clrnc	B3N5Clrnc	B3N6Clrnc	B3N7Clrnc	B3N8Clrnc	B3N9Clrnc	B1N1STVx	B1N2STVx	B1N3STVx	B1N4STVx	B1N5STVx	B1N6STVx	B1N7STVx	B1N8STVx	B1N9STVx	B1N1STVy	B1N2STVy	B1N3STVy	B1N4STVy	B1N5STVy	B1N6STVy	B1N7STVy	B1N8STVy	B1N9STVy	B1N1STVz	B1N2STVz	B1N3STVz	B1N4STVz	B1N5STVz	B1N6STVz	B1N7STVz	B1N8STVz	B1N9STVz	B1N1VUndx	B1N2VUndx	B1N3VUndx	B1N4VUndx	B1N5VUndx	B1N6VUndx	B1N7VUndx	B1N8VUndx	B1N9VUndx	B2N1VUndx	B2N2VUndx	B2N3VUndx	B2N4VUndx	B2N5VUndx	B2N6VUndx	B2N7VUndx	B2N8VUndx	B2N9VUndx	B3N1VUndx	B3N2VUndx	B3N3VUndx	B3N4VUndx	B3N5VUndx	B3N6VUndx	B3N7VUndx	B3N8VUndx	B3N9VUndx	B1N1VDisx	B1N2VDisx	B1N3VDisx	B1N4VDisx	B1N5VDisx	B1N6VDisx	B1N7VDisx	B1N8VDisx	B1N9VDisx	B2N1VDisx	B2N2VDisx	B2N3VDisx	B2N4VDisx	B2N5VDisx	B2N6VDisx	B2N7VDisx	B2N8VDisx	B2N9VDisx	B3N1VDisx	B3N2VDisx	B3N3VDisx	B3N4VDisx	B3N5VDisx	B3N6VDisx	B3N7VDisx	B3N8VDisx	B3N9VDisx	B1Azimuth	B2Azimuth	B3Azimuth	B1Pitch	B2Pitch	B3Pitch	RtSpeed	RtTSR	RtVAvgxh	RtVAvgyh	RtVAvgzh	RtSkew	RtAeroFxh	RtAeroFyh	RtAeroFzh	RtAeroMxh	RtAeroMyh	RtAeroMzh	RtAeroPwr	RtArea	RtAeroCp	RtAeroCq	RtAeroCt	BlPitchC1	BlPitchC2	BlPitchC3	GenTq	GenPwr"];

% Required for finding FFTs
DT = 0.01;  % Simulation time step
Fs = 1/DT;  % Sampling frequency
T_1 = 200;  % Time from which the signal should be considered for FFT (after transients)
lower_xlim = 200;   % Lower x axis limit for plots in time domain
upper_xlim = 300;   % Upper x axis limit for plots in time domain

% Selecting the required outputs, like, Time domain/Frequency domain
swtchPlots = input(['Enter 1: Time domain results for motion \n'...
                          '2: Time domain results for Force \n'...
                          '3: Frequency domain results for motion \n'...
                          '4: Frequency domain results for Force \n'...
                          'For morethan one result enter [1 2 3 4] etc \n']);
swtchLegend = input('Have you given the correct legend name? 0:NO  1:YES \n');
if swtchLegend==0
    return
end
%%  Creating dictionary for "Title"
keyset_motion = {'Wind1VelX',	'Wind1VelY',	'Wind1VelZ',	'B1N1VUndx',	'B2N1VUndx',	'B3N1VUndx',	'B1N1VDisx',	'B2N1VDisx',	'B3N1VDisx',	'B1N1VRel',	'B2N1VRel',	'B3N1VRel',	'LSSTipPxa',	'LSSGagVxa',	'HSShftV',	'YawBrTDxt',	'YawBrTDyt',	'YawBrTDzt',	'YawBrTDxp',	'YawBrTDyp',	'YawBrTDzp',	'YawBrTAxp',	'YawBrTAyp',	'YawBrTAzp',	'TwrTpTDxi',	'TwrTpTDyi',	'TwrTpTDzi',	'YawBrRDxt',	'YawBrRDyt',	'YawBrRDzt',	'YawBrRVxp',	'YawBrRVyp',	'YawBrRVzp',	'YawBrRAxp',	'YawBrRAyp',	'YawBrRAzp',	'NcIMUTVxs',	'NcIMUTVys',	'NcIMUTVzs',	'NcIMUTAxs',	'NcIMUTAys',	'NcIMUTAzs',	'TipDxc1',	'TipDyc1',	'TipDzc1',	'TipDxc2',	'TipDyc2',	'TipDzc2',	'TipDxc3',	'TipDyc3',	'TipDzc3',	'TipDxb1',	'TipDyb1',	'TipDxb2',	'TipDyb2',	'TipDxb3',	'TipDyb3',	'TipALxb1',	'TipALyb1',	'TipALzb1',	'TipALxb2',	'TipALyb2',	'TipALzb2',	'TipALxb3',	'TipALyb3',	'TipALzb3',	'TipRDxb1',	'TipRDyb1',	'TipRDzc1',	'TipRDxb2',	'TipRDyb2',	'TipRDzc2',	'TipRDxb3',	'TipRDyb3',	'TipRDzc3',	'TipClrnc1',	'TipClrnc2',	'TipClrnc3',	'YawPzn',	'YawVzn',	'YawAzn',	'B1Azimuth',	'B2Azimuth',	'B3Azimuth',	'B1N9Alpha',	'B2N9Alpha',	'B3N9Alpha',	'B1N9Phi',	'B2N9Phi',	'B3N9Phi',	'B1Pitch',	'B2Pitch',	'B3Pitch'};
valueset_motion = {'Wind velocity x-component at node1',	'Wind velocity y-component at node1',	'Wind velocity z-component at node1',	'Rotationally sampled undisturbed wind velocity at node1 on blade1',	'Rotationally sampled undisturbed wind velocity at node1 on blade2',	'Rotationally sampled undisturbed wind velocity at node1 on blade3',	'Rotationally sampled disturbed wind velocity at node1 on blade1',	'Rotationally sampled disturbed wind velocity at node1 on blade2',	'Rotationally sampled disturbed wind velocity at node1 on blade3',	'Rotationally sampled relaive wind velocity at node1 on blade1',	'Rotationally sampled relative wind velocity at node1 on blade2',	'Rotationally sampled relative wind velocity at node1 on blade3',	'Rotor azimuthal position',	'Rotor azimuthal angular velocity',	'High speed shaft angular velocity',	'Tower top displacement along X_t',	'Tower top displacement along Y_t',	'Tower top displacement along Z_t',	'Tower top displacement along X_p',	'Tower top displacement along Y_p',	'Tower top displacement along Z_p',	'Tower top acceleration along X_p',	'Tower top acceleration along Y_p',	'Tower top acceleration along Z_p',	'Tower top acceleration along X_i',	'Tower top acceleration along Y_i',	'Tower top acceleration along Z_i',	'Tower top rotational displacement about  X_t',	'Tower top rotational displacement about Y_t',	'Tower top rotational displacement about Z_t',	'Tower top Rotation velocity about X_p',	'Tower top Rotation velocity about Y_p',	'Tower top Rotation velocity about Z_p',	'Tower top Rotation acceleration about X_p',	'Tower top Rotation acceleration about Y_p',	'Tower top Rotation acceleration about Z_p',	'Absolute tower top velocity along X_s',	'Absolute tower top velocity along Y_s',	'Absolute tower top velocity along Z_s',	'Absolute tower top acceleration along X_s',	'Absolute tower top acceleration along Y_s',	'Absolute tower top acceleration along Z_s',	'Blade1 tip displacement along X_c',	'Blade1 tip displacement along Y_c',	'Blade1 tip displacement along Z_c',	'Blade2 tip displacement along X_c',	'Blade2 tip displacement along Y_c',	'Blade2 tip displacement along Z_c',	'Blade3 tip displacement along X_c',	'Blade3 tip displacement along Y_c',	'Blade3 tip displacement along Z_c',	'Blade1 tip displacement along X_b',	'Blade1 tip displacement along Y_b',	'Blade2 tip displacement along X_b',	'Blade2 tip displacement along Y_b',	'Blade3 tip displacement along X_b',	'Blade3 tip displacement along Y_b',	'Blade1 tip acceleration along X_b',	'Blade1 tip acceleration along Y_b',	'Blade1 tip acceleration along Z_b',	'Blade2 tip acceleration along X_b',	'Blade2 tip acceleration along Y_b',	'Blade2 tip acceleration along Z_b',	'Blade3 tip acceleration along X_b',	'Blade3 tip acceleration along Y_b',	'Blade3 tip acceleration along Z_b',	'Blade1 tip rotation about X_b',	'Blade1 tip rotation about Y_b',	'Blade1 tip rotation about Z_c',	'Blade2 tip rotation about X_b',	'Blade2 tip rotation about Y_b',	'Blade2 tip rotation about Z_c',	'Blade3 tip rotation about X_b',	'Blade3 tip rotation about Y_b',	'Blade3 tip rotation about Z_c',	'Blade1 tip clearance',	'Blade2 tip clearance',	'Blade3 tip clearance',	'Yaw position of the nacelle',	'Yaw velocity of the nacelle',	'Yaw acceleration of the nacelle',	'Azimuthal position of the blade1',	'Azimuthal position of the blade2',	'Azimuthal position of the blade3',	'Angle of attack at the blade1 tip',	'Angle of attack at the blade2 tip',	'Angle of attack at the blade3 tip',	'Inflow angle at the blade1 tip',	'Inflow angle at the blade2 tip',	'Inflow angle at the blade3 tip',	'Blade1 pitch angle',	'Blade2 pitch angle',	'Blade3 pitch angle'};
keyset_force = {'RtAeroPwr',	'RotPwr',	'HSShftPwr',	'GenPwr',	'HSShftTq',	'GenTq',	'RtAeroMxh',	'RtAeroMyh',	'RtAeroMzh',	'RtAeroFxh',	'RtAeroFyh',	'RtAeroFzh',	'YawBrFxp',	'YawBrFyp',	'YawBrFzn',	'YawBrMxp',	'YawBrMyp',	'YawBrMzn',	'TwrBsFxt',	'TwrBsFyt',	'TwrBsFzt',	'TwrBsMxt',	'TwrBsMyt',	'TwrBsMzt',	'RootFxc1',	'RootFyc1',	'RootFzc1',	'RootMxc1',	'RootMyc1',	'RootMzc1',	'RootFxb1',	'RootFyb1',	'RootMxb1',	'RootMyb1',	'RootFxc2',	'RootFyc2',	'RootFzc2',	'RootMxc2',	'RootMyc2',	'RootMzc2',	'RootFxb2',	'RootFyb2',	'RootMxb2',	'RootMyb2',	'RootFxc3',	'RootFyc3',	'RootFzc3',	'RootMxc3',	'RootMyc3',	'RootMzc3',	'RootFxb3',	'RootFyb3',	'RootMxb3',	'RootMyb3'};
valueset_force = {'Aerodynamic power captured by rotor',	'Rotor power',	'High speed shaft power',	'Generator power',	'High speed shaft torque',	'Geneartor torque',	'Total aerodynamic moment about X_h',	'Total aerodynamic moment about Y_h',	'Total aerodynamic moment about Z_h',	'Total aerodynamic force along X_h',	'Total aerodynamic force along Y_h',	'Total aerodynamic force along Z_h',	'Force acting at the tower top along X_p',	'Force acting at the tower top along Y_p',	'Force acting at the tower top along Z_n',	'Moment acting at the tower top about X_p',	'Moment acting at the tower top about Y_p',	'Moment acting at the tower top about Z_n',	'Shear force acting at the tower base along X_t',	'Shear force acting at the tower base along Y_t',	'Force acting at the tower base along Z_t',	'Tower base moment about X_t',	'Tower base moment about Y_t',	'Tower base moment about Z_t',	'Shear force at the blade1 root along X_c',	'Shear force at the blade1 root along Y_c',	'Shear force at the blade1 root along Z_c',	'Moment acting at the blade1 root about X_c',	'Moment acting at the blade1 root about Y_c',	'Moment acting at the blade1 root about Z_c',	'Shear force at the blade1 root along X_b',	'Shear force at the blade1 root along Y_b',	'Moment acting at the blade1 root about X_b',	'Moment acting at the blade1 root about Y_b',	'Shear force at the blade2 root along X_c',	'Shear force at the blade2 root along Y_c',	'Shear force at the blade2 root along Z_c',	'Moment acting at the blade2 root about X_c',	'Moment acting at the blade2 root about Y_c',	'Moment acting at the blade2 root about Z_c',	'Shear force at the blade2 root along X_b',	'Shear force at the blade2 root along Y_b',	'Moment acting at the blade2 root about X_b',	'Moment acting at the blade2 root about Y_b',	'Shear force at the blade3 root along X_c',	'Shear force at the blade3 root along Y_c',	'Shear force at the blade3 root along Z_c',	'Moment acting at the blade3 root about X_c',	'Moment acting at the blade3 root about Y_c',	'Moment acting at the blade3 root about Z_c',	'Shear force at the blade3 root along X_b',	'Shear force at the blade3 root along Y_b',	'Moment acting at the blade3 root about X_b',	'Moment acting at the blade3 root about Y_b'};

title_dict_force = containers.Map(keyset_force, valueset_force);
title_dict_motion = containers.Map(keyset_motion, valueset_motion);

%% Total Output variables present in OpenFAST output
OutputVarTot = strsplit( OutputVarTot );

[ OutputVar, Indx_OutputVarNonRepeat ]= unique( OutputVarTot,'stable' ); % To remove the repeated variables

Indx_OutputVarTot = [ 1:length(OutputVarTot) ];
Indx_OutputVarRepeat = setdiff( Indx_OutputVarTot, Indx_OutputVarNonRepeat );

UnitsOutputVar = ["(s)	(m/s)	(m/s)	(m/s)	(m)	(m)	(m)	(m)	(m)	(m)	(m)	(m)	(m)	(m/s^2)	(m/s^2)	(m/s^2)	(deg)	(deg)	(deg)	(deg/s)	(deg/s)	(deg/s)	(deg/s^2)	(deg/s^2)	(deg/s^2)	(m)	(m)	(m)	(m)	(m)	(m/s^2)	(m/s^2)	(m/s^2)	(deg)	(deg)	(deg)	(m)	(m)	(m)	(m)	(m)	(m)	(m/s^2)	(m/s^2)	(m/s^2)	(deg)	(deg)	(deg)	(m)	(m)	(m)	(m)	(m)	(m)	(m/s^2)	(m/s^2)	(m/s^2)	(deg)	(deg)	(deg)	(m)	(deg)	(deg)	(deg)	(deg)	(rpm)	(deg/s^2)	(deg)	(rpm)	(deg/s^2)	(rpm)	(deg/s^2)	(m/s)	(m/s)	(m/s)	(m/s^2)	(m/s^2)	(m/s^2)	(deg/s)	(deg/s)	(deg/s)	(deg/s^2)	(deg/s^2)	(deg/s^2)	(m)	(m)	(m)	(m)	(m)	(m)	(m)	(m)	(m)	(m/s)	(m/s)	(m/s)	(m/s^2)	(m/s^2)	(m/s^2)	(deg)	(deg)	(deg)	(deg/s)	(deg/s)	(deg/s)	(deg/s^2)	(deg/s^2)	(deg/s^2)	(deg)	(deg/s)	(deg/s^2)	(kN)	(kN)	(kN)	(kN)	(kN)	(kN-m)	(kN-m)	(kN-m)	(kN-m)	(kN-m)	(kN)	(kN)	(kN)	(kN)	(kN)	(kN-m)	(kN-m)	(kN-m)	(kN-m)	(kN-m)	(kN)	(kN)	(kN)	(kN)	(kN)	(kN-m)	(kN-m)	(kN-m)	(kN-m)	(kN-m)	(kN)	(kN)	(kN)	(kN)	(kN)	(kN-m)	(kN-m)	(kN-m)	(kN-m)	(kN-m)	(kW)	(kN-m)	(kN-m)	(kW)	(kN)	(kN)	(kN)	(kN-m)	(kN-m)	(kN-m)	(kN)	(kN)	(kN)	(kN)	(kN)	(kN-m)	(kN-m)	(kN-m)	(kN-m)	(kN-m)	(m/s)	(m/s)	(m/s)	(deg)	(deg)	(deg)	(deg)	(deg)	(deg)	(deg)	(deg)	(deg)	(deg)	(deg)	(deg)	(deg)	(deg)	(deg)	(deg)	(deg)	(deg)	(deg)	(deg)	(deg)	(deg)	(deg)	(deg)	(deg)	(deg)	(deg)	(deg)	(deg)	(deg)	(deg)	(deg)	(deg)	(deg)	(deg)	(deg)	(deg)	(deg)	(deg)	(deg)	(deg)	(deg)	(deg)	(deg)	(deg)	(deg)	(deg)	(deg)	(deg)	(deg)	(deg)	(deg)	(deg)	(deg)	(N/m)	(N/m)	(N/m)	(N/m)	(N/m)	(N/m)	(N/m)	(N/m)	(N/m)	(N/m)	(N/m)	(N/m)	(N/m)	(N/m)	(N/m)	(N/m)	(N/m)	(N/m)	(N/m)	(N/m)	(N/m)	(N/m)	(N/m)	(N/m)	(N/m)	(N/m)	(N/m)	(N/m)	(N/m)	(N/m)	(N/m)	(N/m)	(N/m)	(N/m)	(N/m)	(N/m)	(N/m)	(N/m)	(N/m)	(N/m)	(N/m)	(N/m)	(N/m)	(N/m)	(N/m)	(N/m)	(N/m)	(N/m)	(N/m)	(N/m)	(N/m)	(N/m)	(N/m)	(N/m)	INVALID	INVALID	INVALID	INVALID	INVALID	INVALID	INVALID	INVALID	INVALID	INVALID	INVALID	INVALID	INVALID	INVALID	INVALID	INVALID	INVALID	INVALID	INVALID	INVALID	INVALID	INVALID	INVALID	INVALID	INVALID	INVALID	INVALID	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(m/s)	(deg)	(deg)	(deg)	(deg)	(deg)	(deg)	(rpm)	(-)	(m/s)	(m/s)	(m/s)	(deg)	(N)	(N)	(N)	(N-m)	(N-m)	(N-m)	(W)	(m^2)	(-)	(-)	(-)	(deg)	(deg)	(deg)	(kN-m)	(kW)"];
UnitsOutputVar = strsplit( UnitsOutputVar );

% Removing the units corresponding to the repeated output variables
% for ii = 1:length( Indx_OutputVarRepeat )
%     UnitsOutputVar( Indx_OutputVarRepeat(1,ii) ) = [];
% end
% clear ii

units_dict = containers.Map( OutputVarTot, UnitsOutputVar );

% Motion output variables for which plots are required
MotionOutputVar = [ "Wind1VelX	Wind1VelY	Wind1VelZ	B1N1VUndx	B2N1VUndx	B3N1VUndx	B1N1VDisx	B2N1VDisx	B3N1VDisx	B1N1VRel	B2N1VRel	B3N1VRel	LSSTipPxa	LSSGagVxa	HSShftV	YawBrTDxt	YawBrTDyt	YawBrTDzt	YawBrTDxp	YawBrTDyp	YawBrTDzp	YawBrTAxp	YawBrTAyp	YawBrTAzp	TwrTpTDxi	TwrTpTDyi	TwrTpTDzi	YawBrRDxt	YawBrRDyt	YawBrRDzt	YawBrRVxp	YawBrRVyp	YawBrRVzp	YawBrRAxp	YawBrRAyp	YawBrRAzp	NcIMUTVxs	NcIMUTVys	NcIMUTVzs	NcIMUTAxs	NcIMUTAys	NcIMUTAzs	TipDxc1	TipDyc1	TipDzc1	TipDxc2	TipDyc2	TipDzc2	TipDxc3	TipDyc3	TipDzc3	TipDxb1	TipDyb1	TipDxb2	TipDyb2	TipDxb3	TipDyb3	TipALxb1	TipALyb1	TipALzb1	TipALxb2	TipALyb2	TipALzb2	TipALxb3	TipALyb3	TipALzb3	TipRDxb1	TipRDyb1	TipRDzc1	TipRDxb2	TipRDyb2	TipRDzc2	TipRDxb3	TipRDyb3	TipRDzc3	TipClrnc1	TipClrnc2	TipClrnc3	YawPzn	YawVzn	YawAzn	B1Azimuth	B2Azimuth	B3Azimuth	B1N9Alpha	B2N9Alpha	B3N9Alpha	B1N9Phi	B2N9Phi	B3N9Phi	B1Pitch	B2Pitch	B3Pitch" ];
MotionOutputVar = strsplit( MotionOutputVar );    
MotionOutputVar = unique( MotionOutputVar, 'stable' ); % To remove the repeated variables

% Force output variables for which plots are required
ForceOutputVar = [ "RtAeroPwr	RotPwr	HSShftPwr	GenPwr	HSShftTq	GenTq	RtAeroMxh	RtAeroMyh	RtAeroMzh	RtAeroFxh	RtAeroFyh	RtAeroFzh	YawBrFxp	YawBrFyp	YawBrFzn	YawBrMxp	YawBrMyp	YawBrMzn	YawBrFxp	YawBrFyp	YawBrMxp	YawBrMyp	TwrBsFxt	TwrBsFyt	TwrBsFzt	TwrBsMxt	TwrBsMyt	TwrBsMzt	RootFxc1	RootFyc1	RootFzc1	RootMxc1	RootMyc1	RootMzc1	RootFxb1	RootFyb1	RootMxb1	RootMyb1	RootFxc2	RootFyc2	RootFzc2	RootMxc2	RootMyc2	RootMzc2	RootFxb2	RootFyb2	RootMxb2	RootMyb2	RootFxc3	RootFyc3	RootFzc3	RootMxc3	RootMyc3	RootMzc3	RootFxb3	RootFyb3	RootMxb3	RootMyb3" ];
ForceOutputVar = strsplit( ForceOutputVar );    
ForceOutputVar = unique( ForceOutputVar, 'stable' ); % To remove the repeated variables

for ii = 1:length( MotionOutputVar )
    temp = find( strcmp(OutputVar, MotionOutputVar(ii)) );
    Indx_MotionOutputVar(ii) = Indx_OutputVarNonRepeat(temp);
end
clear ii

for ii = 1:length( ForceOutputVar )
    temp = find( strcmp(OutputVar, ForceOutputVar(ii)) );
    Indx_ForceOutputVar(ii) = Indx_OutputVarNonRepeat(temp);
end                      
clear ii

if isempty( swtchPlots )
    warning( "EKR:No results requested." )
else
    for ii = 1:length( swtchPlots )
        swtchPlots_curr = swtchPlots( ii );
        switch swtchPlots_curr
            case 1
                publish( 'PP01_PlotsAutomation.m', 'showCode',false, 'format','latex', 'outputDir','E:\PhD_WT\WP1500KW_2022\DynamicAnalysis\PostProcess' )
                close all
                movefile('*.eps','TimeDomain_Motion')                
                movefile('*.tex','TimeDomain_Motion')
            case 2
                publish( 'PP01_PlotsAutomation.m', 'showCode',false, 'format','latex', 'outputDir','E:\PhD_WT\WP1500KW_2022\DynamicAnalysis\PostProcess' )
                close all
                movefile('*.eps','TimeDomain_Force')                
                movefile('*.tex','TimeDomain_Force')
            case 3
                publish( 'PP01_PlotsAutomation.m', 'showCode',false, 'format','latex', 'outputDir','E:\PhD_WT\WP1500KW_2022\DynamicAnalysis\PostProcess' )
                close all
                movefile('*.eps','FreqDomain_Motion')                
                movefile('*.tex','FreqDomain_Motion')
            case 4
                publish( 'PP01_PlotsAutomation.m', 'showCode',false, 'format','latex', 'outputDir','E:\PhD_WT\WP1500KW_2022\DynamicAnalysis\PostProcess' )
                close all
                movefile('*.eps','FreqDomain_Force')                
                movefile('*.tex','FreqDomain_Force')
        end
    end
end