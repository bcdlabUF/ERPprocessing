clear
cd '/Volumes/HARD_DRIVE/Infants/rawdata/setfiles/'
% filematALL = dir('BEES_127_12_TRAIN.set'); % This loads a struct of files of a specific condition e.g. (Pre)    
filematALL = dir('BEES_206_6.set');
filemat = {filematALL.name}'; % This takes the just the names from that struct and transposes the list so its in the correct format
pathToFiles = ['/Volumes/HARD_DRIVE/Infants/rawdata/setfiles/'];

for j = 1:size(filemat,1)
    subject_string = deblank(filemat(j,:));
    Csubject = char(subject_string);
    C = strsplit(Csubject,'.');
    subject = char(C(1,1));
    EEG = pop_loadset('filename', Csubject);
    Cat_count = 0;
    Ind_count = 0;
    for i = 1:size(EEG.event,2)
        if EEG.event(i).type == 'ct02'
            Cat_count = Cat_count + 1;
            if Cat_count < 25
                EEG.event(i).code = 'ct07';
                EEG.event(i).type = 'ct07';
                EEG.event(i).label = 'ct07';
            elseif Cat_count >=25
                EEG.event(i).code = 'ct08';
                EEG.event(i).type = 'ct08';
                EEG.event(i).label = 'ct08';
            end
            
        elseif EEG.event(i).type =='it01'
            Ind_count = Ind_count +1;
            if Ind_count < 25
                EEG.event(i).code = 'it05';
                EEG.event(i).type = 'it05';
                EEG.event(i).label = 'it05';
            elseif Ind_count >=25
                EEG.event(i).code = 'it06';
                EEG.event(i).type = 'it06';
                EEG.event(i).label = 'it06';
            end
        end   
    end
    EEG = pop_saveset(EEG, 'filename', strcat(subject,'_halves.set'))
end
    

