clear all;
clc;

N = 2048;

% FFT Coefficients
% Generation of coefficients
FID = fopen('fft_coefficients.txt','w+');

for kn=0 : 1 : N/2 -1
        w = exp(-i*2*pi*kn/N);
        re=real(w);
        im=imag(w);
       fprintf(FID,'%f\n',re);
       fprintf(FID,'%f\n',im);
end
fclose(FID);


% FFT Inputs
% Generation of random numbers
rn = rand([2*N,1]);

FID2 = fopen('fft_inputs.txt','w+');
fprintf(FID2,'%f\n',rn);
fclose(FID2);