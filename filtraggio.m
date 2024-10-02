% Applicazione di filtraggio immagini
% Autore: Alessandro Marconcini
% Matricola: VR421504
% Esame: Elaborazione di segnali e immagini

function [I_filtrata] = filtraggio(I,map)

% Proiezione immagine originale
%figure(1)
%imshow(I,map)
%title('Immagine caricata originale')

% Proiezione dell'istogramma ricavabile dall'immagine originale
%figure(2)
istogramma_originale = imhist(I)
%plot(istogramma_originale)
%title('Istogramma immagine originale')

% Check immagini sovraesposte / sottoesposte

% Variabili
somma_colori_scuri = 0
somma_colori_chiari = 0
somma_colori_chiari1 = 0
somma_colori_chiari2 = 0
SNRmse1 = 0
SNRmse2 = 0
SNRmse3 = 0
SNRmse4 = 0
SNRmse5 = 0
SNRmse6 = 0
SNRmse7 = 0
SNRmse8 = 0
str1 = ''
str2 = ''
str3 = ''

for i = 0: uint8(255/7)
    somma_colori_scuri = somma_colori_scuri + istogramma_originale(i+1)
end

for i = uint8(255-255/3):255
    somma_colori_chiari = somma_colori_chiari + istogramma_originale(i+1)
end

for i = uint8(255-255/4):255
    somma_colori_chiari1 = somma_colori_chiari1 + istogramma_originale(i+1)
end

for i = uint8(255-255/5):255
    somma_colori_chiari2 = somma_colori_chiari2 + istogramma_originale(i+1)
end

if somma_colori_scuri > numel(I)/2
    figure(3)
    im_equalizzata = histeq(I)
    imshowpair(I,im_equalizzata,'montage')
    title('Immagine sottoesposta sottoposta a equalizzazione del suo istogramma')
    %fprintf('Immagine sottoesposta!\n')
    I_filtrata = im_equalizzata
    
elseif somma_colori_chiari > numel(I)/2
    
    figure(3)
    %Definite 3 soglie di contrasto per sistemare l'immagine
    
    if somma_colori_chiari2 > numel(I)/2 
        im_stirata = imadjust(I,[190 255]/255,[0 1])
        %fprintf('Strada1\n')
        
    elseif somma_colori_chiari1 > numel(I)/2
        im_stirata = imadjust(I,[150 255]/255,[0 1])
        fprintf('Strada2\n')
        
    else
        im_stirata = imadjust(I,[100 255]/255,[0 1])
        fprintf('Strada3\n')
    end
    
    imshowpair(I,im_stirata,'montage')
    title('Immagine sovraesposta sottoposta a stretching')
    I_filtrata = im_stirata
else 
    
    %Da questo momento valuto la bontà dell'immagine attraverso l' SNR
    % Più alto è l'SNR, migliore sarà l'immagine
    % Vengono proposte le tre immagini con SNR più alto e poi l'utente
    % sceglie quella risultante migliore
    
    % Filtraggio mediano standard
    im_filtrata_con_smoothing = medfilt2(I)
    result0 = im_filtrata_con_smoothing
    SNRmse0 = sum(im_filtrata_con_smoothing(:).^2)/sum((im_filtrata_con_smoothing(:)-I(:)).^2)
    
    % Filtraggio mediano 5 x 5
    im_filtrata_con_smoothing = medfilt2(I,[5 5])
    result1 = im_filtrata_con_smoothing
    SNRmse1 = sum(im_filtrata_con_smoothing(:).^2)/sum((im_filtrata_con_smoothing(:)-I(:)).^2)
    
    % Filtraggio mediano 11 x 11
    im_filtrata_con_smoothing = medfilt2(I,[11 11])
    result2 = im_filtrata_con_smoothing
    SNRmse2 = sum(im_filtrata_con_smoothing(:).^2)/sum((im_filtrata_con_smoothing(:)-I(:)).^2)
    
    % Filtraggio di media 3x3
    H = fspecial('average')
    im_filtrata_con_smoothing = imfilter(I,H,'replicate')
    im_sharpened = imsharpen(im_filtrata_con_smoothing,'Radius',1,'Amount',2)
    result3 = im_sharpened 
    SNRmse3 = sum(im_sharpened(:).^2)/sum((im_sharpened(:)-I(:)).^2)
    
    % Filtraggio di media 5x5
    H = fspecial('average',[5 5])
    im_filtrata_con_smoothing = imfilter(I,H,'replicate')
    im_sharpened = imsharpen(im_filtrata_con_smoothing,'Radius',1,'Amount',2)
    result4 = im_sharpened 
    SNRmse4 = sum(im_sharpened(:).^2)/sum((im_sharpened(:)-I(:)).^2)
    
    % Filtraggio di media 11x11
    H = fspecial('average',[11 11])
    im_filtrata_con_smoothing = imfilter(I,H,'replicate')
    im_sharpened = imsharpen(im_filtrata_con_smoothing,'Radius',1,'Amount',2)
    result5 = im_sharpened 
    SNRmse5 = sum(im_sharpened(:).^2)/sum((im_sharpened(:)-I(:)).^2)
    
    %Filtraggio gaussiano + media
    H = fspecial('gaussian',3,0.6)
    im_filtrata_con_smoothing = imfilter(I,H,'replicate')
    K = fspecial('average')
    im_filtrata_con_smoothing = imfilter(im_filtrata_con_smoothing,K,'replicate')
    im_sharpened = imsharpen(im_filtrata_con_smoothing,'Radius',10,'Amount',1)
    result6 = im_sharpened 
    SNRmse6 = sum(im_sharpened(:).^2)/sum((im_sharpened(:)-I(:)).^2)
    
    %Filtraggio mediano + media + gaussiano
    H1 = fspecial('gaussian',3,0.6)
    H2 = fspecial('average')
    
    I3 = medfilt2(I)
    I1 = imfilter(I3,H1,'replicate')
    I2 = imfilter(I1,H2,'replicate')
    im_sharpened = imsharpen(I2,'Radius',1,'Amount',2)
    result7 = im_sharpened 
    SNRmse7 = sum(im_sharpened(:).^2)/sum((im_sharpened(:)-I(:)).^2)
    
    %Filtraggio passa basso gaussiano con frequenza di cut-off 100 Hz
    %result8 = fpbg(I,100)
    %SNRmse8 = sum(result8(:).^2)/sum((result8(:)-I(:)).^2)
    
    %Check dell'SNR misurato nelle varie sezioni
   
    SNR_vec = [SNRmse0;SNRmse1;SNRmse2;SNRmse3;SNRmse4;SNRmse5;SNRmse6;SNRmse7;SNRmse8]
    
    % Scarto i valori di SNR superiori al 12 (solitamente immagine troppo
    % simile all'originale
    
    for i = 1:8
        if SNR_vec(i) > 12
            SNR_vec(i) = 0
        end
    end
    
    
   figure(3)
   subplot(221); imshow(I,map); colorbar; title('Immagine originale');
    
   % PRIMA IMMAGINE MIGLIORE
   if max(SNR_vec) == SNRmse0
     prima = result0
     SNR_vec(1) = 0
     str1 = 'Filtro mediano standard'
   elseif max(SNR_vec) == SNRmse1
     prima = result1
     SNR_vec(2) = 0
     str1 = 'Filtro mediano 5x5'
   elseif max(SNR_vec) == SNRmse2
     prima = result2
     SNR_vec(3) = 0
     str1 = 'Filtro mediano 11x11'
   elseif max(SNR_vec) == SNRmse3
     prima = result3
     SNR_vec(4) = 0
     str1 = 'Filtro di media 3x3'
   elseif max(SNR_vec) == SNRmse4
     prima = result4
     SNR_vec(5) = 0
     str1 = 'Filtro di media 5x5'
   elseif max(SNR_vec) == SNRmse5
     prima = result5
     SNR_vec(6)
     str1 = 'Filtro di media 11x11'
   elseif max(SNR_vec) == SNRmse6
     prima = result6
     SNR_vec(7) = 0
     str1 = 'Filtro gaussiano + media standard'
   elseif max(SNR_vec) == SNRmse7
     prima = result7
     SNR_vec(8) = 0
     str1 = 'Filtro mediano + media + gaussiano'
   elseif max(SNR_vec) == SNRmse8
     prima = result8
     SNR_vec(9) = 0
     str1 = 'Filtro passa basso con frequenza di cut-off 100 Hz'
   else
       prima = I
   end
   
   subplot(222); imshow(prima,map); colorbar;title(strcat('1 ',str1,' (Consigliata)'))
   SNR_vec
     
    % SECONDA IMMAGINE MIGLIORE 
    if max(SNR_vec) == SNRmse0
     seconda = result0
     SNR_vec(1) = 0
     str2 = 'Filtro mediano standard'
   elseif max(SNR_vec) == SNRmse1
     seconda = result1
     SNR_vec(2) = 0
     str2 = 'Filtro mediano 5x5'
   elseif max(SNR_vec) == SNRmse2
     seconda = result2
     SNR_vec(3) = 0
     str2 = 'Filtro mediano 11x11'
   elseif max(SNR_vec) == SNRmse3
     seconda = result3
     SNR_vec(4) = 0
     str2 = 'Filtro media 3x3'
   elseif max(SNR_vec) == SNRmse4
     seconda = result4
     SNR_vec(5) = 0
     str2 = 'Filtro media 5x5'
   elseif max(SNR_vec) == SNRmse5
     seconda = result5
     SNR_vec(6) = 0
     str2 = 'Filtro media 11x11'
   elseif max(SNR_vec) == SNRmse6
     seconda = result6
     SNR_vec(7) = 0
     str2 = 'Filtro gaussiano + media'
   elseif max(SNR_vec) == SNRmse7
     seconda = result7
     SNR_vec(8) = 0
     str2 = 'Filtro mediano + media + gaussiano'
   elseif max(SNR_vec) == SNRmse8
     seconda = result8
     SNR_vec(9) = 0
     str2 = 'Filtro pass basso con frequenza di cut-off 100 Hz'
    else
        seconda = I
    end
    
    subplot(223); imshow(seconda,map); colorbar;title(strcat('2 ',str2))
     
   % TERZA IMMAGINE MIGLIORE
   if max(SNR_vec) == SNRmse0
     terza = result0
     SNR_vec(1) = 0
     str3 = 'Filtro mediano standard'
   elseif max(SNR_vec) == SNRmse1
     terza = result1
     SNR_vec(2) = 0
     str3 = 'Filtro mediano 5x5'
   elseif max(SNR_vec) == SNRmse2
     terza = result2
     SNR_vec(3) = 0
     str3 = 'Filtro mediano 11x11'
   elseif max(SNR_vec) == SNRmse3
     terza = result3
     SNR_vec(4) = 0
     str3 = 'Filtro media 3x3'
   elseif max(SNR_vec) == SNRmse4
     terza = result4
     SNR_vec(5) = 0
     str3 = 'Filtro media 5x5'
   elseif max(SNR_vec) == SNRmse5
     terza = result5
     SNR_vec(6) = 0
     str3 = 'Filtro media 11x11'
   elseif max(SNR_vec) == SNRmse6
     terza = result6
     SNR_vec(7) = 0
     str3 = 'Filtro gassiano + media'
   elseif max(SNR_vec) == SNRmse7
     terza = result7
     SNR_vec(8) = 0
     str3 = 'Filtro media + mediano + gaussiano'
   elseif max(SNR_vec) == SNRmse8
     terza = result8
     SNR_vec(9) = 0
     str3 = 'Filtro passa basso con frequenza di cut-off 100 Hz'
   else
       terza = I
   end
   
   subplot(224); imshow(terza,map); colorbar;title(strcat('3 ',str3))
   
   in2 = input('Scegliere quella più qualitativamente valida [0-3]\n','s')
   
   while in2 ~= '1' && in2 ~= '2' && in2 ~= '3' && in2 ~= '0'
       in2 = input('Scegliere un numero tra 1 e 3!\n','s')
   end
   
   if in2 == '1'
       I_filtrata = prima
   elseif in2 == '2'
       I_filtrata = seconda
   elseif in2 == '3'
       I_filtrata = terza
   elseif in2 == '0'
       I_filtrata = I
   end
   
end

