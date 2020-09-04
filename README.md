# vistalab/fw-gear-dtiinit-diffusion-maps

Generate diffusion maps (in NIfTI format), including Fractional Anisotropy (FA), Axial Diffusivity (AD), Mean Diffusivity (MD), and Radial Diffusivity (RD). The input to this Gear is a dtiInit archive, generated from either [dtiInit](https://github.com/scitran-apps/dtiinit), or as part of the [AFQ](https://github.com/scitran-apps/afq-pipeline) processing pipeline.

## Inputs
The input to this Gear is a dtiInit archive, containing a 'dt6.mat' file. This archive is generated from either [dtiInit](https://github.com/scitran-apps/dtiinit), or as part of the [AFQ](https://github.com/scitran-apps/afq-pipeline) processing pipeline.

```bash
dtiInit_29-Aug-2018_17-34-24.zip
```

## Outputs
Diffusion maps (in NIfTI format), including Fractional Anisotropy (FA), Axial Diffusivity (AD), Mean Diffusivity (MD), and Radial Diffusivity (RD).

```bash
fa.nii.gz
md.nii.gz
ad.nii.gz
rd.nii.gz
```

## Example Usage/Testing

To run/test this Gear you will need to:
1. Download the Flywheel CLI and login to your Flywheel Instance 
2. Build the Docker image 
3. Execute the Gear using the Flywheel CLI


#### 1. Download the Flywheel CLI and login
Visit: Flywheel for instruction on dowloading the CLIhttps://docs.flywheel.io/hc/en-us/articles/360008162214-Installing-the-Command-Line-Interface-CLI-

Once you have that, you can login:
```bash
fw login <your_flywheel_api_key>
```

#### 2. Build the image with Docker
```#bash
git clone https://github.com/vistalab/fw-gear-dtiinit-diffusion-maps
docker build -t vistalab/dtiinit-diffusion-maps:1.0.0
```
_Important note: The version (`1.0.0` in the example above) should be read from the `version` key within [manifest.json](manifest.json) file.

#### 3. Run the Gear locally with the test data
```bash
fw gear local --dtiinit_archive ./testdata/dtiInit_29-Aug-2018_17-34-24.zip
```
Example output:

```
lmperry@warrior:/Users/lmperry/dtiinit-diffusion-maps:$ fw gear local --dtiinit_archive ./testdata/dtiInit_29-Aug-2018_17-34-24.zip

Checking if vistalab/dtiinit-diffusion-maps:1.0.0 is available locally...
        Found tag locally.
Creating container from vistalab/dtiinit-diffusion-maps:1.0.0 ...
        Created de36f2efba27
Attaching to logs...

------------------------------------------
Setting up environment variables
---
LD_LIBRARY_PATH is .:/opt/mcr/v92/runtime/glnxa64:/opt/mcr/v92/bin/glnxa64:/opt/mcr/v92/sys/os/glnxa64:/opt/mcr/v92/sys/opengl/lib/glnxa64

archive_path =

    '/flywheel/v0/input/dtiinit_archive/dtiInit_29-Aug-2018_17-34-24.zip'

Unpacking archive...
Locating dt6.mat file from archive...
Found /tmp/dtiInit_29-Aug-2018_17-34-24/dti90trilin/dt6.mat!
Generating diffusion maps...
Generating fa map ... Writing /flywheel/v0/output/fa.nii.gz...Done.
Generating md map ... Writing /flywheel/v0/output/md.nii.gz...Done.
Generating ad map ... Writing /flywheel/v0/output/ad.nii.gz...Done.
Generating rd map ... Writing /flywheel/v0/output/rd.nii.gz...Done.
Complete!

Removing container de36f2efba27 ...
        Removed container

```

### Developer's Corner: Compiling the Matlab Executable
This Gear runs a Matlab Executable via the Matlab Compiler Runtime, which is build in the base image. __Note that the image uses MCR v92 (Matlabr2017a)__ - this MCR versionis used to maintain Docker image compatibility with the other tools generating the dtiInit_Archives.

If you find that need to make changes to the [source code](src/dtiinitDiffusionMaps_build.m) you will need to recompile the [executable](src/bin/run_dtiinitDiffusionMaps) and re-build the Docker image. 

In order to recompile the Matlab executable you can use the provided [`.m`](src/dtiinitDiffusionMaps_build.m) file (you need to use Matlabr2017a for the binary to be compatible with the [Docker image](Dockerfile) we generate here). 

The [`dtiinitDiffusionMaps_build.m`](src/dtiinitDiffusionMaps_build.m) file contains all the required instruction to compile the binary, including downloading the source code and setting required paths. 

You can run the code from the command line like so:
```bash
/<path_to_your_matlabr2017a_binary> -nodesktop -r 'dtiinitDiffusionMaps_build.m'
```

If you already have your Matlab 2017a terminal open, you can simply run [the code](src/dtiinitDiffusionMaps_build.m):
```Matlab
dtiinitDiffusionMaps_build
```

