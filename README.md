# ERPprocessing
Scripts to process ERP data

Stimuli_ERPtrain.m is the script used to present the stimuli during testing.

The script Step1_Create_setfile_batch.m will batch convert .mff files to .set file

Then use Step2_Add_TrlNum_Halves.m, which creates and separates each condition into first and second half 
(individual first half, category second half, etc.)

The final script, Step3_filt_eventlist_seg_clean.m, bandpass filter the data (.5-30hz), creates an eventlist, assign bins, 
epochs, and cleans data (calls on BEES_clean_data_batch.m). We then complete manual artifact detection of the cleaned data.
