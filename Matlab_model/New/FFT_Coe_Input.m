clear all;
N = 2048;
s = 1;  % 1 = signed , 0 = unsigned
w1 = 12; % wordlength
f1 = 10; % fractional point

% FFT Coefficients
% Generation of coefficients
FID = fopen('fft_coefficients.txt','w+');

for kn=0 : 1 : N/2 -1
        w = exp(-i*2*pi*kn/N);
        re=real(w);
        im=imag(w);
        re_fixed = fi(re,s,w1,f1);
        im_fixed = fi(im,s,w1,f1);
        fprintf(FID,'%.10f\n',re_fixed);
        fprintf(FID,'%.10f\n',im_fixed);
        
        %coefficients_complex(kn+1) = re+1i*im;
        coefficients_complex_fixed(kn+1) = re_fixed+1i*im_fixed;
end
fclose(FID);

% Creating vector with coefficients in complex form
figure(10),clf;
%plot(coefficients_complex), hold on;
plot(coefficients_complex_fixed,'r');



% IFFT Coefficients
% Generation of coefficients
FID1 = fopen('ifft_coefficients.txt','w+');

for kn=0 : 1 : N/2 -1
        w_i = exp(i*2*pi*kn/N);
        re_i=real(w_i);
        im_i=imag(w_i);
       fprintf(FID1,'%f\n',re_i);
       fprintf(FID1,'%f\n',im_i);
end
fclose(FID1);


% FFT Inputs
% Generation of random numbers
rn = 1 + (-1-1).*rand([2*N,1]);

% changing to fixed point
rn_fixed = fi(rn,s,w1,f1);

FID2 = fopen('fft_inputs.txt','w+');
fprintf(FID2,'%.10f\n',rn);
FID3 = fopen('fft_inputs_fixed.txt','w+');
fprintf(FID3,'%.10f\n',rn_fixed);
fclose('all');

