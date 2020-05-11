clear

cd /Volumes/HARD_DRIVE/Infants/halves/
filematALL = dir('BEES_206_6_halves.set'); % This loads a struct of files of a specific condition e.g. (Pre)    
filemat = {filematALL.name}'; % This takes the just the names from that struct and transposes the list so its in the correct format
pathToFiles = ['/Volumes/HARD_DRIVE/Infants/halves/'];


for j = 1:size(filemat,1)
    subject_string = deblank(filemat(j,:));
    Csubject = char(subject_string);
    C = strsplit(Csubject,'.');
    subject = char(C(1,1));
    EEG = pop_loadset('filename', Csubject);

% %filter from .1-30Hz
% EEG  = pop_basicfilter( EEG,  1:129 , 'Boundary', 'boundary', 'Cutoff', [ 0.1 30], 'Design', 'butter', 'Filter', 'bandpass', 'Order',...
%   2 ); % GUI: 17-Jul-2019 10:01:24


% Bandpass filter from 0.5-30 Hz
    dataAK=double(EEG.data); 
    [alow, blow] = butter(6, 0.12); 
    [ahigh, bhigh] = butter(3,0.002, 'high'); 
     
    dataAKafterlow = filtfilt(alow, blow, dataAK'); 
    dataAKafterhigh = filtfilt(ahigh, bhigh, dataAKafterlow)'; 
     
    EEG.data = single(dataAKafterhigh); 

%create event list
EEG  = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString',...
 { 'boundary' } ); % GUI: 17-Jul-2019 10:02:59

EEG = pop_saveset(EEG, 'filename', strcat(subject,'_filt.set'))

%assign bins
EEG  = pop_binlister( EEG , 'BDF', '/Volumes/HARD_DRIVE/Infants/scripts/bins_ind_cat_halves.txt', 'IndexEL',  1, 'SendEL2',...
         'EEG', 'Voutput', 'EEG' );

% Create bin-based epochs
EEG = pop_epochbin( EEG , [-100.0  800.0],  'pre'); 

EEG = pop_saveset(EEG, 'filename', strcat('/Volumes/HARD_DRIVE/Infants/halves_filt_seg/',subject,'_filt_seg.set'))

end
%% clean data

clear

cd /Volumes/HARD_DRIVE/Infants/halves_filt_seg/
filematALL = dir('BEES_206_6_halves_filt_seg.set'); % This loads a struct of files of a specific condition e.g. (Pre)    
filemat = {filematALL.name}'; % This takes the just the names from that struct and transposes the list so its in the correct format
MYpath = ['/Volumes/HARD_DRIVE/Infants/halves_filt_seg/'];
%outerband = 0 , Baby=1 for babies
outerband = 0;
Baby = 1;

BEES_clean_data_batch(filemat, MYpath,outerband, Baby);
