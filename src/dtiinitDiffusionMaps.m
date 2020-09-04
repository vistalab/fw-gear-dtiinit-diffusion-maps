function dtiinitDiffusionMaps(config_file_path, output_dir)
%{


%}


%% 0. Set path variables and read config file

if ~exist('output_dir', 'var')
    output_dir = fullfile(fileparts(config_file_path), 'output');
end


if ~exist(output_dir, 'dir')
    disp('Creating output directory');
    mkdir(output_dir);
end


if ~exist(config_file_path, 'file')
    error('%s does not exist!', (config_file_path));
else
    raw_config = jsondecode(fileread(config_file_path));
end


if ~exist(raw_config.inputs.dtiinit_archive.location.path, 'file')
    disp(raw_config);
    error('Archive file was not found!');
end


%% 1. Unpack the archive and extract the dt6 file

archive_path = raw_config.inputs.dtiinit_archive.location.path
disp('Unpacking archive...');
contents = unzip(archive_path, tempdir);

disp('Locating dt6.mat file from archive...');
dt6File = '';
for ii=1:numel(contents)
    [~, f, e] = fileparts(contents{ii});
    fname = strcat(f,e); 
    if strcmp(fname,'dt6.mat')
        dt6File = contents{ii};
        break
    end
        
end

if isempty(dt6File)
    error('No diffusion file (dt6.mat) was found in the extracted archive!');
end


%% 2. Generate and save the diffusion maps

fprintf('Found %s!\nGenerating diffusion maps...\n', dt6File);
maps = {'fa', 'md', 'ad', 'rd'};

for mm = 1:numel(maps)
    outFile = fullfile(output_dir, strcat(maps{mm}, '.nii.gz'));
    fprintf('Generating %s map ... ', maps{mm});
    dtiCreateMap(dt6File, maps{mm}, outFile, 1);
end

disp('Complete!');


end
