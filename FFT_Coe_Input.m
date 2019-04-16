N = 2048;

% % FFT Coefficients
% % Generation of coefficients
% FID = fopen('fft_coefficients.txt','w+');
% 
% for kn=0 : 1 : N/2 -1
%         w = exp(-i*2*pi*kn/N);
%         re=real(w);
%         im=imag(w);
%        fprintf(FID,'%f\n',re);
%        fprintf(FID,'%f\n',im);
% end
% fclose(FID);


% FFT Inputs
% Generation of random numbers
rn = 1 + (-1-1).*rand([2*N,1]);

FID2 = fopen('fft_inputs.txt','w+');
fprintf(FID2,'%.12f\n',rn);
fclose(FID2);

