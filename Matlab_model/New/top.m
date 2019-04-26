N = 2048;

% Reding fft coefficients 
FID = fopen('fft_coefficients.txt','r');
coefficients=fscanf(FID,'%f');
% Reading inputs
FID1 = fopen('fft_inputs_fixed.txt','r');
fft_input=fscanf(FID1,'%f');

fclose('all');

for q = 1 : 1 : N
    fft_input_re(q) = fft_input(2*q-1);
    fft_input_im(q) = fft_input(2*q);
end

[mult_out_re, mult_out_im] = my_FFT(coefficients, fft_input_re,fft_input_im, N);

% FFT Reference
for a=1 : 1 : N
    input_complex(a) = fft_input_re(a)+1i*fft_input_im(a);
end
ref = fft(input_complex);
ref_inv = bitrevorder(ref);

ref_inv_re = real(ref_inv);
ref_inv_im = imag(ref_inv);
diff_re = ref_inv_re - mult_out_re;
diff_im = ref_inv_im - mult_out_im;
diff_re_procent = (diff_re./ref_inv_re)*100;

% ranges of axis 
r1 = -130;
r2 = 130;

figure(1);
clf;
subplot(2,1,2);
plot(diff_re);
axis([0 N -0.2 0.2]);
title('Difference between floating and fixed point');
subplot(2,1,1);
plot(ref_inv_re,'k'), hold on;
plot(mult_out_re,'--r');
axis([0 N r1 r2]);
legend('Floatin point','Fixed point');
title('2048 point FFT real numbers');

figure(2);
clf;
subplot(2,1,2);
plot(diff_im);
axis([0 N -0.2 0.2]);
title('Difference between floating and fixed point');
subplot(2,1,1);
plot(ref_inv_im,'k'), hold on;
plot(mult_out_im,'--r');
axis([0 N r1 r2]);
legend('Floatin point','Fixed point');
title('2048 point FFT imaginary numbers');


%reading IFFT coefficients 

% Reading IFFT inputs
FID2 = fopen('fft_outputs.txt','r');
ifft_input=fscanf(FID2,'%f');
for q = 1 : 1 : N
    ifft_input_re(q) = ifft_input(2*q-1);
    ifft_input_im(q) = ifft_input(2*q);
%     input_re(q) = fi(fft_input(2*q-1),s,w1,f1);
%     input_im(q) = fi(fft_input(2*q),s,w1,f1);
end

fclose('all');

[ifft_output_re, ifft_output_im] = my_FFT(coefficients, ifft_input_re,ifft_input_im, N);
%[ifft_output_re_inverted, ifft_output_im_inverted] = my_IFFT(coefficients, ifft_input_re,ifft_input_im, N)

ifft_output_re_inverted = ifft_output_im/N;
ifft_output_im_inverted = ifft_output_re/N;

% % IFFT Reference
% for a=1 : 1 : N
%     ifft_input_complex(a) = ifft_input_re(a)+1i*ifft_input_im(a);
% end
%  ref_inv = ifft(bitrevorder(ifft_input_complex));
%  ref_inv_re = real(ref_inv);
%  ref_inv_im = imag(ref_inv);
%  diff_re = ref_inv_re - input_re;
%  diff_im = ref_inv_im - input_im;
 
 diff_re = input_re - ifft_output_re_inverted;
 diff_im = input_im - ifft_output_im_inverted;
 
% ranges of axis 
r1 = -1;
r2 = 1;

figure(3);
clf;
subplot(2,1,2);
plot(diff_re);
axis([0 N -0.01 0.01]);
title('Difference given inputs and output of the IFFT');
subplot(2,1,1);
plot(ifft_output_re_inverted,'k'), hold on;
plot(fft_input_re,'--r');
axis([0 N r1 r2]);
legend('Output of the IFFT','Given Inputs');
title('2048 point IFFT real numbers');

figure(4);
clf;
subplot(2,1,2);
plot(diff_im);
axis([0 N -0.01 0.01]);
title('Difference between given inputs and output of the IFFT');
subplot(2,1,1);
plot(ifft_output_im_inverted,'k'), hold on;
plot(fft_input_im,'--r');
axis([0 N r1 r2]);
legend('Output of the IFFT','Given Inputs');
title('2048 point IFFT imaginary numbers');