% author: jnitzbon
% description: this script is used to specify individual setups for
% parallel runs of CryoGrid3. it is called by the script "submit_SLURM.sh"
% which is used to submit MATLAB jobs to the SLURM queue
clear all;
close all;

%% generate SETUP struct

SETUP = {};

%startYear=2012;

% parameters
SETUP.numRealizations = 3;
SETUP.syncTimestep=6./24;
SETUP.startDate = datenum( 1979, 10, 1 );
SETUP.endDate = datenum( 2014, 12, 31);
SETUP.xH=1;
SETUP.xW=1;
SETUP.xS=1;
SETUP.f_C = 0.3;
SETUP.f_R = 0.6;
SETUP.f_T = 0.1;
SETUP.e_R = 0.4;
SETUP.e_T = 0.3;
SETUP.d_xice_C=0.9; % try 0.6 as well to get stabilizing effect?
SETUP.d_xice_R=0.6;
SETUP.d_xice_T1=0.2;
SETUP.d_xice_T2=SETUP.d_xice_R-abs(SETUP.e_R-SETUP.e_T); % intermediate layer with reduced excess ice between T1 and T2, # T2 should be at the same altitude as d_xice_R
SETUP.e_Reservoir = 0.0;
SETUP.K_Reservoir = 5e-5;
SETUP.K=1e-5;
SETUP.relMaxWater = 1.;
SETUP.heatExchangeAltitudeFactor = 0.;
SETUP.natPor = 0.55;
SETUP.fieldCapacity = 0.50;

% output directory
SETUP.saveDir = '/data/scratch/nitzbon/CryoGrid/CryoGrid3_infiltration_xice_mpi_polygon/runs';

% compose runname
SETUP.runName = sprintf( [ 'POLYGON_' datestr( SETUP.startDate, 'yyyymm' ) '-' datestr(SETUP.endDate, 'yyyymm' ) '_xH%d_xW%d_xS%d_fC%0.1f_fR%0.1f_fT%0.1f_eR%0.2f_eT%0.2f_dxiceC%0.2f_dxiceR%0.2f_dxiceTa%0.2f_dxiceTb%0.2f_K%0.1e_KRes%0.1e_eRes%0.2f_fc%0.2f_natPor%0.2f' ], ...
    SETUP.xH, SETUP.xW, SETUP.xS, ...
    SETUP.f_C, SETUP.f_R, SETUP.f_T, SETUP.e_R, SETUP.e_T, SETUP.d_xice_C, SETUP.d_xice_R, SETUP.d_xice_T1, SETUP.d_xice_T2, ...
    SETUP.K, SETUP.K_Reservoir, SETUP.e_Reservoir, SETUP.fieldCapacity, SETUP.natPor) ;

[~, SETUP.git_commit_hash] = system('git rev-parse HEAD');

% create ouput directory
mkdir( [ SETUP.saveDir ] );
mkdir( [ SETUP.saveDir '/' SETUP.runName ] );

% save setup file
save( [ SETUP.saveDir '/' SETUP.runName '/' SETUP.runName '_setup.mat' ], 'SETUP'  );

% create temporary files for output directory and run name
fid = fopen('SAVEDIR.temp','wt');
fprintf(fid, [ SETUP.saveDir ] );
fclose(fid);

fid = fopen('RUN.temp','wt');
fprintf(fid, [ SETUP.runName ] );
fclose(fid);