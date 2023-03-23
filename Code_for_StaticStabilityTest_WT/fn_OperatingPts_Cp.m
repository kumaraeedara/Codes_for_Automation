%% Kumara Raja E, 10-June-2021
% This function returns all the "Pitch" and "Tip Speed Ratio" corresponding
% to the given Cp value.
%%
function [ pitch_list, tsr_list, num_branch ] = fn_OperatingPts_Cp(  ...
                                                    level_Cp, ...
                                                    PitchAngle, ...
                                                    TipSpeedRatio, ...
                                                    Coeff_Power )
        [ lcdata ] = contour(   PitchAngle, TipSpeedRatio, Coeff_Power, ...
                                      [level_Cp level_Cp] );
        num_pts_branch = [ 0 ];

        % Contour returns data in a way that requires more post-processing to
        % get only 'pitch' and 'Tip speed ratio'.

        % Counting number of number of branches at the specified level of Cp.
        if isempty( lcdata )
            display('There are no Pitch and Tip speed ratio correspoding to this particular value of Cp');
            return
        else
            temp1 = length( lcdata(1,:) );
            temp2 = lcdata( 2, 1 );
            num_branch = 1;
            while temp2 <= temp1 - num_branch
                num_pts_branch = [num_pts_branch; temp2];
                if temp2 + num_branch ~= temp1
                    temp2 = temp2 + lcdata(2, temp2 + num_branch + 1);
                    num_branch = num_branch + 1;
                else
                    break
                end
            end
        end
    clear ii
    pitch_list = lcdata( 1, : );
    tsr_list = lcdata( 2, : );

    % Collecting 'Pitch' and 'TSR' such that corresponding to the branches
    % detected above.
    for ii = 1:num_branch
        pitch_list( num_pts_branch(ii, 1)+1 ) = [];
        tsr_list( num_pts_branch(ii, 1)+1 ) = [];
    end
    clear jj
    pitch_list = pitch_list';
    tsr_list = tsr_list';
    close all; % To close the figures generated because of the 'contour' command.
end