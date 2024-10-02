% Implementazione di un filtro passa basso 

function risultato = fpbg(I,soglia)

[m n] = size(I)

% Effettuo l'operazione di padding

p = 2*m
q = 2*n

I_con_padding = zeros(p,q)
I_con_padding(1:m,1:n) = I % metto l'immagine in alto a destra

% Centratura dell'immagine
for i = 1:p
    for j = 1:q
        I_con_padding_centrata(i,j) = I_con_padding(i,j)*((-1)^(i+j));
    end
end

% Trasformata di fourier
FFT_I = fft2(I_con_padding_centrata)

% Creazione filtro gaussiano in base alla soglia fornita e utilizzando la
% formula
d0 = soglia

d = zeros(p,q)
H = zeros(p,q)

for i=1:m
    for j=1:n
     d(i,j)=  sqrt((i-(p/2))^2 + (j-(q/2))^2);
    end
end

for i=1:p
    for j=1:q
      H(i,j)= exp (-( (d(i,j)^2)/(2*(d0^2))));
    end
end

% Moltiplico l'immagine con il filtro (sono nel dominio delle frequenze)
I_filtrata = FFT_I.*H

% Utilizzo la trasformata di fourier inversa per riottenere l'immagine con
% centratura
inversa_FFT = real(ifft2(I_filtrata))

for i=1:p
    for j=1:q
         ifim(i,j)=inversa_FFT(i,j)*((-1)^(i+j));
    end
end

% Rimuovo il padding per tornare all'immagine mxn
I_result_senza_padding = ifim(1:m,1:n);
risultato=uint8(I_result_senza_padding);
