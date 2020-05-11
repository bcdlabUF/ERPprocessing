% EEGLAB history file generated on the 06-Feb-2019
% ------------------------------------------------
clear
cd '/Volumes/HARD_DRIVE/Infants/rawdata/'
% cd '/Users/bcdlab1601/Desktop/BEES ADULT ERP Net Station Processing/RAW mff'
filematALL = dir('BEES_PRE_206_6_train_20190930_093020.mff'); % This loads a struct of files of a specific condition e.g. (Pre)    
filemat = {filematALL.name}'; % This takes the just the names from that struct and transposes the list so its in the correct format
pathToFiles = ['/Volumes/HARD_DRIVE/Infants/rawdata/'];
for j = 1:size(filemat,1)
    subject_string = deblank(filemat(j,:));
    Csubject = char(subject_string);
    C = strsplit(Csubject,'.');
    subject = char(C(1,1));
    EEG = pop_mffimport(strcat(pathToFiles,Csubject), {'code'});
    EEG = eeg_checkset( EEG );
    EEG = pop_resample( EEG, 500);
    EEG = eeg_checkset( EEG );
    EEG = pop_saveset(EEG, 'filename', strcat('/Volumes/HARD_DRIVE/Infants/rawdata/setfiles/',subject,'.set'))
end