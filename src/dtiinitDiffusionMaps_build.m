%
% EXAMPLE USAGE
%       /software/matlab/r2017a/bin/matlab -nodesktop -r 'dtiinitDiffusionMaps_build.m'

% Check that we are running a compatible matlab version (important for docker execution)
if (isempty(strfind(version, '9.2.0'))) || (isempty(strfind(computer, 'GLNXA64')))
    error('You must compile this function using R2017a (9.2.0.556344 (R2017a)) 64-bit (glnxa64). You are using %s, %s', version, computer);
end

disp(mfilename('fullpath'));
compileDir = fileparts(mfilename('fullpath'));
if ~strcmpi(pwd, compileDir)
    disp('You must run this code from %s', compileDir);
end

% Download the source code
disp('Cloning source code...');
system('mkdir source_code')
system('git clone https://github.com/vistalab/vistasoft source_code/vistasoft');

% Set paths
disp('Adding paths to build scope...');
restoredefaultpath;
addpath(genpath(fullfile(pwd, 'source_code')));

% Compile
disp('Running compile code...');
if ~exist('./bin', 'dir')
    mkdir('./bin')
end
mcc -v -R -nodisplay -m ./dtiinitDiffusionMaps.m -d ./bin

% Clean up
disp('Cleaning up...')
rmdir(fullfile(pwd, 'source_code'), 's');

disp('Done!');
exit
