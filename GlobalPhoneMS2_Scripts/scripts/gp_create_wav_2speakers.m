% gp_create_wav_2_speakers.m
%
% Create 2-speaker mixtures out of GlobalPhone 2000 Speaker Package
% 
% This script assumes that GlobalPhone 2000 Speaker Package is available as
% unzipped folder.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Copyright (C) 2016 Mitsubishi Electric Research Labs 
%                          (Jonathan Le Roux, John R. Hershey, Zhuo Chen)
%   Apache 2.0  (http://www.apache.org/licenses/LICENSE-2.0) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Edited by Marvin Borsdorf
% Machine Listening Lab, University of Bremen, Germany
% August, 2020


data_type = {'tr','cv','tt'};
min_max = {'max'}; % Currently only max version is considered

language = {'Arabic', 'Bulgarian', 'Chinese Mandarin', 'Chinese Shanghai', 'Croatian', 'Czech', 'French', 'German', 'Hausa', 'Japanese', 'Korean', 'Polish', 'Portuguese', 'Russian', 'Spanish', 'Swahili', 'Swedish', 'Tamil', 'Thai', 'Turkish', 'Ukrainian', 'Vietnamese'};

    useaudioread = 0;
    if exist('audioread','file')
        useaudioread = 1;
    end

 for i_lang = 1:length(language)  
    GP2k_root = ['D:/GlobalPhone/GlobalPhone 2000 Speakers Package/']; % Unzipped GlobalPhone root folder
    mkdir(['D:/GlobalPhone/GP2k_Mix/Intra_Language/GP2k_2Spk/' language{i_lang} '/wav16k']);
    output_dir16k=['D:/GlobalPhone/GP2k_Mix/Intra_Language/GP2k_2Spk/' language{i_lang} '/wav16k']
    mkdir(['D:/GlobalPhone/GP2k_Mix/Intra_Language/GP2k_2Spk/' language{i_lang} '/wav8k']);
    output_dir8k=['D:/GlobalPhone/GP2k_Mix/Intra_Language/GP2k_2Spk/' language{i_lang} '/wav8k']
    
    for i_mm = 1:length(min_max)
        for i_type = 1:length(data_type)
            if ~exist([output_dir16k '/' min_max{i_mm} '/' data_type{i_type}],'dir') % Create folders
                mkdir([output_dir16k '/' min_max{i_mm} '/' data_type{i_type}]);
            end
            if ~exist([output_dir8k '/' min_max{i_mm} '/' data_type{i_type}],'dir')
                mkdir([output_dir8k '/' min_max{i_mm} '/' data_type{i_type}]);
            end
            status = mkdir([output_dir8k  '/' min_max{i_mm} '/' data_type{i_type} '/s1/']);
            status = mkdir([output_dir8k  '/' min_max{i_mm} '/' data_type{i_type} '/s2/']);
            status = mkdir([output_dir8k  '/' min_max{i_mm} '/' data_type{i_type} '/mix/']);
            status = mkdir([output_dir16k '/' min_max{i_mm} '/' data_type{i_type} '/s1/']);
            status = mkdir([output_dir16k '/' min_max{i_mm} '/' data_type{i_type} '/s2/']);
            status = mkdir([output_dir16k '/' min_max{i_mm} '/' data_type{i_type} '/mix/']);
                    
            TaskFile = ['D:/GlobalPhone/Scripts/' language{i_lang} '/GP2k_speaker_pairs_SNR_' data_type{i_type} '.txt']; % Open speaker pairs .txt file
            fid=fopen(TaskFile,'r');
            C=textscan(fid,'%s %f %s %f'); % Save as array
            
            Source1File = ['D:/GlobalPhone/Scripts/' language{i_lang} '/' language{i_lang} '_GP2k_mix_2_spk_' min_max{i_mm} '_' data_type{i_type} '_1'];
            Source2File = ['D:/GlobalPhone/Scripts/' language{i_lang} '/' language{i_lang} '_GP2k_mix_2_spk_' min_max{i_mm} '_' data_type{i_type} '_2'];
            MixFile     = ['D:/GlobalPhone/Scripts/' language{i_lang} '/' language{i_lang} '_GP2k_mix_2_spk_' min_max{i_mm} '_' data_type{i_type} '_mix'];
            InfoFile    = ['D:/GlobalPhone/Scripts/' language{i_lang} '/' language{i_lang} '_GP2k_mix_2_spk_info.txt'];

            
            fid_s1 = fopen(Source1File,'w');
            fid_s2 = fopen(Source2File,'w');
            fid_m  = fopen(MixFile,'w');
            fid_info = fopen(InfoFile, 'a+');
            
            header = "SpeakerFile1 SNR1 SpeakerFile2 SNR2 ScalingFactor8kHz ScalingFactor16kHz";
            fprintf(fid_info, '%s', header)
            fprintf(fid_info, '\n')

            num_files = length(C{1}); % Number of speaker pairs
            fs8k=8000;
            
            scaling_16k = zeros(num_files,2);
            scaling_8k = zeros(num_files,2);
            scaling16bit_16k = zeros(num_files,1);
            scaling16bit_8k = zeros(num_files,1);
            fprintf(1,'%s\n',[min_max{i_mm} '_' data_type{i_type}]);
            for i = 1:num_files % For each speaker pair (for each row in .txt file)
                [inwav1_dir,invwav1_name,inwav1_ext] = fileparts(C{1}{i}); % Get path, filename and extension of both speech files
                [inwav2_dir,invwav2_name,inwav2_ext] = fileparts(C{3}{i});
                fprintf(fid_s1,'%s\n',C{1}{i});
                fprintf(fid_s2,'%s\n',C{3}{i});
                inwav1_snr = C{2}(i); % SNRs of wave files (given in .txt file -> Calculated in pre-processing)
                inwav2_snr = C{4}(i);
                mix_name = [invwav1_name,'_',num2str(inwav1_snr),'_',invwav2_name,'_',num2str(inwav2_snr)]; % Create mixture name
                fprintf(fid_m,'%s\n',mix_name);
                            
                % Read input wave files
                if useaudioread
                    [s1, fs] = audioread([GP2k_root C{1}{i}]);
                    s2       = audioread([GP2k_root C{3}{i}]);
                else                
                    [s1, fs] = wavread([GP2k_root C{1}{i}]);
                    s2       = wavread([GP2k_root C{3}{i}]);            
                end
                
                % Resample, normalize 8 kHz file, save scaling factor (original speech level)
                s1_8k=resample(s1,fs8k,fs);
                [s1_8k,lev1]=activlev(s1_8k,fs8k,'n'); % y_norm = y /sqrt(lev);
                s2_8k=resample(s2,fs8k,fs);
                [s2_8k,lev2]=activlev(s2_8k,fs8k,'n');
                            
                weight_1=10^(inwav1_snr/20); % Inverse log10(x) to get weight
                weight_2=10^(inwav2_snr/20);
                
                s1_8k = weight_1 * s1_8k; % Weight speeches based on their specific SNR to each other (SNRs given in the file -> pre-processed)
                s2_8k = weight_2 * s2_8k;
                
                switch min_max{i_mm}
                    case 'max'
                        mix_8k_length = max(length(s1_8k),length(s2_8k));
                        s1_8k = cat(1,s1_8k,zeros(mix_8k_length - length(s1_8k),1)); % Pad zeros
                        s2_8k = cat(1,s2_8k,zeros(mix_8k_length - length(s2_8k),1));
                    case 'min'
                        %mix_8k_length = min(length(s1_8k),length(s2_8k));
                        %s1_8k = s1_8k(1:mix_8k_length);
                        %s2_8k = s2_8k(1:mix_8k_length);
                end
                mix_8k = s1_8k + s2_8k; % Create 8 kHz mixture
                        
                max_amp_8k = max(cat(1,abs(mix_8k(:)),abs(s1_8k(:)),abs(s2_8k(:)))); % Find max amp
                mix_scaling_8k = 1/max_amp_8k*0.9;
                s1_8k = mix_scaling_8k * s1_8k;
                s2_8k = mix_scaling_8k * s2_8k;
                mix_8k = mix_scaling_8k * mix_8k;
                
                % Apply same procedure and weights to 16 kHz files
                s1_16k = weight_1 * s1 / sqrt(lev1);
                s2_16k = weight_2 * s2 / sqrt(lev2);
                
                switch min_max{i_mm}
                    case 'max'
                        mix_16k_length = max(length(s1_16k),length(s2_16k));
                        s1_16k = cat(1,s1_16k,zeros(mix_16k_length - length(s1_16k),1)); % Pad zeros
                        s2_16k = cat(1,s2_16k,zeros(mix_16k_length - length(s2_16k),1));
                    case 'min'
                        %mix_16k_length = min(length(s1_16k),length(s2_16k));
                        %s1_16k = s1_16k(1:mix_16k_length);
                        %s2_16k = s2_16k(1:mix_16k_length);
                end
                mix_16k = s1_16k + s2_16k; % Create 16 kHz mixture
                
                max_amp_16k = max(cat(1,abs(mix_16k(:)),abs(s1_16k(:)),abs(s2_16k(:)))); % Find max amp
                mix_scaling_16k = 1/max_amp_16k*0.9;
                s1_16k = mix_scaling_16k * s1_16k;
                s2_16k = mix_scaling_16k * s2_16k;
                mix_16k = mix_scaling_16k * mix_16k;            
                
                % Save 8 kHz and 16 kHz mixtures, as well as necessary scaling factors
                scaling_16k(i,1) = weight_1 * mix_scaling_16k/ sqrt(lev1);
                scaling_16k(i,2) = weight_2 * mix_scaling_16k/ sqrt(lev2);
                scaling_8k(i,1) = weight_1 * mix_scaling_8k/ sqrt(lev1);
                scaling_8k(i,2) = weight_2 * mix_scaling_8k/ sqrt(lev2);
                
                scaling16bit_16k(i) = mix_scaling_16k;
                scaling16bit_8k(i)  = mix_scaling_8k;
                
                if useaudioread                          
                    s1_8k = int16(round((2^15)*s1_8k));
                    s2_8k = int16(round((2^15)*s2_8k));
                    mix_8k = int16(round((2^15)*mix_8k));
                    s1_16k = int16(round((2^15)*s1_16k));
                    s2_16k = int16(round((2^15)*s2_16k));
                    mix_16k = int16(round((2^15)*mix_16k));
                    audiowrite([output_dir8k '/' min_max{i_mm} '/' data_type{i_type} '/s1/' mix_name '.wav'],s1_8k,fs8k);
                    audiowrite([output_dir16k '/' min_max{i_mm} '/' data_type{i_type} '/s1/' mix_name '.wav'],s1_16k,fs);
                    audiowrite([output_dir8k '/' min_max{i_mm} '/' data_type{i_type} '/s2/' mix_name '.wav'],s2_8k,fs8k);
                    audiowrite([output_dir16k '/' min_max{i_mm} '/' data_type{i_type} '/s2/' mix_name '.wav'],s2_16k,fs);
                    audiowrite([output_dir8k '/' min_max{i_mm} '/' data_type{i_type} '/mix/' mix_name '.wav'],mix_8k,fs8k);
                    audiowrite([output_dir16k '/' min_max{i_mm} '/' data_type{i_type} '/mix/' mix_name '.wav'],mix_16k,fs);
                else
                    wavwrite(s1_8k,fs8k,[output_dir8k '/' min_max{i_mm} '/' data_type{i_type} '/s1/' mix_name '.wav']);
                    wavwrite(s1_16k,fs16k,[output_dir16k '/' min_max{i_mm} '/' data_type{i_type} '/s1/' mix_name '.wav']);
                    wavwrite(s2_8k,fs8k,[output_dir8k '/' min_max{i_mm} '/' data_type{i_type} '/s2/' mix_name '.wav']);
                    wavwrite(s2_16k,fs16k,[output_dir16k '/' min_max{i_mm} '/' data_type{i_type} '/s2/' mix_name '.wav']);
                    wavwrite(mix_8k,fs8k,[output_dir8k '/' min_max{i_mm} '/' data_type{i_type} '/mix/' mix_name '.wav']);
                    wavwrite(mix_16k,fs16k,[output_dir16k '/' min_max{i_mm} '/' data_type{i_type} '/mix/' mix_name '.wav']);
                end

                % Save information (SpeakerIDs, UtteranceIDs, SNRs, Scalings8k, Scalings16k) for 8 kHz and 16 kHz
                mix_info = [inwav1_dir invwav1_name ' ' num2str(inwav1_snr) ' ' inwav2_dir, invwav2_name ' ' num2str(inwav2_snr) ' ' num2str(mix_scaling_8k) ' ' num2str(mix_scaling_16k)];
                fprintf(fid_info, '%s', mix_info)
                fprintf(fid_info, '\n')

                if mod(i,10)==0
                    fprintf(1,'.');
                    if mod(i,200)==0
                        fprintf(1,'\n');
                    end
                end
                
            end
            save([output_dir8k  '/' min_max{i_mm} '/' data_type{i_type} '/scaling8k.mat'],'scaling_8k','scaling16bit_8k');
            save([output_dir16k '/' min_max{i_mm} '/' data_type{i_type} '/scaling16k.mat'],'scaling_16k','scaling16bit_16k');

            fclose(fid);
            fclose(fid_s1);
            fclose(fid_s2);
            fclose(fid_m);
            fclose(fid_info);
        end
    end
end
