% Applicazione di filtraggio immagini
% Autore: Alessandro Marconcini
% Matricola: VR421504
% Esame: Elaborazione di segnali e immagini


clear all
clc

str = 'Inserisci il nome del file del tipo "file.fmt"\n'
in = input(str,'s')

[I,map] = imread(in)
I = im2gray(I)
 
I_filtrata = filtraggio(I,map)

str = 'Provare a filtrare di nuovo ? S/N\n'
in = input(str,'s')

while in ~= 'S' && in ~= 's' && in ~= 'N' && in ~= 'n'
    in = input('Reinserire la risposta!\n','s')
end

if in == 'S' || in == 's'
    I_filtrata = filtraggio(I_filtrata,map)
    figure(4)
    imshow(I_filtrata,map);colorbar;title('Immagine filtrata finale')
else
    figure(4)
    imshow(I_filtrata,map);colorbar;title('Immagine filtrata finale')
end
