%% Author: Kumara Raja E, 10-Sep-2022
function [ pitch_cycles ] = fun_PitchCycles( signal )
   peaks = findpeaks( signal );
   pitch_cycles = length( peaks );
end