      function y = ERPtrain()        
%Initial set-up
clc;
clear; 
 
% if usejava
%     ('System.time')
%     disp('error loading java  package "System.time"');
%     return;
% end
if usejava('java.util.LinkedList') 
    disp('error loading java package "java.util.LinkedList"');
    return;
end
if usejava('java.util.ArrayDeque')  
    disp('error loading java package "java.util.ArrayDeq ue"');
    return;
end 
       
rand('state',sum(100*clock));

% Prompt box for subnum and counterbalance; creates variables for these
prompt = {'Subject Number'};
defaults = {'1'};
answer = inputdlg(prompt,'subject',1,defaults);
if(size(answer) ~= 1)
    clear;
    clc;
    disp('Exiting.'); 
    return;
end
  [subject] = deal(answer{:});  


% which order?
orderArray = {'1a','1b','1c','1d','1e','1f','2a','2b','2c','2d','2e','2f','3a','3b','3c','3d','3e','3f'};
[selectionIndex3, leftBlank] = listdlg('PromptString', 'Select an order to run:', 'SelectionMode', 'single', 'ListString', orderArray);
order= orderArray{selectionIndex3};

imagepath = 'C:\Users\vpixx\Desktop\ERP training task\Images\allimages\';
labelpath = 'C:\Users\vpixx\Desktop\ERP training task\Audio\alllabels\';

% Set stimuli directories for each species (to present images)
if strcmp(order, '1a') || strcmp(order, '1b') ||  strcmp(order, '1c')||  strcmp(order, '1d')||  strcmp(order, '1e')||  strcmp(order, '1f')
    
  indpath = 'C:\Users\vpixx\Desktop\ERP training task\Images/species1/';
  catpath = 'C:\Users\vpixx\Desktop\ERP training task\Images/species2/';

elseif strcmp(order, '2a') || strcmp(order, '2b') ||  strcmp(order, '2c')||  strcmp(order, '2d')||  strcmp(order, '2e')||  strcmp(order, '2f')
  
  indpath = 'C:\Users\vpixx\Desktop\ERP training task\Images/species2/';
  catpath = 'C:\Users\vpixx\Desktop\ERP training task\Images/species3/';

elseif strcmp(order, '3a') || strcmp(order, '3b') ||  strcmp(order, '3c')||  strcmp(order, '3d')||  strcmp(order, '3e')||  strcmp(order, '3f')

  indpath = 'C:\Users\vpixx\Desktop\ERP training task\Images/species3/';
  catpath = 'C:\Users\vpixx\Desktop\ERP training task\Images/species1/';
  
end
 
indlabelspath = 'C:\Users\vpixx\Desktop\ERP training task\Audio/Individual/';

if strcmp(order, '1a') || strcmp(order, '1b') ||strcmp(order, '1c') || strcmp(order, '2a') || strcmp(order, '2b') ||strcmp(order, '2c') || strcmp(order, '3a') || strcmp(order, '3b') ||strcmp(order, '3c')
    catlabelspath = 'C:\Users\vpixx\Desktop\ERP training task\Audio/Hitchel/';
elseif strcmp(order, '1d') || strcmp(order, '1e') ||strcmp(order, '1f') || strcmp(order, '2d') || strcmp(order, '2e') ||strcmp(order, '2f') || strcmp(order, '3d') || strcmp(order, '3e') ||strcmp(order, '3f')
    catlabelspath = 'C:\Users\vpixx\Desktop\ERP training task\Audio/Wadgen/';
end


%List out the files in the directories
    indmat=dir(indpath);
    catmat=dir(catpath);
    indmat = {indmat.name}';
    catmat = {catmat.name}';
    indlabelmat =dir(indlabelspath);
    catlabelmat = dir(catlabelspath);
    indlabelmat = {indlabelmat.name}';
    catlabelmat = {catlabelmat.name}';
    
    indmat= indmat(3:size(indmat,1),:);
    catmat= catmat(3:size(catmat,1),:);
    indlabelmat= indlabelmat(3:size(indlabelmat,1),:);
    catlabelmat= catlabelmat(3:size(catlabelmat,1),:);

if strcmp(order,'1a')|| strcmp(order,'2a')|| strcmp(order,'3a')||strcmp(order,'1d')|| strcmp(order,'2d')|| strcmp(order,'3d')
    indmat = indmat([1 5 6 7],:);
    catmat = catmat([1 5 6 7],:);
elseif strcmp(order,'1b')|| strcmp(order,'2b')|| strcmp(order,'3b')||strcmp(order,'1e')|| strcmp(order,'2e')|| strcmp(order,'3e')
    indmat = indmat([8 9 10 11],:);
    catmat = catmat([8 9 10 11],:);
elseif strcmp(order,'1c')|| strcmp(order,'2c')|| strcmp(order,'3c')||strcmp(order,'1f')|| strcmp(order,'2f')|| strcmp(order,'3f')
    indmat = indmat([12 2 3 4],:);
    catmat = catmat([12 2 3 4],:);
end

nobjects =4
    % Shuffle order of each species and create a randomized list of each
    % species
    
    RandInd = randperm(nobjects);
    RandCat = randperm(nobjects);
    RandLabel = randperm(6);

    indmat = indmat(RandInd);
    catmat = catmat(RandCat);
    indlabelmat = indlabelmat(RandLabel);
    indlabelmat = indlabelmat([1 2 3 4]);
    catlabelmat = catlabelmat(RandCat);
  
if strcmp(order,'1a')|| strcmp(order,'2a') || strcmp(order,'3a')||strcmp(order,'1c')|| strcmp(order,'2c') || strcmp(order,'3c')|| strcmp(order,'1e')|| strcmp(order,'2e') || strcmp(order,'3e')
    imagemat = [indmat;catmat];
    labelmat = [indlabelmat;catlabelmat];
elseif strcmp(order,'1b')|| strcmp(order,'2b') || strcmp(order,'3b')||strcmp(order,'1d')|| strcmp(order,'2d') || strcmp(order,'3d')|| strcmp(order,'1f')|| strcmp(order,'2f') || strcmp(order,'3f')
    imagemat = [catmat;indmat];
    labelmat = [catlabelmat;indlabelmat];
end

  
        % files
        datafilename = strcat('erp_train_',subject,'.dat'); % name of data file to write to
        subNo=str2num(subject);
        % check for existing file (except for subject numbers > 99)
        if subNo<99 && fopen(datafilename, 'rt')~=-1
            error('data files exist!');
        else
            datafilepointer = fopen(datafilename,'wt'); % open ASCII file for writing
        end
        
    

    % Connect to NetStation
    DAC_IP = '10.10.10.42';
    NetStation('Connect', DAC_IP, 55513);
    NetStation('Synchronize');
    NetStation('StartRecording');
     
try
    AssertOpenGL;
    % Set up the screen
    Screen('Preference', 'SkipSyncTests', 0);
    screennum = 2;
    white = WhiteIndex(screennum);
    gray = GrayIndex(screennum);
    black = BlackIndex(screennum);
    [w, wRect] = Screen('OpenWindow',screennum,gray);
    Screen(w,'BlendFunction',GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    fps=Screen('FrameRate',w)  % frames per second
    hz=Screen(screennum,'FrameRate',[], fps);
    


% start the task

    nblocksERP = 12;
    
% initialize stimuli for task
    import java.util.LinkedList;
    import java.util.ArrayDeque;
    presStims1 = LinkedList();
    presStims2 = LinkedList();
    
% Use realtime priority for better timing precision:
priorityLevel=MaxPriority(w);
Priority(priorityLevel);

     % write message to subject
        Screen('DrawText', w, 'Please press mouse key to start ...', 10, 10, 255);
        Screen('Flip', w); % show text
        disp('Press mouse key to start')
        % wait for mouse press ( no GetClicks  :(  )
        buttons=0;
            while ~any(buttons) % wait for press
                [x,y,buttons] = GetMouse;
                % Wait 10 ms before checking the mouse again to prevent
                % overload of the machine at elevated Priority()
                WaitSecs(0.01);
            end
        % clear screen
        Screen('Flip', w);

    
for block = 1:nblocksERP
        
           RandOrder = randperm(nobjects);
           RandOrder = [RandOrder RandOrder+4];
           imagemat = imagemat(RandOrder);
           labelmat = labelmat(RandOrder);
         for trial = 1:length(imagemat);
             imagename = strcat(imagepath,imagemat(trial,:));
             soundname = strcat(labelpath,labelmat(trial,:));
             imagename = char(imagename);
             presStims1.add(imagename); 
             presStims2.add(soundname);
         end
        

 
screens = ArrayDeque(8);

%    for trial = 1:length(imagemat);     
%         [imdata, map, imdata_alpha] = imread(char(presStims1.remove())); 
% %         [imdata, map, imdata_alpha] = imread(imagename);
%          imdata(:,:,4)=imdata_alpha; % added alpha layer to 2 because images are greyscale
%          mytex = Screen('MakeTexture', w, imdata);
% %          screens.add(mytex);
%    end

for trial = 1:length(imagemat);
    
[imdata, map, imdata_alpha] = imread(char(presStims1.remove())); 

imdata(:,:,4)=imdata_alpha; % added alpha layer to 4 because images are png
mytex = Screen('MakeTexture', w, imdata);
screens.add(mytex);
end


for trial = 1:length(imagemat);
if strcmp(order,'1a')|| strcmp(order,'2a') || strcmp(order,'3a')||strcmp(order,'1c')|| strcmp(order,'2c') || strcmp(order,'3c')|| strcmp(order,'1e')|| strcmp(order,'2e') || strcmp(order,'3e')            
             if trial < 5
                 tag='it01';
                 soundlabel = 'il03';
             elseif trial >4
                 tag='ct02';
                 soundlabel = 'cl04';
             end
elseif strcmp(order,'1b')|| strcmp(order,'2b') || strcmp(order,'3b')||strcmp(order,'1d')|| strcmp(order,'2d') || strcmp(order,'3d')|| strcmp(order,'1f')|| strcmp(order,'2f') || strcmp(order,'3f') 
             if trial > 4 
                 tag='it01';
                 soundlabel = 'il03';
             elseif trial < 5
                 tag='ct02';
                 soundlabel = 'cl04';
             end
end
 

           [X,Y] = RectCenter(wRect); % Centers fixation cross
           FixCross = [X-1,Y-20,X+1,Y+20;X-20,Y-1,X+20,Y+1]; % Fixation cross size
           Screen('FillRect', w, gray);
           Screen('FillRect', w, black, FixCross');
           Screen('Flip',w);
           s3 = GetSecs;
           NetStation('Event','fix+',s3,0.001, 'fix+', 1);
           [xpos,ypos,buttons] = GetMouse(w);
        

        Dist_images = dir(fullfile('/Images/Distractors/'));
        Dist_sounds = dir(fullfile('/Audio/Distractors/'));
        Dist_imagesList = 'Distractor_image.txt';
        Dist_soundList = 'Distractor_audio.txt';
        [Dist_imageNames] = textread(Dist_imagesList,'%s'); %#ok<*REMFF1>
        [Dist_soundNames] = textread(Dist_soundList,'%s'); %#ok<*REMFF1>
        nDist_files = length(Dist_imageNames);
        current_dist=randi(nDist_files);
        current_dist_image = Dist_imageNames(current_dist);
        current_dist_sound = Dist_soundNames(current_dist);
        dist_image_filename = strcat('/Images/Distractors/', char(current_dist_image));
        dist_sound_filename = strcat('/Audio/Distractors/', char(current_dist_sound));         
        
        disimagedata2 = imread(char(dist_image_filename));
        dissoundfile = dist_sound_filename;
        
                InitializePsychSound;
                Channels = 1;
                %MySoundFreq = 11025;
                if current_dist ==1 
                    MySoundFreq = 32000;
                else
                    MySoundFreq = 48000;
                end
                disp(dissoundfile)
                diswavdata = transpose(audioread(dissoundfile));
                MySoundHandle = PsychPortAudio('Open',[],[],0,MySoundFreq,Channels);
                FinishTime1 = length(diswavdata)/MySoundFreq;PsychPortAudio('FillBuffer',MySoundHandle,diswavdata,0);
                
                %gives chance to use distractors by looking until mouse click
                [keyIsDown] = KbCheck(); %Listens for Keypresses
                [xpos,ypos,buttons] = GetMouse();
                while ~any(buttons) % Loops while no mouse buttons are pressed
                    [keyIsDown] = KbCheck();
                    [xpos,ypos,buttons] = GetMouse();
                    if any(keyIsDown)
                        %Send trigger to Netstation that the attention
                        %getter is playing
                        
                        
                        disrand = char(randi(4));
                        
                        disimage = Screen('MakeTexture',w,disimagedata2);
                        
                        Screen('DrawTexture',w,disimage);
                        [attnon] = Screen('Flip',w);
                        
                        PsychPortAudio('Start',MySoundHandle,1,0,1);
                        NetStation('Event','ag99', attnon, attnon+cputime, 'attn', 2);
                        WaitSecs(FinishTime1);
                        
                        Screen(w, 'FillRect', gray);
                        Screen('Flip',w);
                        WaitSecs(.01);
                        KbEventFlush; 
                   
                    end
                end
           
                KbEventFlush;

               [xpos,ypos,buttons] = GetMouse(w); % Waits for mouseclicks. same as KbWait
               
               MySoundFreq = 96000;
               %MySound = char(soundname);
               MySound = char(presStims2.remove());
               MySoundData = transpose(audioread(MySound));
               FinishTime = length(MySoundData)/MySoundFreq;
               MySoundHandle = PsychPortAudio('Open',[],[],0,MySoundFreq,Channels);
               PsychPortAudio('FillBuffer',MySoundHandle,MySoundData,0);
             disp('Click mouse to present trials')
             

               if any(buttons) % Present image on mouseclick
                   Screen('FillRect', w, gray);
                   Screen('FillRect', w, black, FixCross');
                   Screen('Flip',w);
                   t1=GetSecs;
                   NetStation('Event','fix+',t1,0.001, 'fix+', 3);
                   WaitSecs((rand() / 5.0) +.15);% jitter interstimulus interval (length of fix cross)
                   t2=GetSecs;
                   NetStation('Event','fix-',t2,0.001, 'fix-', 4);
                   WaitSecs(0.02);
%                   screen = screens.getFirst();
                   screen = screens.removeFirst();          
                   Screen('FillRect', w, black);
%                     Screen('DrawTexture',w,mytex);
                    Screen('DrawTexture', w, screen);
                   
                   [stimOn] = Screen('Flip',w);
                   t3=GetSecs;
%                    NetStation('Event', 'stm+',stimOn,0.001, 'stm+', 5);
                   tic
                   NetStation('Event', tag,stimOn,0.001, 'imag', 6);
                   WaitSecs((rand() / 50.0) +.01); % Jitter onset time between 10-30ms post-face onset
                   t4=GetSecs;
                   startTime = PsychPortAudio('Start',MySoundHandle,1,0,1); 
                   NetStation('Event',soundlabel,GetSecs,0.001, 'labl', 7);
                   elapse = t4-t3
                   WaitSecs(FinishTime- elapse);
                   imageDur=toc
                   Screen('Flip',w);  
                   s2 = GetSecs;
                   
                  NetStation('Event','stm-',s2,0.001, 'stm-', 8)
               end  
                WaitSecs((rand() / 5.0) + 0.5); %jittered intertrial interval
                
%                Screen('Close');
                   PsychPortAudio('Close');
               disp('close')
                         
                            fprintf(datafilepointer,'%i %i %i %s %s \n', ...
                            subNo, ...
                            trial, ...
                            imageDur, ...
                            char(imagemat(trial,:)), ...
                            char(labelmat(trial,:))); 
       
end
  Screen('Close');      
        
end
        

                                      

                 
               
               

                         

           Screen('Close'); % Supposed to clean up old textures
          
       

%        fprintf(fid,'%s\t%d\t%d\t%d\t%s\n',subject,counterbalance,Task,Trial,char(standardshow));
   
    
    
               
    NetStation('Synchronize');
    NetStation('StopRecording');
    NetStation('Disconnect', DAC_IP);


     %Listens for Keypresses
    [xpos,ypos,buttons] = GetMouse();
     while ~any(buttons) % Loops while no mouse buttons are pressed
          [keyIsDown] = KbCheck();
          [xpos,ypos,buttons] = GetMouse();
           if any(keyIsDown)
               Screen('CloseAll');
           end
     end
    
    %PsychPortAudio('Stop',MySoundHandle);
    %PsychPortAudio('Close',MySoundHandle);
    
    Priority(1);  %reset the priority
    
    % clc;    % clear the screen
%     clear;  % clear the workspace

    disp('Process complete.');


catch
    Screen('CloseAll');
    ShowCursor;
    Priority(0);
    
    psychrethrow(psychlasterror);
end


end
  